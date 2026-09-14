---
name: dotnet-functional-use-case-spec
description: >
  Analyzes, creates, reviews, updates, or documents a complete C#/.NET business
  functionality/use case. The implementation may be named Handler, UseCase,
  CommandHandler, QueryHandler, ApplicationService, Service, Consumer, Processor,
  or another domain/application orchestration type. Use this skill when the user
  wants to understand or modify one functionality, generate only its specification,
  verify documentation against current code, or ensure business functionalities in
  an API/Worker have individual business-oriented specifications.
---

# .NET Functional Use Case Spec

Act as a software architect focused on one business functionality/use case at a time.

The unit of analysis is the **complete business functionality**, not a class name.

A functionality may be implemented as:

- `Handler`;
- `UseCase`;
- `CommandHandler`;
- `QueryHandler`;
- `ApplicationService`;
- `Service`;
- `Processor`;
- `Consumer`;
- `Job`;
- `Workflow`;
- or a composition of multiple collaborators.

Do not assume that a type named `Handler` exists.

Trace the business entry point and identify the application/domain component that
actually coordinates the use case.

## Core principle

Document and reason about:

```text
Business capability
    ↓
Entry point
    ↓
Input payload
    ↓
Validation
    ↓
Use-case orchestrator
    ├─ Business services
    ├─ Decorators / policies
    ├─ Repositories / DbContext
    ├─ External APIs
    ├─ Messaging
    └─ Other side effects
    ↓
Possible outputs
```

The orchestrator may be a Handler, UseCase, ApplicationService, Consumer, Processor,
or similar type.

The specification must remain useful even if internal class names change.

## Primary modes

### 1. Create

Use when a functionality or its specification does not exist yet.

Understand the surrounding application and generate the specification before or
together with the implementation, depending on the user's request.

### 2. Update

Use when the functionality or its collaborators changed.

Compare the existing specification with current code and update only stale sections.

### 3. Review

Use when the user wants architectural/business review without changing code.

Identify mismatches, missing scenarios, weak contracts, risks, integration problems,
excessive orchestration responsibility, or unclear business behavior.

### 4. Spec only

Use when the user explicitly requests only the functionality specification.

In this mode:

- do not generate the full `.architecture/` wiki;
- do not create unrelated architecture documents;
- inspect only enough context to understand the functionality correctly;
- reuse relevant architecture context when available, but verify against source;
- create/update only the functionality specification and optional local index.

### 5. Bulk coverage

Use when asked to ensure that every business functionality in one or more APIs/Workers
has an individual specification.

Enumerate relevant entry points/use cases, identify missing/stale specifications, and
create/update them.

Do not create specifications for trivial plumbing classes with no business behavior.

## Discovering the functionality

Do not search only for `*Handler`.

Look for business entry points such as:

- Minimal API routes;
- controllers/actions;
- MediatR handlers;
- classes named `UseCase`;
- application services;
- domain services exposed as use cases;
- message consumers;
- processors;
- background jobs;
- hosted services;
- event handlers;
- scheduled operations;
- internal application commands.

Follow the call graph enough to identify:

- who receives the request/event;
- who coordinates the business operation;
- which services contain business decisions;
- which dependencies create side effects;
- how the operation finishes.

## Specification location

Follow an existing repository documentation convention when one exists.

Otherwise use:

```text
docs/use-cases/<application>/<UseCaseName>.md
```

Examples:

```text
docs/use-cases/Orders.Api/CreateOrder.md
docs/use-cases/Orders.Api/CancelOrder.md
docs/use-cases/Billing.Worker/ProcessPayment.md
```

Prefer business functionality names over class names.

For bulk coverage, optionally maintain:

```text
docs/use-cases/README.md
```

as a lightweight index.

## Required specification

Every functionality specification must be self-contained enough that a developer can
understand the use case without reading the entire architecture wiki.

Use [templates/use-case-spec.md](templates/use-case-spec.md).

Required sections:

1. Title
2. Function
3. Business objective
4. Business language
5. Entry point
6. Input payload
7. Possible outputs
8. Success scenarios
9. Expected business failures
10. Exceptional/infrastructure failures
11. C4 diagram
12. Integrations
13. Risks
14. Responsibility/decomposition assessment
15. Test scenarios and current coverage
16. Relevant code

