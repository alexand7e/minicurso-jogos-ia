# Plano 004: Profundidade

> O plano responde COMO, dentro deste código. Parte da spec aprovada; não muda o que a spec decidiu.

## Abordagem
Perspectiva de verdade, feita à mão em 2D: a câmera está a `DEPTH_CAMERA_HEIGHT` pixels de altura sobre o ponto
`DEPTH_CAMERA` da tela. Um ponto `p` do chão, levado à altura `h`, aparece em

    câmera + (p - câmera) * H / (H - h)

ou seja, afastado da câmera na proporção da altura. É a mesma conta de uma câmera 3D, só que para poucos pontos.

- **Script novo `tall.gd`** (`Node2D`, "algo alto"): guarda o pé (`base`, retângulo no chão), a altura e a aparência
  (cores, texto, textura de copa, cabos). A cada quadro pede para ser redesenhado (`queue_redraw`) e, em `_draw()`,
  projeta os cantos do pé para o alto e desenha as paredes viradas para a câmera (as outras ficam atrás do telhado),
  depois o topo: telhado com nome, copa de árvore, topo redondo do mastro. Os cabos da ponte saem do topo até pontos
  do chão. `project(point, h)` é estática, para os testes usarem.
- **`scenery.gd`** troca o desenho chapado por `Tall`: prédios (`_building`), pilares e letreiro do portal, placa da
  avenida, copas (árvores e carnaúbas, com uma sombra redonda no chão) e o mastro com os cabos. Os obstáculos da spec
  003 não mudam: continuam no pé de cada coisa.
- **Ordem de desenho**: `Tall` com `z_index` 20, acima do jogador (10); inimigos passam a ter `z_index` 30. Como o topo
  sempre se afasta da câmera, o alto só cobre quem está atrás dele, e nunca quem está na frente.
- **Sombras**: `player.gd` e `mob.gd` criam por código uma elipse escura (`Shadow`). A do jogador fica nos pés e é
  corrigida a cada quadro, porque o jogador gira ao andar para baixo; a do inimigo fica deslocada para baixo e para a
  direita, corrigida uma vez no `_ready` (o inimigo não gira depois de nascer).

## Arquivos afetados
| Arquivo | O que muda |
| --- | --- |
| `config.gd` | `DEPTH_CAMERA := Vector2(240, 600)` e `DEPTH_CAMERA_HEIGHT := 1000.0` |
| `tall.gd` | Novo: `project()`, `lift()`, `top_rect()`, `_draw()` |
| `scenery.gd` | Prédios, portal, placa, copas e mastro viram `Tall`; alturas em constantes no topo |
| `player.gd` | Sombra nos pés |
| `mob.gd` | Sombra afastada e `z_index` acima do alto |
| `tests/run_tests.gd` | `_test_ca30_altura_em_perspectiva`, `_test_ca31_alto_e_ordem`, `_test_ca32_sombras` |
| `AGENTS.md`, `README.md` | `tall.gd` no mapa e na estrutura |

Não muda: `.tscn`, `project.godot`, regras da partida, obstáculos, arte.

## Como cada critério será verificado
| CA | Verificação |
| --- | --- |
| CA-30 | `_test_ca30_altura_em_perspectiva`: `project` no ponto da câmera não desloca; mais longe e mais alto desloca mais; um prédio da UFPI tem o topo em outro lugar em relação ao pé depois de rolar 200 px, e o pé não muda |
| CA-31 | `_test_ca31_alto_e_ordem`: a UFPI tem prédios e copas; a Raul Lopes tem um alto com cabos e copas; `z_index` do jogador < do alto < do inimigo |
| CA-32 | `_test_ca32_sombras`: a sombra do jogador fica abaixo dele andando para cima e para baixo; a de um inimigo fica abaixo dele |
| CA-33, CA-34 | Manual: jogar as duas fases, olhando a ponte e os prédios passarem |

## Riscos e decisões
- **Redesenhar todo quadro**: umas 40 coisas altas por trecho, cada uma com poucos polígonos. Leve para a Godot.
- **Personagem escondido atrás de prédio**: acontece só por um instante, quando ele passa por trás; é o que dá a
  sensação de profundidade. Se atrapalhar (CA-34), basta subir `DEPTH_CAMERA_HEIGHT`: câmera mais alta, efeito menor.
- **Câmera mais baixa na tela**: com o ponto embaixo da câmera em y = 600, quase tudo mostra a parede da frente, como
  quem olha a avenida à frente. Mudar esse ponto na config muda o "ângulo" da câmera.
