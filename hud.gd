extends CanvasLayer

signal start_game

func _ready():
	# Textos vindos de config.gd (altere lá, não aqui).
	$MessageLabel.text = Config.TITLE
	$StartButton.text = Config.BUTTON_START


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


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
