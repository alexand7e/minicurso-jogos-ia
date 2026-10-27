# Plano 001: Tema B-R-O Bró

> O plano responde COMO, dentro deste código. Parte da spec aprovada; não muda o que a spec decidiu.

## Abordagem
A arte nova vai pronta para `art/teresina/`, já no tamanho e na cor certos. As cenas (`.tscn`) não são editadas:
os scripts montam as animações em tempo de execução a partir de nomes guardados em `config.gd`. Assim o jogo
continua igual por dentro (mesmos nós, sinais e colisões) e trocar personagem ou inimigo é mudar uma lista na config.

- **Personagens**: `player.gd` ganha `set_character(index)`, que monta as animações `right` (8 quadros andando de
  lado) e `up` (2 quadros de costas) a partir do prefixo de arte do personagem. O rastro (`Trail`) passa a usar o
  primeiro quadro do personagem. `main.gd` chama `set_character` em `new_game()` com a escolha do HUD.
- **Escolha na tela inicial**: `hud.gd` cria por código um seletor (prévia do personagem, botões `<` e `>` e o nome).
  Guarda `character_index` e só aceita trocar enquanto o botão Jogar está visível. Setas, A/D e clique trocam.
- **Inimigos**: `mob.gd` monta uma animação de 2 quadros para cada tipo listado em `Config.MOB_TYPES` e sorteia uma,
  como antes.
- **Música**: `main.gd` carrega `Config.MUSIC` no `Music` e recomeça a faixa quando ela acaba (o arquivo WAV não vem
  com loop ligado e não editamos `.import` à mão).
- **Origem da arte** (tudo CC0):
  - Personagens: Kenney *Toon Characters* (Male person, Female person, Male adventurer), poses HD reduzidas para 144 x 192.
  - Sol: "Shiny Sun" (SalemF, OpenGameArt) sobre o brilho `star_08`/`star_09` do Kenney *Particle Pack*, colorido em amarelo e laranja.
  - Brasa: `fire_01`/`fire_02` do *Particle Pack*, coloridos de vermelho a amarelo.
  - Mormaço (redemoinho de poeira quente): `twirl_01`/`twirl_02` do *Particle Pack*, em cor de areia.
  - A conversão é feita por `scripts/preparar_arte.gd` (Godot, sem dependências), para dar para refazer e auditar.
- **Música**: não há forró ou baião com licença CC em fontes confiáveis. A faixa é um baião original composto por
  código em `scripts/gerar_baiao.py` (Python puro): sanfona, zabumba e triângulo sintetizados, 16 compassos em loop.
  Licença CC0, feita para este projeto.

## Arquivos afetados
| Arquivo | O que muda |
| --- | --- |
| `config.gd` | Textos do tema (`TITLE`, `MSG_READY`, `MSG_GAME_OVER`); `BACKGROUND_COLOR` cor de terra quente; novas: `ART_DIR := "res://art/teresina/"`, `CHARACTERS` (3 x nome + prefixo de arte), `MOB_TYPES := ["sol", "brasa", "mormaco"]`, `PLAYER_ANIMATION_SPEED := 12.0` (quadros/s), `MOB_ANIMATION_SPEED := 4.0` (quadros/s), `MUSIC` (caminho da faixa), `BUTTON_PREVIOUS`/`BUTTON_NEXT` (`<`/`>`) |
| `player.gd` | Nova `set_character(index)`; usa `PLAYER_ANIMATION_SPEED` |
| `mob.gd` | `_ready` monta as animações a partir de `MOB_TYPES` |
| `hud.gd` | Seletor de personagem criado por código; `character_index`, `change_character(step)`, mostrar/esconder junto com o botão Jogar |
| `main.gd` | `new_game()` aplica o personagem escolhido; `_ready` carrega a música nova e a repete |
| `art/teresina/` | 30 quadros de personagem, 6 de inimigo, 1 faixa WAV (gerados pelos scripts abaixo) |
| `scripts/preparar_arte.gd` | Novo: converte os pacotes baixados para `art/teresina/` |
| `scripts/gerar_baiao.py` | Novo: gera `art/teresina/baiao_do_bro_bro.wav` |
| `tests/run_tests.gd` | Novos grupos `_test_ca05_inimigos_do_tema`, `_test_ca06_troca_de_personagem`, `_test_ca07_personagem_na_partida`, `_test_ca08_escolha_mantida`, `_test_ca09_tela_inicial_do_tema` |
| `README.md` | Créditos da arte e da música novas; nota sobre os scripts de preparo |

Não muda: `.tscn`, `project.godot`, colisões, velocidades, pontuação. A arte antiga continua no projeto porque as
cenas ainda a citam como valor padrão.

## Como cada critério será verificado
| CA | Verificação |
| --- | --- |
| CA-05 | `_test_ca05_inimigos_do_tema`: com a partida rodando, toda textura de todo inimigo vem de `ART_DIR` e a animação está em `MOB_TYPES` |
| CA-06 | `_test_ca06_troca_de_personagem`: começa em 0; `change_character(1)` três vezes volta a 0; `change_character(-1)` de 0 vai a 2; o nome na tela acompanha; durante a partida a troca é ignorada |
| CA-07 | `_test_ca07_personagem_na_partida`: escolhe o 2º, começa a partida, a animação `right` usa a arte dele; segurando `move_right` a animação toca |
| CA-08 | `_test_ca08_escolha_mantida`: escolhe o 3º, joga, perde, começa outra; o personagem continua o 3º |
| CA-09 | `_test_ca09_tela_inicial_do_tema`: mensagem = `TITLE` (com "Bró"), fundo = `BACKGROUND_COLOR`, 3 nomes não vazios em `CHARACTERS` |
| CA-10 | Manual: trocar com setas, A/D e clique em `<` `>`; durante a partida as setas só movem o jogador |
| CA-11 | Manual: título e "Vendedor de cajuína" aparecem com acento correto (a fonte Xolonium tem os glifos; conferido) |
| CA-12 | Manual: o baião toca na partida, repete sem travar e para no fim de jogo |
| CA-13 | Manual: conferir a seção Créditos do README contra `art/teresina/` |
| CA-14 | Manual: mostrar uma partida a alguém de Teresina |
| CA-01 a CA-04 | Testes existentes continuam passando |

## Riscos e decisões
- **Arte montada por código, não nas cenas**: evita editar `.tscn` à mão (regra 4) e deixa a lista de personagens
  na config. Custo: as cenas mostram a arte antiga no editor até o jogo rodar.
- **Música sintetizada**: soa mais simples que uma gravação. A troca por uma faixa gravada, se surgir uma com licença
  boa, é só mudar `Config.MUSIC`.
- **Mesma colisão para todos**: os quadros são reduzidos para que o corpo ocupe mais ou menos a cápsula de colisão
  atual (54 x 68 px).
- **Descer de costas**: o jogo base gira o jogador 180° ao descer; com a arte nova isso continua igual. Mudar fica fora do escopo.
