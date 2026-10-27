# Tarefas 002: Duas fases pelas ruas de Teresina

> Cada tarefa é pequena, deixa o jogo jogável e tem uma verificação. Ordem: configuração, teste, código, jogar.
> Marque `[x]` ao concluir. Uma tarefa por vez.

- [x] **T1** Peças de cenário: ampliar `scripts/preparar_arte.gd`, gerar `art/teresina/cenario/` e registrar os Créditos.
  Verificação: check passa; as 10 peças existem.
- [x] **T2** `config.gd`: `SCROLL_SPEED` e `PHASES`. Verificação: check passa (nada usa ainda).
- [x] **T3** Teste primeiro: escrever CA-15 a CA-18. Verificação: o check **falha** nos grupos novos (não há `Scenery` nem fases).
- [x] **T4** `scenery.gd` com os dois trechos, criado pelo `Main`, e a rolagem ligada à partida. Verificação: CA-15 e CA-16 passam; F5 mostra a Raul Lopes andando.
- [x] **T5** `main.gd`: troca de fase pela pontuação e volta à fase 1. Verificação: CA-17 e CA-18 passam.
- [x] **T6** `hud.gd`: contorno nos textos. Verificação: check passa; texto legível sobre o cenário (captura de tela).
- [ ] **T-final** Rodar `scripts/check.sh` (código 0) e jogar até a fase 2, conferindo CA-19 a CA-23.
