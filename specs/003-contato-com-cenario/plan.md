# Plano 003: Contato com o cenário

> O plano responde COMO, dentro deste código. Parte da spec aprovada; não muda o que a spec decidiu.

## Abordagem
O cenário passa a guardar, em cada trecho, **o que é sólido** e **de que tipo é o chão**; o jogador consulta isso a
cada quadro. Tudo com retângulos, sem a física da Godot mover o jogador, para o código ficar fácil de ler.

- **Obstáculos**: `scenery.gd` ganha `add_obstacle(segment, rect, kind)`, que cria um `StaticBody2D` com um
  `RectangleShape2D` do tamanho do retângulo, na camada de colisão 2. O jogador e os inimigos só olham a camada 1, então
  esbarrar num obstáculo nunca dispara o sinal `hit`. Usar um corpo de verdade tem uma vantagem para a oficina: em
  *Depurar > Formas de colisão visíveis* dá para ver cada obstáculo durante o jogo. `obstacle_rects()` devolve os
  retângulos na tela, de todos os trechos.
- **Tipos de chão**: `_ground(segment, kind, rect)` desenha o chão (asfalto, grama, areia, calçada, água) e anota o tipo
  no trecho. `ground_at(point)` devolve o tipo no ponto da tela (o último desenhado por cima vale).
- **Onde ficam os obstáculos**: prédios e pilares do portal usam o próprio retângulo; árvores, carnaúbas e carros, um
  retângulo no centro da peça (`TRUNK` da peça desenhada, para não bloquear pela copa); o rio, dois retângulos, um
  acima e outro abaixo da ponte; o mastro, um quadrado. Carros novos junto ao meio-fio esquerdo da avenida (x perto
  de 80), longe da posição inicial e do corredor do meio.
- **Jogador** (`player.gd`): o `Main` passa o cenário em `$Player.scenery`. A cada quadro, nesta ordem:
  1. **Empurrão**: se algum obstáculo desceu sobre o jogador, ele vai para logo abaixo do obstáculo. Se o centro passou
     da borda de baixo da tela, `_die()` (o mesmo caminho do toque em inimigo: some e emite `hit`).
  2. **Passo**: a velocidade é `PLAYER_SPEED * Config.GROUND_SPEED[chão sob o jogador]`.
  3. **Movimento um eixo por vez**: anda em x e, se entrou num obstáculo, volta para a borda dele; depois o mesmo em y.
     Assim, na diagonal, o eixo bloqueado para e o outro continua (desliza).
  O retângulo do jogador é o da cápsula de colisão (`radius` x `height/2`), encolhido meio pixel para que encostar
  exatamente na borda não conte como entrar.

## Arquivos afetados
| Arquivo | O que muda |
| --- | --- |
| `config.gd` | `GROUND_SPEED := {"asfalto": 1.0, "calcada": 1.15, "grama": 0.75, "areia": 0.55}` |
| `scenery.gd` | `add_obstacle`, `obstacle_rects`, `_ground`, `ground_at`; obstáculos e chão anotados nos dois trechos; carros junto ao meio-fio; estacionamento desenhado como asfalto |
| `player.gd` | `scenery`; empurrão, passo pelo chão e movimento com obstáculos; `_die()` compartilhado com o toque em inimigo |
| `main.gd` | `$Player.scenery = scenery` ao criar o cenário |
| `tests/run_tests.gd` | `_test_ca24_obstaculo_bloqueia`, `_test_ca25_chao_empurra`, `_test_ca26_chao_muda_o_passo`, `_test_ca27_obstaculos_das_fases` |

Não muda: `.tscn`, `project.godot`, inimigos, HUD, arte (os carros novos usam as peças que já existem).

## Como cada critério será verificado
| CA | Verificação |
| --- | --- |
| CA-24 | `_test_ca24_obstaculo_bloqueia`: com um obstáculo de teste acima do jogador, segurar "cima" o deixa encostado na borda de baixo do obstáculo; segurar "cima" e "direita" mantém o y e aumenta o x |
| CA-25 | `_test_ca25_chao_empurra`: com o chão andando e um obstáculo logo acima do jogador parado, depois de 0,5 s ele desceu e continua visível; depois de mais 1,5 s foi empurrado para fora, sumiu e a mensagem é a de fim de jogo |
| CA-26 | `_test_ca26_chao_muda_o_passo`: a ordem dos valores na config (calçada > asfalto > grama, areia < asfalto); `ground_at` reconhece asfalto, calçada, grama e areia na Raul Lopes; andando 0,2 s na grama o jogador percorre a fração `GROUND_SPEED["grama"]` do que percorre no asfalto |
| CA-27 | `_test_ca27_obstaculos_das_fases`: em cada fase os tipos de obstáculo esperados existem; o rio bloqueia e o tabuleiro da ponte não (e é asfalto); a posição inicial está livre; existe um x da avenida em que uma coluna da largura do jogador atravessa os dois trechos das duas fases sem tocar obstáculo |
| CA-28, CA-29 | Manual: jogar encostando no rio, nos prédios e nas árvores, e atravessando grama e calçadão |

## Riscos e decisões
- **Retângulos e não a física**: a Godot resolveria colisões com um `CharacterBody2D`, mas o jogador é um `Area2D` na
  cena e trocar o tipo do nó exigiria mexer na cena à mão. Com retângulos, o código cabe em poucas funções e dá para
  testar sem esperar a física.
- **Testes antigos**: o jogador parado na posição inicial está no meio da avenida, onde não há obstáculo, então os
  testes que esperam a partida rolar não são empurrados para fora.
- **Ficar preso na ponte**: quem entra na ponte desce com ela e precisa sair pela avenida antes da borda de baixo; é
  um risco que o jogador escolhe correr, e combina com "o chão empurra".
