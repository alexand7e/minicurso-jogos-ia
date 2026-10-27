# Constituição do projeto

Princípios que valem para toda spec, plano e tarefa. Se uma proposta os contradiz, a proposta muda, não o princípio
(a menos que o time decida alterar esta constituição de propósito).

1. **Jogável primeiro.** Depois de cada tarefa o jogo precisa abrir e jogar. Nada de deixar o projeto quebrado "até a próxima tarefa".
2. **Escopo mínimo.** Cada spec entrega a menor mudança que o jogador consegue sentir. O resto vai para "Fora do escopo".
3. **Uma fonte de verdade para números e textos.** Tudo que define a "cara" do jogo mora em `config.gd`.
4. **Critério sem verificação não existe.** Cada CA-xx é checado por `tests/run_tests.gd` ou, quando só dá para sentir jogando, marcado como "manual" na spec.
5. **Tarefas pequenas.** Uma tarefa cabe em uma conversa curta com a IA e termina com `scripts/check.sh` passando.
6. **A IA propõe, o time decide.** A IA escreve rascunhos de spec, plano e código; quem aprova cada etapa é uma pessoa do time.
7. **Licença conhecida.** Arte, som e fonte só entram com licença registrada em Créditos no `README.md`.
8. **Código simples.** Prefira o que um colega iniciante entende: nomes claros, funções curtas, comentários que explicam o porquê.

## Definição de pronto (vale para toda tarefa)

- [ ] `scripts/check.sh` termina com código 0.
- [ ] Alguém jogou uma partida e os critérios "manuais" da spec foram conferidos.
- [ ] O `tasks.md` está atualizado e nenhum arquivo foi mexido fora do que o plano previu.
