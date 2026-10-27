---
description: Etapa 2 do SDD. Cria o plano técnico de uma spec aprovada
argument-hint: <número ou nome da spec; vazio = a mais recente>
---

Crie o PLANO da spec: $ARGUMENTS (se vazio, use a pasta `specs/NNN-*` de maior número).

1. Leia a `spec.md` da pasta, `AGENTS.md`, `specs/constitution.md` e os arquivos de código que a mudança tocaria.
2. Crie `plan.md` na mesma pasta a partir de `specs/templates/plan-template.md`.
3. Escolha a abordagem mais simples que atende a spec. Liste os arquivos afetados e as chaves novas de `config.gd`
   (com valor inicial e unidade).
4. Na tabela "Como cada critério será verificado", dê a cada CA um teste de `tests/run_tests.gd` (nome da função)
   ou, se for "manual", o que observar jogando.
5. Se o plano exigir mudar o que a spec decidiu, pare e proponha o ajuste à spec em vez de seguir adiante.

Não escreva tarefas nem código. Termine mostrando o plano e pedindo revisão.
