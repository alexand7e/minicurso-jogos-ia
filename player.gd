extends Area2D

signal hit

var speed = Config.PLAYER_SPEED # Velocidade do jogador (pixels/s), definida em config.gd.
var screen_size # Size of the game window.
var scenery = null # Chão das fases (scenery.gd), passado pelo Main: diz o que é obstáculo e o tipo de chão.

const SHADOW_FEET := Vector2(0, 44) # onde ficam os pés, a partir do centro do jogador (spec 004)

func _ready():
	screen_size = get_viewport_rect().size
	_add_shadow()
	hide()


func _process(delta):
	if visible and scenery:
		_get_pushed()

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
		velocity = velocity.normalized() * speed * _ground_factor()
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	_move(velocity * delta)
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = &"right"
		$AnimatedSprite2D.flip_v = false
		$Trail.rotation = 0
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = &"up"
		rotation = PI if velocity.y > 0 else 0

	# A sombra fica nos pés mesmo com o jogador girado (andando para baixo ele dá meia volta).
	$Shadow.rotation = -rotation
	$Shadow.position = SHADOW_FEET.rotated(-rotation)


# Sombra no chão (spec 004): uma elipse escura, desenhada por baixo do personagem.
func _add_shadow():
	var points = PackedVector2Array()
	for i in 16:
		points.append(Vector2.from_angle(TAU * i / 16) * Vector2(22, 8))
	var shadow = Polygon2D.new()
	shadow.name = "Shadow"
	shadow.polygon = points
	shadow.color = Color(0, 0, 0, 0.3)
	shadow.z_index = -2 # abaixo do personagem e do rastro
	shadow.position = SHADOW_FEET
	add_child(shadow)


# ------------------------------------------------- contato com o cenário (spec 003)

# Metade da largura e da altura do jogador: a cápsula de colisão vista como um retângulo.
func _half_size():
	var shape = $CollisionShape2D.shape
	return Vector2(shape.radius, shape.height / 2)


# Obstáculos (retângulos na tela) que o jogador está invadindo. O retângulo do jogador é encolhido meio
# pixel: encostar exatamente na borda de um obstáculo não conta como invadir.
func _touching():
	if scenery == null:
		return []
	var me = Rect2(position - _half_size(), _half_size() * 2).grow(-0.5)
	return scenery.obstacle_rects().filter(func(obstacle): return obstacle.intersects(me))


# O chão desce levando os obstáculos: quem estiver logo abaixo de um é empurrado junto.
# Só conta o obstáculo que entrou por cima (a borda de baixo dele ainda está acima do centro do jogador).
# Empurrado para fora da tela por baixo, torrou.
func _get_pushed():
	for obstacle in _touching():
		if obstacle.end.y < position.y:
			position.y = obstacle.end.y + _half_size().y
	if position.y > screen_size.y:
		_die()


# Quanto o chão sob o jogador muda o passo (Config.GROUND_SPEED; 1.0 sem cenário).
func _ground_factor():
	if scenery == null:
		return 1.0
	return Config.GROUND_SPEED.get(scenery.ground_at(position), 1.0)


# Anda "motion", parando encostado nos obstáculos. Um eixo de cada vez: na diagonal contra um prédio,
# o eixo bloqueado para e o outro continua, e o jogador desliza ao longo dele.
func _move(motion):
	var half = _half_size()
	if motion.x != 0:
		position.x += motion.x
		for obstacle in _touching():
			position.x = obstacle.position.x - half.x if motion.x > 0 else obstacle.end.x + half.x
	if motion.y != 0:
		position.y += motion.y
		for obstacle in _touching():
			position.y = obstacle.position.y - half.y if motion.y > 0 else obstacle.end.y + half.y


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
	_die()


# Fim para o jogador: tocou num inimigo ou foi empurrado para fora da tela.
func _die():
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred(&"disabled", true)
