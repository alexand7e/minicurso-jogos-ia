# Tarefas 001: Dificuldade progressiva

> Uma tarefa por vez; marque `[x]` ao concluir.

- [x] **T1** Em `config.gd`, adicionar `MOB_SPEED_GAIN_PER_POINT` e `MOB_SPEED_CAP`. Verificação: `scripts/check.sh` continua passando (nada mudou no comportamento).
- [x] **T2** Teste primeiro: em `tests/run_tests.gd`, escrever `_test_ca05_a_07_dificuldade_progressiva` e chamá-la em `_run_all`. Verificação: o check **falha**, porque `mob_speed_range` ainda não existe. Isso prova que o teste testa algo.
- [ ] **T3** Em `main.gd`, criar `mob_speed_range(points)` e usá-la em `_on_MobTimer_timeout`. Verificação: `scripts/check.sh` passa, com 20 verificações.
- [ ] **T-final** Jogar cerca de 30 segundos e conferir o CA-08 (inimigos mais rápidos com o passar do tempo).
