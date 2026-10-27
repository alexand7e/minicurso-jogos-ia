---
description: Etapa 3 do SDD. Quebra o plano em tarefas pequenas, cada uma com verificação
argument-hint: <número ou nome da spec; vazio = a mais recente>
---

Crie as TAREFAS da spec: $ARGUMENTS (se vazio, use a pasta `specs/NNN-*` de maior número).

1. Leia `spec.md` e `plan.md` da pasta e `specs/constitution.md`.
2. Crie `tasks.md` na mesma pasta a partir de `specs/templates/tasks-template.md`.
3. Ordem das tarefas: configuração (`config.gd`), depois o teste do critério (que deve falhar), depois o código, por fim jogar.
4. Cada tarefa: pequena, deixa o jogo jogável e termina com uma verificação (`scripts/check.sh` ou algo observável).
5. Termine a lista com uma tarefa final que roda o check e confere os critérios manuais da spec.

Não implemente nada. Termine mostrando as tarefas e pedindo revisão.
