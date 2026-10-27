extends RigidBody2D

const SHADOW_OFFSET := Vector2(14, 56) # o calor voa: a sombra cai no chão, embaixo e um pouco à direita
const Z_ABOVE_TALL := 30               # por cima dos prédios e das copas (z_index 20; spec 004)

func _ready():
	# Monta uma animação de 2 quadros por tipo de inimigo listado em config.gd
	# (a arte que ficou na cena mob.tscn é a do jogo base e é substituída aqui).
	var frames = SpriteFrames.new()
	frames.remove_animation(&"default")
	for mob_type in Config.MOB_TYPES:
		frames.add_animation(mob_type)
		frames.set_animation_speed(mob_type, Config.MOB_ANIMATION_SPEED)
		for i in [1, 2]:
			frames.add_frame(mob_type, load("%s%s_%d.png" % [Config.ART_DIR, mob_type, i]))
	$AnimatedSprite2D.sprite_frames = frames
	$AnimatedSprite2D.animation = Config.MOB_TYPES.pick_random()
	$AnimatedSprite2D.play()
	z_index = Z_ABOVE_TALL
	_add_shadow()


# Sombra no chão: uma elipse escura afastada do inimigo. O inimigo já nasce girado para onde vai
# (e não gira mais), então a sombra é "desgirada" uma vez para cair sempre para baixo na tela.
func _add_shadow():
	var points = PackedVector2Array()
	for i in 16:
		points.append(Vector2.from_angle(TAU * i / 16) * Vector2(26, 10))
	var shadow = Polygon2D.new()
	shadow.name = "Shadow"
	shadow.polygon = points
	shadow.color = Color(0, 0, 0, 0.25)
	shadow.z_index = -1 # abaixo do inimigo
	shadow.rotation = -rotation
	shadow.position = SHADOW_OFFSET.rotated(-rotation)
	add_child(shadow)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
