---
description: Etapa 4 do SDD. Implementa UMA tarefa por vez e verifica
argument-hint: <tarefa, ex.: T2; vazio = próxima não concluída>
---

Implemente a tarefa: $ARGUMENTS (se vazio, a primeira tarefa sem `[x]` do `tasks.md` da pasta `specs/NNN-*` de maior número).

1. Antes de escrever código, leia a `spec.md`, o `plan.md`, o `tasks.md`, `AGENTS.md` e `specs/constitution.md`.
2. Faça somente o que a tarefa pede. Não adiante tarefas seguintes nem mexa em arquivos fora do plano.
3. Rode `scripts/check.sh`. Se falhar, leia a saída, corrija e rode de novo. Se não houver Godot disponível,
   diga isso claramente em vez de afirmar que verificou.
4. Se a verificação da tarefa for "o check deve falhar" (teste escrito antes do código), confirme que falhou pelo motivo esperado.
5. Marque a tarefa com `[x]` em `tasks.md`.
6. Se descobrir que a spec ou o plano estão errados ou incompletos, pare e proponha o ajuste ao documento; não contorne no código.

Termine com um resumo curto: arquivos alterados, resultado do check e, quando houver, o que o humano deve conferir jogando (F5).
Espere o humano antes de seguir para a próxima tarefa.
