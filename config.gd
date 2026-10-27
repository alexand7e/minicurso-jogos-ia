extends Node
## Configuração central do jogo (registrada como autoload "Config" em project.godot).
##
## Altere um valor, salve e rode o jogo (F5): o resultado aparece na hora.
## Regra do projeto: números e textos que definem a "cara" do jogo ficam AQUI,
## nunca espalhados pelos outros scripts. Acesso nos scripts: Config.PLAYER_SPEED.
##
## Dica: a fonte do jogo (Xolonium) tem os acentos do português (á, ã, ç, é, í, ó, ú...).
## Se usar um símbolo diferente e ele sair errado, troque a fonte.

# --- Textos (aparecem na tela) ---
const TITLE := "Fuja do\nB-R-O Bró"   # \n = quebra de linha
const MSG_READY := "Segura\no calor!"
const MSG_GAME_OVER := "Torrou!"
const BUTTON_START := "Jogar"
const BUTTON_PREVIOUS := "<"          # botões de trocar de personagem
const BUTTON_NEXT := ">"

# --- Visual ---
const BACKGROUND_COLOR := Color(0.6, 0.3, 0.15)   # terra quente; vermelho, verde, azul de 0 a 1
const ART_DIR := "res://art/teresina/"            # pasta da arte do tema (veja scripts/preparar_arte.gd)
const MUSIC := "res://art/teresina/baiao_do_bro_bro.wav"

# --- Jogador ---
const PLAYER_SPEED := 400.0           # pixels por segundo
const PLAYER_ANIMATION_SPEED := 12.0  # quadros por segundo ao andar
# Personagens da tela inicial: nome mostrado e prefixo dos arquivos em ART_DIR
# (<arte>_andar_0..7.png de lado e <arte>_subir_0..1.png de costas). O primeiro já vem escolhido.
const CHARACTERS := [
	{"name": "Vendedor de cajuína", "art": "vendedor"},
	{"name": "Estudante", "art": "estudante"},
	{"name": "Teresinense", "art": "teresinense"},
]

# --- Inimigos ---
const MOB_MIN_SPEED := 150.0          # pixels por segundo
const MOB_MAX_SPEED := 250.0          # precisa ser maior ou igual ao mínimo
const MOB_SPAWN_INTERVAL := 0.5       # segundos entre um inimigo e o próximo
const MOB_ANIMATION_SPEED := 4.0      # quadros por segundo
# Tipos de inimigo, sorteados a cada nascimento. Cada um tem <tipo>_1.png e <tipo>_2.png em ART_DIR.
const MOB_TYPES := ["sol", "brasa", "mormaco"]

# --- Ritmo e pontuação ---
const START_DELAY := 2.0              # segundos entre "Preparar" e o início da partida
const SCORE_PER_SECOND := 1           # pontos ganhos a cada segundo vivo

# --- Fases (o chão anda e o cenário muda; veja scenery.gd) ---
const SCROLL_SPEED := 120.0           # pixels por segundo que o chão desce durante a partida
# Em ordem. "name": aparece na tela quando a fase começa (\n = quebra de linha).
# "scenery": trecho de cenário montado em scenery.gd. "min_score": pontos para a fase começar.
# "mob_spawn_interval": segundos entre um inimigo e o próximo nesta fase.
const PHASES := [
	{"name": "Fase 1\nRaul Lopes", "scenery": "raul_lopes", "min_score": 0, "mob_spawn_interval": MOB_SPAWN_INTERVAL},
	{"name": "Fase 2\nUFPI", "scenery": "ufpi", "min_score": 20, "mob_spawn_interval": 0.4},
]

# --- Contato com o cenário (spec 003) ---
# Quanto cada tipo de chão multiplica PLAYER_SPEED (1.0 = normal, menor = mais devagar).
# Rio, prédios, árvores e carros são obstáculos: o jogador não atravessa (veja scenery.gd).
const GROUND_SPEED := {"asfalto": 1.0, "calcada": 1.15, "grama": 0.75, "areia": 0.55}
