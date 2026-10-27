# Tarefas 001: Tema B-R-O Bró

> Cada tarefa é pequena, deixa o jogo jogável e tem uma verificação. Ordem: configuração, teste, código, jogar.
> Marque `[x]` ao concluir. Uma tarefa por vez.

- [x] **T1** Arte e música: criar `scripts/preparar_arte.gd` e `scripts/gerar_baiao.py`, gerar `art/teresina/` e
  registrar os Créditos no `README.md`. Verificação: `scripts/check.sh` passa (nada usa a arte ainda) e os 36 PNG
  e o WAV existem.
- [x] **T2** `config.gd`: textos e cor do tema, `ART_DIR`, `CHARACTERS`, `MOB_TYPES`, velocidades de animação,
  `MUSIC` e textos dos botões. Verificação: check passa; F5 mostra o título e o fundo novos.
- [x] **T3** Teste primeiro: escrever os testes de CA-05 a CA-09 em `tests/run_tests.gd`. Verificação: o check
  **falha** nos grupos novos (CA-05 a CA-08), porque inimigos, personagem e seletor ainda não existem.
- [x] **T4** `mob.gd`: inimigos do tema. Verificação: CA-05 passa.
- [x] **T5** `hud.gd`: seletor de personagem criado por código. Verificação: CA-06 passa.
- [x] **T6** `player.gd` e `main.gd`: `set_character` aplicado em `new_game()` com a escolha do HUD. Verificação: CA-07 e CA-08 passam.
- [x] **T7** `main.gd`: música nova em repetição. Verificação: check passa; F5 toca o baião.
- [ ] **T-final** Rodar `scripts/check.sh` (código 0) e jogar uma partida conferindo CA-10 a CA-14.
