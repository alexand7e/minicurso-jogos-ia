# Tarefas 003: Contato com o cenário

> Cada tarefa é pequena, deixa o jogo jogável e tem uma verificação. Ordem: configuração, teste, código, jogar.
> Marque `[x]` ao concluir. Uma tarefa por vez.

- [x] **T1** `config.gd`: `GROUND_SPEED`. Verificação: check passa (nada usa ainda).
- [x] **T2** Teste primeiro: escrever CA-24 a CA-27. Verificação: o check **falha** nos grupos novos.
- [x] **T3** `scenery.gd`: obstáculos, tipos de chão e carros junto ao meio-fio. Verificação: CA-27 passa; com
  *Formas de colisão visíveis*, F5 mostra os obstáculos no lugar.
- [x] **T4** `player.gd` e `main.gd`: empurrão, passo pelo chão e movimento com obstáculos. Verificação: CA-24 a CA-26
  passam, e os antigos continuam passando.
- [ ] **T-final** Rodar `scripts/check.sh` (código 0) e jogar as duas fases, conferindo CA-28 e CA-29.
