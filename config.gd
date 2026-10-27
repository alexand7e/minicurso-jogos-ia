extends Node
## Configuração central do jogo (registrada como autoload "Config" em project.godot).
##
## Altere um valor, salve e rode o jogo (F5): o resultado aparece na hora.
## Regra do projeto: números e textos que definem a "cara" do jogo ficam AQUI,
## nunca espalhados pelos outros scripts. Acesso nos scripts: Config.PLAYER_SPEED.
##
## Dica: os textos padrão não usam acentos porque a fonte do demo (Xolonium)
## pode não ter todos os glifos. Se usar acento e a letra sair errada, troque a fonte.

# --- Textos (aparecem na tela) ---
const TITLE := "Fuja dos\nBichos"      # \n = quebra de linha
const MSG_READY := "Preparar"
const MSG_GAME_OVER := "Acabou!"
const BUTTON_START := "Jogar"

# --- Visual ---
const BACKGROUND_COLOR := Color(0.22, 0.37, 0.38)   # vermelho, verde, azul de 0 a 1

# --- Jogador ---
const PLAYER_SPEED := 400.0           # pixels por segundo

# --- Inimigos ---
const MOB_MIN_SPEED := 150.0          # pixels por segundo
const MOB_MAX_SPEED := 250.0          # precisa ser maior ou igual ao mínimo
const MOB_SPAWN_INTERVAL := 0.5       # segundos entre um inimigo e o próximo

# --- Ritmo e pontuação ---
const START_DELAY := 2.0              # segundos entre "Preparar" e o início da partida
const SCORE_PER_SECOND := 1           # pontos ganhos a cada segundo vivo
