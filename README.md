# .NET Functional Use Case Spec & Developer Skills Catalog

Catálogo de **Agent Skills** especializadas para engenharia de software C#/.NET, arquitetura de sistemas, análise de requisitos e ecossistema bancário/PJ.

Projetado para agentes de IA como **GitHub Copilot**, **Claude Code**, **Gemini Code Assist / CLI** e **Google Antigravity**.

---

## Foco e Filosofia

O foco não é uma classe isolada chamada `Handler`. O foco é a **funcionalidade de negócio completa**.

Uma funcionalidade de negócio pode estar implementada como:

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

### Modelo Conceitual

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

---

## Catálogo de Skills

| Skill | Foco Principal | Quando Usar |
| :--- | :--- | :--- |
| **[`dotnet-functional-use-case-spec`](./skills/dotnet-functional-use-case-spec/)** | Especificação e decomposição funcional | Mapeamento completo de entrada, validação, orquestração, outputs, erros e decomposição de casos de uso. |
| **[`architecture-decision-advisor`](./skills/architecture-decision-advisor/)** | Decisões arquiteturais, trade-offs e ADRs | Escolha entre comunicação síncrona/assíncrona, consistência, topologia, Apigee e mensageria. |
| **[`code-solution-designer`](./skills/code-solution-designer/)** | Design de algoritmos e estrutura interna | Desenho de algoritmos, tipos, fluxo e encaixe no código antes da implementação interna em C#/.NET. |
| **[`banking-test-engineer`](./skills/banking-test-engineer/)** | Engenharia de testes automatizados C#/.NET | Criação de suítes completas de testes unitários/integração (FluentAssertions, NSubstitute, Bogus, AutoFaker). |
| **[`pragmatic-technical-debt-review`](./skills/pragmatic-technical-debt-review/)** | Code review de defeitos e riscos reais | Análise pragmática de concorrência, idempotência, race conditions, transações e perda de mensagens. |
| **[`requirements-insight-analyst`](./skills/requirements-insight-analyst/)** | Análise e refinamento de requisitos | Tradução de cards Jira/Azure Boards, prints e contratos em fluxos sequenciais acionáveis e critérios de aceite. |
| **[`business-flow-documentation`](./skills/business-flow-documentation/)** | Documentação de fluxos de negócio (.md) | Criação de documentação funcional pós-implementação em Markdown com diagramas Mermaid de sequência. |
| **[`banking-innovation-lab`](./skills/banking-innovation-lab/)** | Ideação bancária e desenho de pilotos | Estruturação de MVPs e oportunidades com ou sem IA sob restrições técnicas e arquiteturais. |

---

## Fluxo de Trabalho Integrado

As skills atuam sinergicamente durante o ciclo de engenharia:

```text
[Requisitos / Card]
        ↓
  requirements-insight-analyst (refina card, mapeia bifurcações e dúvidas)
        ↓
  architecture-decision-advisor (se houver decisão entre sistemas / mensageria / ADR)
        ↓
  code-solution-designer (se a solução interna exigir algoritmo ou desenho prévio)
        ↓
  dotnet-functional-use-case-spec (especificação completa do caso de uso e orquestrador)
        ↓
  banking-test-engineer (geração da suíte de testes ponta a ponta)
        ↓
  pragmatic-technical-debt-review (revisão de riscos de concorrência e resiliência)
        ↓
  business-flow-documentation (documentação final do fluxo de negócio implementado)
```

---

## Estrutura do Repositório

```text
.
├── skills/
│   ├── architecture-decision-advisor/
│   ├── banking-innovation-lab/
│   ├── banking-test-engineer/
│   ├── business-flow-documentation/
│   ├── code-solution-designer/
│   ├── dotnet-functional-use-case-spec/
│   ├── pragmatic-technical-debt-review/
│   ├── requirements-insight-analyst/
│   ├── install.ps1
│   ├── install.sh
│   └── README.md
└── README.md
```

---

## Instalação Rápida

Os instaladores configuram as skills nos diretórios reconhecidos por cada ferramenta (`.github/skills`, `.claude/skills`, `.gemini/skills`, `.agents/skills` ou seus equivalentes no perfil de usuário):

### PowerShell (`install.ps1`)

```powershell
# Instala todas as skills no projeto atual para todas as ferramentas
pwsh ./skills/install.ps1

# Instala no escopo global do usuário
pwsh ./skills/install.ps1 -Scope user

# Instala apenas uma skill específica (ex: dotnet-functional-use-case-spec)
pwsh ./skills/install.ps1 -Skill dotnet-functional-use-case-spec
```

### Bash (`install.sh`)

```bash
# Instala todas as skills no projeto atual
./skills/install.sh

# Instala no escopo de usuário
./skills/install.sh all user

# Instala apenas uma skill específica
./skills/install.sh all project . dotnet-functional-use-case-spec
```

Para instruções detalhadas de compatibilidade e parâmetros avançados, consulte o [Guia de Skills](skills/README.md).
