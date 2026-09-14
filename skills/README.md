# dotnet-functional-use-case-spec — Agent Skill

Skill focada em **funcionalidades/casos de uso completos** de aplicações C#/.NET.

Ela substitui a visão restrita de "Handler" por uma visão funcional.

Uma funcionalidade pode estar implementada como:

- Handler;
- UseCase;
- CommandHandler;
- QueryHandler;
- ApplicationService;
- Service;
- Consumer;
- Processor;
- Job;
- Workflow.

## Diferença para `dotnet-software-architect`

```text
dotnet-software-architect
→ arquitetura macro

dotnet-functional-use-case-spec
→ funcionalidade/caso de uso micro
```

## Estrutura recomendada

```text
docs/
└── use-cases/
    ├── Orders.Api/
    │   ├── CreateOrder.md
    │   └── CancelOrder.md
    └── Billing.Worker/
        └── ProcessPayment.md
```

## Cada especificação inclui

- título;
- função;
- objetivo;
- linguagem de negócio;
- entry point;
- payload de entrada;
- todos os outputs relevantes;
- cenários de sucesso;
- falhas esperadas;
- exceções técnicas;
- C4;
- APIs externas;
- mensageria;
- bancos;
- riscos;
- avaliação de decomposição;
- formato de testes;
- cobertura;
- código relacionado.

## Exemplo — apenas especificação

```text
Use dotnet-functional-use-case-spec.

Gere apenas a especificação funcional do caso de uso CancelOrder.
Não gere a documentação arquitetural global.
```

## Exemplo — alteração

```text
Use dotnet-functional-use-case-spec.

Altere o caso de uso CancelOrder para impedir cancelamento após faturamento.

Atualize:
- input/output se necessário;
- cenários;
- riscos;
- testes;
- decomposição de responsabilidades;
- especificação.
```

## Exemplo — revisão de responsabilidade

```text
Use dotnet-functional-use-case-spec.

Revise CreateOrder. Verifique se o orquestrador está concentrando responsabilidades
demais e se algum comportamento deveria ser extraído para Service, Policy, Strategy,
Factory, Decorator, Adapter ou outro padrão apropriado.
```
