# Testing and Decomposition Policy

## Test intent

Tests must prove business behavior rather than internal implementation shape.

Use Arrange / Act / Assert.

Prefer test names that express business scenarios:

```text
Given_customer_is_blocked
When_order_is_created
Then_creation_is_rejected
```

or:

```text
Should_reject_order_creation_when_customer_is_blocked
```

## Test levels

### Unit test — pure business responsibility

Use for:

- policies;
- specifications;
- strategies;
- domain services;
- calculations;
- validators;
- small business services.

Avoid infrastructure.

### Use-case/orchestration unit test

Test the orchestrator's business collaboration:

- correct dependency called;
- correct Result returned;
- side effect happens only when expected;
- side effect does not happen on rejection;
- sequence-sensitive behavior only when sequence is a contract.

Do not re-test every internal rule already fully covered by an extracted business
service unless necessary to prove orchestration.

### Integration/component test

Use when infrastructure semantics matter:

- EF Core query translation;
- database constraints;
- transactions;
- Mongo behavior;
- broker interaction;
- serialization;
- HTTP adapter behavior;
- idempotency/outbox behavior.

Prefer Testcontainers where practical.

## NSubstitute

Prefer exact argument matching or `Arg.Is<T>(...)`.

Avoid `Arg.Any<T>()`.

Allowed exception:

- negative interaction assertions using `DidNotReceive()` where the argument truly
  does not matter.

Use `Substitute.ForPartsOf<T>()` only when partial substitution is genuinely
necessary and safe.

## FluentAssertions

Use clear assertions around business outcomes.

Avoid giant equivalency assertions when only a subset of fields matters.

## LoggerMessage

Test source-generated logging through observable `ILogger` calls.

With NSubstitute, `ReceivedCalls()` may be used to inspect:

- log level;
- EventId;
- structured state;
- formatted message;
- exception.

Prefer structured properties over brittle full-text message assertions when possible.

## Decomposition guidance

Extract a new service/policy/strategy only when the responsibility is cohesive.

Good extraction signals:

- a responsibility can be named in business language;
- it has multiple branches worth testing independently;
- it is reused;
- it hides integration-specific complexity;
- it reduces constructor/dependency pressure in the orchestrator;
- it turns a long method into a readable business sequence.

Bad extraction signals:

- one-line forwarding wrappers;
- abstractions with one trivial implementation and no boundary value;
- moving private methods into classes without gaining cohesion/testability;
- applying patterns only to satisfy architecture aesthetics.

## Pattern selection

### Strategy

Use for interchangeable algorithms/rules.

Tests:
- one unit test suite per strategy;
- selection logic tested separately.

### Factory

Use for meaningful creation/selection logic.

Tests:
- mapping from business condition to created strategy/object;
- unsupported condition behavior.

### Decorator

Use for cross-cutting wrappers around the same contract.

Tests:
- wrapped behavior preserved;
- extra behavior occurs;
- failure propagation/short-circuit behavior.

### Adapter

Use to isolate an external dependency.

Tests:
- contract mapping;
- error translation;
- serialization;
- retry/timeout ownership when relevant.

### Policy / Specification

Use for reusable eligibility/decision rules.

Tests:
- business matrix of accepted/rejected scenarios.

### Pipeline / Chain of Responsibility

Use for ordered processing steps.

Tests:
- individual step behavior;
- ordering when ordering matters;
- stop/continue behavior.

## Test section in specification

Every use-case specification must include:

- important business scenarios;
- expected test names or existing test methods;
- which scenarios are covered;
- which scenarios are missing or weak;
- whether infrastructure tests are required.

A useful matrix:

| Scenario | Level | Expected assertion |
|---|---|---|
| Success | Use-case unit | Result success + expected side effects |
| Business rejection | Use-case/unit | Failure result + no forbidden side effects |
| Policy rule | Policy unit | Accepted/rejected matrix |
| Persistence semantics | Integration | Real provider behavior |
| Messaging | Component/integration | Contract + idempotency/delivery behavior |
