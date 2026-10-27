# Plano 002: Duas fases pelas ruas de Teresina

> O plano responde COMO, dentro deste código. Parte da spec aprovada; não muda o que a spec decidiu.

## Abordagem
Um script novo, `scenery.gd` (nó `Scenery`, `Node2D`), desenha e rola o chão. O `Main` cria esse nó por código
logo acima do `ColorRect`, abaixo do jogador e dos inimigos, sem mexer em `main.tscn`.

- **Trechos que se revezam**: o cenário é feito de 2 trechos de 480 x 1440 px (duas telas) empilhados. A cada quadro
  os dois descem `SCROLL_SPEED * delta`. Quando um sai por baixo, é apagado e um trecho novo é montado em cima do
  outro, já com o cenário da fase atual. Assim a UFPI "chega" pela rua, sem corte. Como cada trecho é maior que a
  tela, dois bastam para nunca haver buraco.
- **Como um trecho é montado**: com peças prontas (asfalto, grama, água, areia, árvores, carnaúbas, aguapés, carros),
  repetidas como ladrilhos (`Sprite2D` com `region` e repetição de textura), mais formas simples (`Polygon2D`, `Line2D`)
  e textos (`Label`). A ponte, o portal, os prédios e as placas são feitos assim, porque não existe arte pronta deles.
  As posições de cada peça ficam em `scenery.gd`, que faz o papel de uma cena; na config ficam só os valores de ajuste
  (velocidade, fases).
- **Fases**: `Main` guarda `phase` (0 ou 1). A cada ponto, `_on_ScoreTimer_timeout` confere se chegou ao `min_score` da
  fase seguinte; se chegou, muda o intervalo do `MobTimer`, mostra o nome da fase no HUD e avisa o `Scenery`.
  `new_game()` volta tudo à fase 1 (`$Scenery.reset(0)`). O chão começa a andar junto com os inimigos (fim do
  `StartTimer`) e para no `game_over()`.
- **Legibilidade**: `hud.gd` põe contorno escuro nos textos (pontuação, mensagem e nome do personagem).

## Arquivos afetados
| Arquivo | O que muda |
| --- | --- |
| `config.gd` | `SCROLL_SPEED := 120.0` (px/s); `PHASES` com 2 fases: nome mostrado, cenário (`"raul_lopes"`/`"ufpi"`), `min_score` (0 e 20 pontos) e `mob_spawn_interval` (`MOB_SPAWN_INTERVAL` e 0,4 s) |
| `scenery.gd` | Novo: `reset(phase)`, `set_phase(phase)`, `scroll(distance)`, `segment_kinds()`, `running`; monta os trechos `raul_lopes` e `ufpi` |
| `main.gd` | Cria o `Scenery`; `phase`; troca de fase pela pontuação; liga e desliga a rolagem |
| `hud.gd` | Contorno nos textos |
| `scripts/preparar_arte.gd` | Copia as peças de cenário dos pacotes Racing e Pirate para `art/teresina/cenario/` |
| `art/teresina/cenario/` | 10 peças: `asfalto`, `grama`, `agua`, `areia`, `carnauba`, `aguape`, `arvore_grande`, `arvore_pequena`, `carro_1`, `carro_2` |
| `tests/run_tests.gd` | `_test_ca15_comeca_na_raul_lopes`, `_test_ca16_chao_anda`, `_test_ca17_fase_2_ufpi`, `_test_ca18_volta_a_fase_1` |
| `README.md` | Créditos das peças novas |

Não muda: `.tscn`, `project.godot`, jogador, inimigos.

## Como cada critério será verificado
| CA | Verificação |
| --- | --- |
| CA-15 | `_test_ca15_comeca_na_raul_lopes`: depois de `new_game()`, `phase == 0` e `segment_kinds()` só tem `raul_lopes` |
| CA-16 | `_test_ca16_chao_anda`: na tela inicial a posição dos trechos não muda em 0,3 s; na partida desce cerca de `SCROLL_SPEED` x tempo; depois de rolar 5 telas em passos, os trechos ainda cobrem de 0 a 720 sem buraco |
| CA-17 | `_test_ca17_fase_2_ufpi`: com `score` um ponto abaixo do mínimo, um `_on_ScoreTimer_timeout` leva à fase 2: mensagem = nome da fase 2, `MobTimer.wait_time` = intervalo da fase 2; depois de rolar dois trechos, `segment_kinds()` só tem `ufpi` |
| CA-18 | `_test_ca18_volta_a_fase_1`: na fase 2, `game_over()` e `new_game()` voltam a `phase == 0`, cenário `raul_lopes` e intervalo da fase 1 |
| CA-19 a CA-22 | Manual: jogar até a fase 2 (cerca de 20 s) e observar |
| CA-23 | Manual: conferir Créditos contra `art/teresina/cenario/` |

## Riscos e decisões
- **Cenário montado por código**: muitos números de posição em `scenery.gd`. Eles estão agrupados por trecho e
  comentados, para que mudar um prédio de lugar seja fácil de achar.
- **Dois trechos repetidos**: a ponte reaparece a cada 12 s (1440 px a 120 px/s). É o preço de não ter um mapa longo;
  fica bom de ver e é simples.
- **Desempenho**: cada trecho tem algumas dezenas de nós e é montado só quando outro sai da tela; leve para a Godot.
- **Inimigos sobre o rio e prédios**: sem colisão com o cenário (fora do escopo), o que mantém as regras da spec 000.