## Input payload

Always document the input contract when one exists.

Include:

- route/body/query/header/event fields as applicable;
- required vs optional fields;
- business meaning;
- validation constraints;
- representative payload.

Do not use real secrets or production-sensitive data.

For HTTP, prefer a representative JSON example.

For messaging, show the event/message contract.

For internal commands, show the command/request shape.

## Possible outputs

Document **all materially different outputs**, not only the happy path.

Examples:

- success response;
- accepted/queued response;
- validation failure;
- not found;
- conflict;
- domain/business rejection;
- duplicate/idempotent result;
- partial result when the contract allows it;
- integration-specific mapped failure;
- technical error/problem response when externally observable.

For HTTP, document:

- status code;
- body/payload;
- business meaning.

For messaging, document:

- emitted message(s);
- no-message outcome;
- retry/dead-letter behavior when relevant.

For internal application calls, document the possible `Result`/union/outcome shapes.

## Function

Explain what the functionality actually coordinates.

Avoid vague descriptions such as:

> Processes the request.

Prefer:

> Coordinates order cancellation by validating whether the order can be cancelled,
> persisting the new state, requesting refund when required, and publishing the
> cancellation event.

## Business objective

Describe why the use case exists from the business perspective.

Avoid framework mechanics in this section.

## Business language

Prefer terminology used by the domain/business.

Document important terms, states, statuses, and business meanings needed to maintain
the functionality correctly.

## Scenarios

Separate scenarios into:

### Success

Describe each materially different successful business path.

### Expected business failure

Examples:

- validation rejection;
- normal not-found;
- duplicate operation;
- conflict;
- invalid state transition;
- policy rejection.

These should normally map to the project's Result pattern rather than exceptions.

### Exceptional / infrastructure failure

Examples:

- database unavailable;
- broker failure;
- external HTTP dependency unavailable;
- timeout;
- serialization failure;
- programming defect.

Do not mix expected business rejection with infrastructure exceptions.

## C4 diagram

Every specification must contain a useful C4-oriented view of the functionality.

Prefer Component-level when the use-case orchestrator and direct collaborators are
the focus.

Show only relevant elements:

- actor/trigger;
- API/Worker;
- use-case orchestrator;
- important business services;
- decorators/policies;
- external APIs;
- broker/topic/queue;
- database/repository boundary.

Use business-oriented labels.

Do not transform C4 into a class diagram.

If Mermaid C4 is supported, use it.

If not, use the repository's C4/PlantUML convention.

If neither exists, use a Mermaid flowchart preserving C4 concepts and clearly label
it as a fallback representation.

## Integrations

Classify integrations explicitly.

### External HTTP APIs

Detect Refit interfaces and other typed HTTP clients.

Document:

- purpose;
- called operation;
- request/response role;
- business reason;
- mapped failure behavior;
- timeout/retry/idempotency concerns.

### Messaging

Document:

- message consumed or produced;
- topic/queue/exchange when discoverable;
- business purpose;
- delivery semantics;
- retry/dead-letter behavior;
- idempotency concerns.

### Databases

Treat repository, DbContext, Mongo adapter, or equivalent as an integration boundary
for this micro-specification.

Document:

- repository/context;
- entity/aggregate/document;
- read/write behavior;
- transaction boundary;
- relevant consistency/concurrency concerns.

Also document cache/object storage when materially involved.

## Responsibility and decomposition assessment

A functionality spec must assess whether orchestration is too concentrated.

Look for:

- very long orchestration methods;
- multiple unrelated decisions in one class;
- data mapping mixed with business decisions;
- persistence logic mixed with business policy;
- HTTP/broker handling mixed directly into domain logic;
- large nested conditionals;
- repeated conditional branches;
- duplicated integration logic;
- too many constructor dependencies;
- behavior that is difficult to test without mocking many collaborators;
- cross-cutting behavior embedded directly in the use case.

When appropriate, recommend decomposition.

### Prefer focused services when

A cohesive business responsibility can be named independently.

Examples:

- `PricingService`;
- `CancellationPolicy`;
- `PaymentAuthorizationService`;
- `OrderEligibilityService`.

### Prefer Strategy when

