extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	# Valores vindos de config.gd (altere lá, não aqui).
	$ColorRect.color = Config.BACKGROUND_COLOR
	$StartTimer.wait_time = Config.START_DELAY
	$MobTimer.wait_time = Config.MOB_SPAWN_INTERVAL


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	get_tree().call_group(&"mobs", &"queue_free")
	score = 0
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

	# Choose the velocity for the mob (faixa cresce com a pontuação).
	var speed_range = mob_speed_range(score)
	var velocity = Vector2(randf_range(speed_range.x, speed_range.y), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


# Faixa de velocidade (mínima, máxima) dos inimigos para uma pontuação.
# Cada ponto soma MOB_SPEED_GAIN_PER_POINT, limitado por MOB_SPEED_CAP.
func mob_speed_range(points: int) -> Vector2:
	var gain = points * Config.MOB_SPEED_GAIN_PER_POINT
	var low = minf(Config.MOB_MIN_SPEED + gain, Config.MOB_SPEED_CAP)
	var high = minf(Config.MOB_MAX_SPEED + gain, Config.MOB_SPEED_CAP)
	return Vector2(low, high)


func _on_ScoreTimer_timeout():
	score += Config.SCORE_PER_SECOND
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
