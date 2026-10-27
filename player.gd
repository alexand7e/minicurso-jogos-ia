extends Area2D

signal hit

var speed = Config.PLAYER_SPEED # Velocidade do jogador (pixels/s), definida em config.gd.
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"move_down"):
		velocity.y += 1
	if Input.is_action_pressed(&"move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = &"right"
		$AnimatedSprite2D.flip_v = false
		$Trail.rotation = 0
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = &"up"
		rotation = PI if velocity.y > 0 else 0


# Troca a arte do jogador pelo personagem "index" de Config.CHARACTERS
# (a arte que ficou na cena player.tscn é a do jogo base e é substituída aqui).
func set_character(index):
	var art = Config.ART_DIR + Config.CHARACTERS[index]["art"]
	var frames = SpriteFrames.new()
	frames.remove_animation(&"default")
	# "right": andando de lado (8 quadros). "up": de costas, andando para cima (2 quadros).
	for animation in [[&"right", "_andar_", 8], [&"up", "_subir_", 2]]:
		frames.add_animation(animation[0])
		frames.set_animation_speed(animation[0], Config.PLAYER_ANIMATION_SPEED)
		for i in animation[2]:
			frames.add_frame(animation[0], load("%s%s%d.png" % [art, animation[1], i]))
	$AnimatedSprite2D.sprite_frames = frames
	$AnimatedSprite2D.animation = &"right"
	$Trail.texture = frames.get_frame_texture(&"right", 0) # o rastro é uma cópia apagada do personagem


func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false


func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred(&"disabled", true)