There are interchangeable algorithms or business rules selected at runtime.

### Prefer Factory when

Object/strategy creation depends on meaningful runtime/business conditions.

### Prefer Decorator when

Cross-cutting behavior wraps the same contract, such as caching, metrics,
authorization, auditing, retry ownership, or enrichment.

### Prefer Adapter when

Infrastructure-specific contracts need to be isolated from inner layers.

### Prefer Specification / Policy when

Business eligibility/decision rules need reusable and explicit representation.

### Prefer Chain of Responsibility / Pipeline when

There is a sequence of independently testable processing steps.

### Prefer Domain Service when

A business rule does not naturally belong to a single aggregate/entity.

Do not introduce a design pattern only to make the code look architectural.

Every proposed extraction must explain:

- responsibility being extracted;
- why the boundary is cohesive;
- how testing improves;
- how the business flow becomes easier to understand;
- what complexity is added.

## Modification workflow

When the user asks to create, change, or improve behavior:

1. Read the current specification if present.
2. Inspect current implementation.
3. Identify the requested business change.
4. Map affected input/output contracts.
5. Map affected scenarios.
6. Identify exact source change points.
7. Evaluate integrations and risks.
8. Assess whether responsibilities should be decomposed.
9. Update the specification for desired behavior.
10. Implement if requested.
11. Add/update tests.
12. Re-read the final implementation.
13. Correct the specification if implementation and plan diverged.
14. Report remaining uncertainty.

For a local change, this specification may act as the local trade-off/change plan.

Do not require the full project architecture document unless the change has broader
architectural impact.

## C#/.NET conventions

Read [references/dotnet-conventions.md](references/dotnet-conventions.md) when
reviewing or changing code.

Preserve:

- hexagonal boundaries;
- Request / Response / Dto naming;
- Result pattern for expected business failures;
- exceptions for truly exceptional failures;
- FluentValidation;
- MediatR when appropriate/already adopted;
- Refit;
- manual mappings;
- `System.Text.Json`;
- EF Core preference when compatible;
- MongoDB EF Core provider when sufficient;
- native MongoDB driver when necessary;
- no automatic Generic Repository requirement;
- local transactions plus Outbox/Inbox/Saga/idempotency when needed;
- `LoggerMessage` source-generated logging;
- current stable supported .NET;
- NuGet vulnerability awareness.

## Testing conventions

Read [references/testing-and-decomposition.md](references/testing-and-decomposition.md).

For every behavior change, tests must be business-scenario oriented.

Preferred styles:

### AAA

```text
Arrange
Act
Assert
```

### Given / When / Then naming

```text
Given <business condition>
When <operation>
Then <business outcome>
```

Use:

- FluentAssertions;
- NSubstitute;
- exact arguments or `Arg.Is(...)`;
- avoid `Arg.Any(...)` except negative `DidNotReceive()` assertions where the
  argument is intentionally irrelevant;
- Testcontainers when infrastructure semantics matter.

When a use case is decomposed into services/policies/strategies:

- unit test each extracted business responsibility;
- keep orchestration tests focused on collaboration and overall outcome;
- avoid duplicating every service rule again in orchestration tests;
- add integration tests for persistence/messaging/HTTP behavior where semantics
  matter.

## Documentation freshness

Treat source code and executable configuration as authoritative.

A specification is stale when relevant parts changed:

- entry point;
- input contract;
- output contract;
- orchestrator;
- validator;
- service/policy/decorator;
- repository/data access;
- external client;
- message contract;
- route/trigger;
- tests;
- logging/metrics.

When updating, modify only affected sections.

## Completion gate

Before declaring a specification complete:

1. Verify the actual business entry point.
2. Verify the full business sequence.
3. Verify input payload.
4. Verify all materially different outputs.
5. Verify relevant service/decorator/policy calls.
6. Verify HTTP/messaging/database integrations.
7. Verify success/failure scenarios.
8. Verify Result vs exception semantics.
9. Verify risks.
10. Verify decomposition/responsibility quality.
11. Verify C4 representation.
12. Verify tests or explicitly identify missing coverage.
13. Ensure business-oriented language is used.

Do not claim a path, integration, output, or scenario was verified if it was not
inspected.
