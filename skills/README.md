# Catálogo de Agent Skills — C#/.NET & Banking

Coleção de **Agent Skills** especializadas para agentes de inteligência artificial (GitHub Copilot, Claude Code, Gemini CLI, Google Antigravity).

As skills cobrem todo o ciclo de vida do desenvolvimento em .NET e sistemas corporativos/bancários — desde a descoberta de requisitos e decisões de arquitetura até especificação funcional, implementação, testes e documentação de negócio.

---

## Skills Disponíveis

| Skill | Foco Principal | Quando Usar |
| :--- | :--- | :--- |
| **[`architecture-decision-advisor`](./architecture-decision-advisor/)** | Decisões de arquitetura, trade-offs e ADRs | Escolha de comunicação (síncrona/assíncrona), consistência, topologia, Apigee e mensageria. |
| **[`banking-innovation-lab`](./banking-innovation-lab/)** | Ideação bancária PJ e desenho de pilotos | Estruturação de MVPs e oportunidades com ou sem IA sob restrições regulatórias e arquiteturais. |
| **[`banking-test-engineer`](./banking-test-engineer/)** | Engenharia de testes automatizados C#/.NET | Criação de testes unitários/integração com FluentAssertions, NSubstitute, Bogus e AutoFaker. |
| **[`business-flow-documentation`](./business-flow-documentation/)** | Documentação de fluxo de negócio (.md) | Documentação de funcionalidades já implementadas com linguagem de negócio e diagramas Mermaid. |
| **[`code-solution-designer`](./code-solution-designer/)** | Design de algoritmos e estrutura de código | Desenho de classes, fluxo e encaixe dentro da aplicação antes de escrever a implementação. |
| **[`dotnet-functional-use-case-spec`](./dotnet-functional-use-case-spec/)** | Especificação funcional de caso de uso | Mapeamento completo de entrada, validação, orquestração, outputs, erros e decomposição. |
| **[`pragmatic-technical-debt-review`](./pragmatic-technical-debt-review/)** | Code review de defeitos e riscos reais | Análise pragmática de race conditions, idempotência, concorrência, perda de mensagens e resiliência. |
| **[`requirements-insight-analyst`](./requirements-insight-analyst/)** | Refinamento e análise de requisitos | Tradução de cards Jira/Azure Boards, prints e OpenAPI em fluxos sequenciais e critérios de aceite. |

---

## Fluxo de Trabalho Recomendado

As skills se complementam e podem ser orquestradas ao longo do fluxo de engenharia:

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

## Instalação das Skills

Os scripts de instalação instalam automaticamente todas as skills ou uma skill específica no seu projeto ou perfil global de usuário.

### Ferramentas Suportadas

| Target | Agente / Ferramenta | Escopo Projeto | Escopo Usuário (Global) |
| :--- | :--- | :--- | :--- |
| `github` | GitHub Copilot | `.github/skills/` | `~/.copilot/skills/` |
| `claude` | Claude Code (Anthropic) | `.claude/skills/` | `~/.claude/skills/` |
| `gemini` | Gemini CLI / Code Assist | `.gemini/skills/` | `~/.gemini/skills/` |
| `antigravity` | Google Antigravity | `.agents/skills/` | `~/.gemini/antigravity/skills/` e `~/.gemini/config/skills/` |
| `all` | Todas as ferramentas acima | Todos os diretórios locais | Todos os diretórios de usuário |

---

### Usando PowerShell (`install.ps1`)

```powershell
# Instalar TODAS as skills no projeto atual para todas as ferramentas (padrão)
pwsh ./skills/install.ps1

# Instalar no projeto apenas para Google Antigravity
pwsh ./skills/install.ps1 -Target antigravity

# Instalar no escopo global do usuário (todas as ferramentas)
pwsh ./skills/install.ps1 -Scope user

# Instalar apenas uma skill específica (ex: dotnet-functional-use-case-spec)
pwsh ./skills/install.ps1 -Skill dotnet-functional-use-case-spec

# Instalar uma skill específica para o Claude no escopo global
pwsh ./skills/install.ps1 -Target claude -Scope user -Skill pragmatic-technical-debt-review
```

#### Parâmetros do `install.ps1`

- `-Target`: `all` (padrão), `github`, `claude`, `gemini`, `antigravity`
- `-Scope`: `project` (padrão) ou `user`
- `-ProjectPath`: Caminho do projeto de destino (padrão: diretório atual de execução)
- `-Skill`: `all` (padrão) ou o nome de uma pasta de skill específica

---

### Usando Bash (`install.sh`)

```bash
# Sintaxe:
# ./skills/install.sh [TARGET] [SCOPE] [PROJECT_PATH] [SKILL]

# Instalar TODAS as skills no projeto atual para todas as ferramentas
./skills/install.sh

# Instalar apenas para Claude Code no projeto atual
./skills/install.sh claude

# Instalar todas as skills no escopo global de usuário
./skills/install.sh all user

# Instalar uma skill específica no projeto atual
./skills/install.sh all project . dotnet-functional-use-case-spec

# Instalar uma skill específica para o Antigravity no escopo global
./skills/install.sh antigravity user . banking-test-engineer
```
