---
description: Etapa 1 do SDD. Cria a spec de uma mudança (o quê e por quê, sem código)
argument-hint: <ideia da mudança em uma frase>
---

Crie a SPEC da seguinte mudança no jogo: $ARGUMENTS

1. Leia `AGENTS.md`, `specs/constitution.md` e `specs/000-jogo-base/spec.md`.
2. Descubra o próximo número: liste as pastas `specs/[0-9]*` e use o maior número mais 1, com três dígitos.
   Crie `specs/NNN-nome-curto/spec.md` a partir de `specs/templates/spec-template.md`.
3. Escreva só o QUÊ e o POR QUÊ, do ponto de vista de quem joga. Nada de arquivos, funções ou código.
4. Escreva critérios de aceitação verificáveis (CA-xx). Continue a numeração a partir do último CA usado
   em `specs/` e em `tests/run_tests.gd`. Se algo só puder ser conferido jogando, marque como "(manual)".
5. Mantenha o escopo mínimo: tudo que não é essencial vai para "Fora do escopo".
6. Se algo importante estiver ambíguo, não invente: registre em "Perguntas em aberto" e faça até 3 perguntas ao humano.

Não crie plano, tarefas nem código. Termine mostrando a spec e pedindo revisão.
