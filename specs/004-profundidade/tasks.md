# Tarefas 004: Profundidade

> Cada tarefa é pequena, deixa o jogo jogável e tem uma verificação. Ordem: configuração, teste, código, jogar.
> Marque `[x]` ao concluir. Uma tarefa por vez.

- [x] **T1** `config.gd`: `DEPTH_CAMERA` e `DEPTH_CAMERA_HEIGHT`. Verificação: check passa (nada usa ainda).
- [x] **T2** Teste primeiro: escrever CA-30 a CA-32. Verificação: o check **falha** nos grupos novos.
- [x] **T3** `tall.gd` e `scenery.gd`: prédios, portal, placa, copas e mastro em perspectiva. Verificação: CA-30 e
  CA-31 (menos a ordem dos inimigos) passam; captura de tela mostra o volume.
- [x] **T4** `player.gd` e `mob.gd`: sombras e inimigos por cima. Verificação: CA-31 e CA-32 passam, e os antigos
  continuam passando.
- [ ] **T-final** Rodar `scripts/check.sh` (código 0) e jogar as duas fases, conferindo CA-33 e CA-34.
