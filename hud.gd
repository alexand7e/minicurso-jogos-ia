extends CanvasLayer

signal start_game

var character_index = 0 # Personagem escolhido: posição na lista Config.CHARACTERS.

func _ready():
	# Textos vindos de config.gd (altere lá, não aqui).
	$MessageLabel.text = Config.TITLE
	$StartButton.text = Config.BUTTON_START
	_build_character_picker()
	_show_character()


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message(Config.MSG_GAME_OVER)
	await $MessageTimer.timeout
	$MessageLabel.text = Config.TITLE
	$MessageLabel.show()
	await get_tree().create_timer(1).timeout
	$StartButton.show()
	$CharacterPicker.show()


func update_score(score):
	$ScoreLabel.text = str(score)


# Troca de personagem: step = 1 para o próximo, -1 para o anterior (dá a volta nas pontas).
func change_character(step):
	# Só na tela inicial; durante a partida as setas movem o jogador.
	if not $StartButton.visible:
		return
	character_index = wrapi(character_index + step, 0, Config.CHARACTERS.size())
	_show_character()


func _input(event):
	if event.is_action_pressed(&"move_left"):
		change_character(-1)
	elif event.is_action_pressed(&"move_right"):
		change_character(1)


func _show_character():
	var character = Config.CHARACTERS[character_index]
	$CharacterPicker/CharacterLabel.text = character["name"]
	$CharacterPicker/CharacterPreview.texture = load("%s%s_andar_0.png" % [Config.ART_DIR, character["art"]])


# Monta o seletor (prévia, nome e botões < >) por código, para não editar hud.tscn à mão.
# Tela de 480 x 720: a prévia fica entre a pontuação e o título; nome e botões, logo abaixo do título.
func _build_character_picker():
	var font = $StartButton.get_theme_font(&"font")
	var picker = Control.new()
	picker.name = "CharacterPicker"
	picker.set_anchors_preset(Control.PRESET_FULL_RECT)
	picker.mouse_filter = Control.MOUSE_FILTER_IGNORE # deixa o clique chegar aos botões
	add_child(picker)

	var preview = TextureRect.new()
	preview.name = "CharacterPreview"
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.position = Vector2(180, 95)
	preview.size = Vector2(120, 160)
	picker.add_child(preview)

	var label = Label.new()
	label.name = "CharacterLabel"
	label.position = Vector2(60, 450)
	label.size = Vector2(360, 60)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override(&"font", font)
	label.add_theme_font_size_override(&"font_size", 26)
	picker.add_child(label)

	for step in [-1, 1]:
		var button = Button.new()
		button.name = "PreviousButton" if step < 0 else "NextButton"
		button.text = Config.BUTTON_PREVIOUS if step < 0 else Config.BUTTON_NEXT
		button.position = Vector2(4 if step < 0 else 420, 450)
		button.size = Vector2(56, 60)
		button.focus_mode = Control.FOCUS_NONE # sem foco, as setas trocam o personagem em vez de mudar de botão
		button.add_theme_font_override(&"font", font)
		button.add_theme_font_size_override(&"font_size", 40)
		button.pressed.connect(change_character.bind(step))
		picker.add_child(button)


func _on_StartButton_pressed():
	$StartButton.hide()
	$CharacterPicker.hide()
	start_game.emit()


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
