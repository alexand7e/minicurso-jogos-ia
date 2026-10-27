# Spec 000: Jogo base

> Esta spec descreve o jogo no ponto de partida do minicurso. Foi escrita DEPOIS do código (o demo oficial
> Dodge the Creeps) para servir de referência: toda mudança nova parte daqui.

## Por quê
Dar a quem joga um desafio curto e imediato: sobreviver pelo maior tempo possível.

## O que o jogo faz
- O jogador move um personagem pela tela de 480 x 720 com as setas, WASD ou o direcional de um controle.
- Ao apertar o botão "Jogar" (ou Espaço/Enter), a partida começa: aparece a mensagem de preparar e, passados `START_DELAY` segundos, inimigos começam a surgir pelas bordas.
- Cada inimigo atravessa a tela em linha reta, com velocidade sorteada entre `MOB_MIN_SPEED` e `MOB_MAX_SPEED`, e some ao sair da tela. Um novo inimigo surge a cada `MOB_SPAWN_INTERVAL` segundos.
- A pontuação sobe `SCORE_PER_SECOND` a cada segundo de partida.
- Tocar em um inimigo encerra a partida: o jogador some, a música para, toca um som e aparece a mensagem de fim. Depois de alguns segundos o botão "Jogar" volta.

## Fora do escopo
Recorde salvo, vidas, power-ups, níveis, menu de opções.

## Critérios de aceitação
| ID | Critério | Verificado em |
| --- | --- | --- |
| CA-01 | Ao começar uma partida, a pontuação é 0 e o jogador aparece na posição inicial, com a mensagem de preparar na tela. | `_test_ca01_novo_jogo` |
| CA-02 | Durante o tempo de preparo a pontuação não muda; depois, sobe `SCORE_PER_SECOND` por segundo. | `_test_ca02_pontuacao_sobe` |
| CA-03 | Durante a partida existem inimigos em cena e todos estão em movimento. | `_test_ca03_inimigos_surgem` |
| CA-04 | Tocar em um inimigo faz o jogador sumir, para a contagem de pontos e o nascimento de inimigos, e mostra a mensagem de fim. | `_test_ca04_colisao_encerra` |
| (manual) | Jogar uma partida inteira com o teclado e reiniciar pelo botão funciona sem travar. | jogar (F5) |
