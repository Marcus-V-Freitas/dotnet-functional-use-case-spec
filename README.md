# .NET Functional Use Case Spec

Agent Skill e Gemini Gem focados em **documentar, revisar, criar e evoluir
funcionalidades/casos de uso C#/.NET**.

## Foco

O foco não é uma classe chamada `Handler`.

O foco é a **funcionalidade de negócio completa**.

Ela pode estar implementada como:

```text
Handler
UseCase
CommandHandler
QueryHandler
ApplicationService
Service
Consumer
Processor
Job
Workflow
```

ou uma composição desses elementos.

## Modelo

```text
Business Functionality
        ↓
Entry Point
        ↓
Input Payload
        ↓
Validation
        ↓
Use-case Orchestrator
    ┌──────┼──────────┐
    ↓      ↓          ↓
 Service  Policy   Repository
    ↓                 ↓
External API        Database
    ↓
Messaging
        ↓
Possible Outputs
```

## Documentação por funcionalidade

Padrão recomendado:

```text
docs/use-cases/<Application>/<UseCaseName>.md
```

Exemplo:

```text
docs/use-cases/
├── Orders.Api/
│   ├── CreateOrder.md
│   └── CancelOrder.md
└── Billing.Worker/
    └── ProcessPayment.md
```

## Conteúdo obrigatório

Cada especificação contém:

- título;
- função;
- objetivo de negócio;
- linguagem de negócio;
- entry point;
- payload de entrada;
- possíveis outputs;
- cenários de sucesso;
- falhas esperadas;
- exceções técnicas;
- C4;
- integrações;
- riscos;
- análise de responsabilidades;
- sugestões de decomposição;
- cenários de teste;
- cobertura;
- arquivos relacionados.

## Payload de entrada

A especificação mostra:

- campos;
- obrigatoriedade;
- significado;
- validação;
- exemplo.

## Outputs

A especificação não documenta apenas sucesso.

Também cobre:

- Success;
- Validation;
- NotFound;
- Conflict;
- BusinessRuleViolation;
- Duplicate/Idempotent;
- outros Results;
- HTTP status/body;
- mensagens produzidas;
- comportamentos de retry/DLQ quando aplicável.

## Responsabilidades e padrões

A skill verifica se o caso de uso está concentrando responsabilidade demais.

Pode sugerir:

- Service;
- Domain Service;
- Strategy;
- Factory;
- Decorator;
- Adapter;
- Policy;
- Specification;
- Pipeline;
- Chain of Responsibility.

Nenhum padrão é aplicado por estética.

Toda extração deve justificar coesão, testabilidade, clareza e custo.

## Testes

Prioriza:

```text
Arrange
Act
Assert
```

e cenários de negócio no estilo:

```text
Given <condição>
When <ação>
Then <resultado>
```

Preferências:

- FluentAssertions;
- NSubstitute;
- Testcontainers.

Evita `Arg.Any`, exceto em `DidNotReceive()` quando o argumento é realmente
irrelevante.

Quando uma responsabilidade é extraída:

```text
Use Case
    ↓
teste de orquestração

Service/Policy/Strategy
    ↓
testes unitários próprios

Database/Broker/API
    ↓
integration/component tests quando necessário
```

## Relação com o arquiteto macro

```text
dotnet-software-architect
        ↓
arquitetura do sistema

dotnet-functional-use-case-spec
        ↓
uma funcionalidade completa
```

A skill funcional pode ler `.architecture/` quando existe, mas não precisa gerar toda
a documentação global.

## Distribuições

```text
.
├── skills/
│   └── dotnet-functional-use-case-spec/
└── gem/
    └── dotnet-functional-use-case-spec/
```
