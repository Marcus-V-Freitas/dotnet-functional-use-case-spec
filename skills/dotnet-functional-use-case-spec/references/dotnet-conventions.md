# .NET Conventions for Functional Use Cases

These conventions mirror the broader .NET Software Architect policy so this skill can
work independently.

## Architecture

Prefer hexagonal boundaries.

Domain/application behavior should not depend directly on HTTP, EF provider details,
MongoDB driver types, Refit, brokers, Aspire, or external SDKs.

Adapters implement ports owned by inner layers.

## Contracts

Use:

- `Request` for primary boundary input;
- `Response` for primary boundary output;
- `Dto` for supporting/transport structures.

Do not expose persistence models as public API contracts.

Prefer explicit manual mapping through focused extension/static mapping classes.

## Validation

Use FluentValidation for request/application validation and cross-field rules.

Keep invariants that must always hold protected by the domain model.

## Use-case orchestration

The application orchestrator may be a Handler, UseCase, ApplicationService, Consumer,
Processor, or similar type.

Do not require a specific suffix.

The orchestrator should remain readable as a sequence of business steps.

If it becomes too large, extract cohesive responsibilities.

## MediatR

Use MediatR when already adopted or when it provides a clear application boundary.

Do not introduce it solely to satisfy this skill.

## Result pattern

Prefer Result-style outcomes for expected business failures.

Use exceptions for unexpected infrastructure/programming failures.

Do not catch every exception simply to convert it into a generic Result.

## External HTTP

Prefer Refit or typed HttpClient abstractions when appropriate.

Keep integration-specific contracts in adapter boundaries.

Configure retries/timeouts/resilience outside domain logic.

Propagate cancellation where applicable.

## Serialization

Prefer `System.Text.Json` unless a concrete required capability justifies another
serializer.

## Data

For relational stores, prefer EF Core when compatible with project constraints.

For MongoDB, prefer the official EF Core provider when it supports required
capabilities. Use the native MongoDB driver in the adapter when necessary.

Treat `DbContext` as a unit-of-work boundary.

Do not automatically add a Generic Repository around EF Core.

Repositories are justified when they express a meaningful domain/application
boundary.

## Distributed consistency

Do not promise a single ACID transaction across unrelated databases, HTTP services,
and brokers.

Use local transactions plus patterns such as:

- Transactional Outbox;
- Inbox;
- idempotent consumer;
- Saga/compensation;
- explicit eventual consistency.

## Logging

Prefer structured source-generated `LoggerMessage` methods.

Do not log secrets, credentials, tokens, or confidential payloads.

## Runtime/packages

Prefer current stable supported .NET versions.

Do not adopt preview/RC by default.

Keep NuGet packages updated enough to avoid known relevant vulnerabilities, but do
not blindly upgrade without checking compatibility, licensing, and breaking changes.
