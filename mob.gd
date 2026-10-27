extends RigidBody2D

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


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
