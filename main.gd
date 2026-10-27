extends Node

@export var mob_scene: PackedScene
var score
var phase = 0 # Fase atual: posição na lista Config.PHASES.

func _ready():
	# Valores vindos de config.gd (altere lá, não aqui).
	$ColorRect.color = Config.BACKGROUND_COLOR
	$StartTimer.wait_time = Config.START_DELAY
	$MobTimer.wait_time = Config.MOB_SPAWN_INTERVAL
	$Music.stream = load(Config.MUSIC)
	# A faixa WAV não vem com repetição ligada: recomeça quando acaba.
	# (No fim de jogo, $Music.stop() não dispara "finished", então ela não volta sozinha.)
	$Music.finished.connect($Music.play)
	# Chão que anda (scenery.gd), criado por código logo acima do fundo e abaixo do jogador e dos inimigos.
	var scenery = preload("res://scenery.gd").new()
	scenery.name = "Scenery"
	add_child(scenery)
	move_child(scenery, $ColorRect.get_index() + 1)


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Scenery.running = false
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	get_tree().call_group(&"mobs", &"queue_free")
	score = 0
	phase = 0
	$MobTimer.wait_time = Config.PHASES[phase]["mob_spawn_interval"]
	$Scenery.reset(phase)
	$Player.set_character($HUD.character_index)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message(Config.MSG_READY)
	$Music.play()


func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node(^"MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(Config.MOB_MIN_SPEED, Config.MOB_MAX_SPEED), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_ScoreTimer_timeout():
	score += Config.SCORE_PER_SECOND
	$HUD.update_score(score)
	_check_next_phase()


# Passa para a próxima fase quando a pontuação chega ao mínimo dela.
func _check_next_phase():
	var next = phase + 1
	if next < Config.PHASES.size() and score >= Config.PHASES[next]["min_score"]:
		phase = next
		$MobTimer.wait_time = Config.PHASES[phase]["mob_spawn_interval"]
		$HUD.show_message(Config.PHASES[phase]["name"])
		$Scenery.set_phase(phase) # o cenário novo entra por cima da tela, continuando a rua


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$Scenery.running = true
	$HUD.show_message(Config.PHASES[phase]["name"])
