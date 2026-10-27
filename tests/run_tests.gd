extends SceneTree
## Testes de aceitação do jogo. Rodam sem abrir janela.
##
## Cada grupo de verificações corresponde a um critério de aceitação (CA-xx)
## escrito em specs/NNN-*/spec.md (CA-01 a CA-04 na spec 000, CA-05 a CA-09 na
## spec 001, CA-15 a CA-18 na spec 002, CA-24 a CA-27 na spec 003, CA-30 a CA-32 na spec 004). Ao criar uma spec nova, adicione
## aqui uma função _test_... para cada critério novo.
##
## Como rodar: scripts/check.sh (veja o README para o comando completo).

var failures := 0
var checks := 0
var cfg: Node   # o autoload Config, buscado em tempo de execução


func _initialize() -> void:
	cfg = root.get_node("Config")
	_run_all()


func _run_all() -> void:
	_test_config_coerente()
	await _test_ca01_novo_jogo()
	await _test_ca02_pontuacao_sobe()
	await _test_ca03_inimigos_surgem()
	await _test_ca04_colisao_encerra()
	await _test_ca05_inimigos_do_tema()
	await _test_ca06_troca_de_personagem()
	await _test_ca07_personagem_na_partida()
	await _test_ca08_escolha_mantida()
	await _test_ca09_tela_inicial_do_tema()
	await _test_ca15_comeca_na_raul_lopes()
	await _test_ca16_chao_anda()
	await _test_ca17_fase_2_ufpi()
	await _test_ca18_volta_a_fase_1()
	await _test_ca24_obstaculo_bloqueia()
	await _test_ca25_chao_empurra()
	await _test_ca26_chao_muda_o_passo()
	await _test_ca27_obstaculos_das_fases()
	await _test_ca30_altura_em_perspectiva()
	await _test_ca31_alto_e_ordem()
	await _test_ca32_sombras()
	print("")
	if failures == 0:
		print("OK: %d verificacoes passaram." % checks)
	else:
		print("FALHA: %d de %d verificacoes falharam." % [failures, checks])
	quit(1 if failures > 0 else 0)


# ---------------------------------------------------------------- utilitarios

func _expect(condition: bool, message: String) -> void:
	checks += 1
	if condition:
		print("  ok     - ", message)
	else:
		failures += 1
		print("  FALHOU - ", message)


func _new_main() -> Node:
	var main = load("res://main.tscn").instantiate()
	root.add_child(main)
	return main


func _wait(seconds: float) -> void:
	await create_timer(seconds).timeout


func _cleanup(main: Node) -> void:
	main.queue_free()
	await process_frame


# Evita que um inimigo sorteado acabe a partida no meio de um teste que
# não é sobre colisão.
func _disable_player_collision(main: Node) -> void:
	main.get_node("Player/CollisionShape2D").set_deferred("disabled", true)


# Começa a partida como quem joga: apertando o botão Jogar.
func _press_start(main: Node) -> void:
	main.get_node("HUD/StartButton").pressed.emit()


# Verdadeiro se a lista não está vazia e todos os trechos de cenário são do tipo "kind".
func _only(kinds: Array, kind: String) -> bool:
	return not kinds.is_empty() and kinds.all(func(k): return k == kind)


# Verdadeiro se os trechos do cenário cobrem a tela de cima a baixo, sem buraco entre eles.
func _covers_screen(scenery: Node) -> bool:
	var tops := []
	for segment in scenery.segments:
		tops.append(segment.position.y)
	tops.sort()
	if tops.is_empty() or tops[0] > 0.0:
		return false
	for i in range(1, tops.size()):
		if tops[i] > tops[i - 1] + scenery.SEGMENT_HEIGHT + 0.5:
			return false
	return tops[-1] + scenery.SEGMENT_HEIGHT >= scenery.get_viewport_rect().size.y


# Rola o cenário "distance" pixels em passos pequenos, como acontece quadro a quadro.
func _scroll_in_steps(scenery: Node, distance: float) -> bool:
	var always_covered := true
	var step := 8.0
	for i in int(distance / step):
		scenery.scroll(step)
		if not _covers_screen(scenery):
			always_covered = false
	return always_covered


# Leva a partida para a fase 2 dando o ponto que falta.
func _reach_phase_2(main: Node) -> void:
	main.score = cfg.PHASES[1]["min_score"] - cfg.SCORE_PER_SECOND
	main._on_ScoreTimer_timeout()


# Metade da largura e da altura do jogador (a cápsula de colisão vista como retângulo).
func _player_half(player: Node) -> Vector2:
	var shape = player.get_node("CollisionShape2D").shape
	return Vector2(shape.radius, shape.height / 2)


# Tipos de obstáculo ("rio", "arvore"...) dos trechos montados.
func _obstacle_kinds(scenery: Node) -> Array:
	var kinds := []
	for segment in scenery.segments:
		for child in segment.get_children():
			if child is StaticBody2D:
				kinds.append(child.get_meta("kind"))
	return kinds


# Verdadeiro se "rect" (na tela) toca algum obstáculo do cenário.
func _blocked(scenery: Node, rect: Rect2) -> bool:
	return scenery.obstacle_rects().any(func(obstacle): return obstacle.intersects(rect))


# Coisas altas (tall.gd) dos trechos montados.
func _tall_things(scenery: Node) -> Array:
	var found := []
	for segment in scenery.segments:
		for child in segment.get_children():
			if child.has_method("top_rect"):
				found.append(child)
	return found


# Segura "action" por "seconds" e devolve quanto o jogador andou.
func _walk(player: Node, action: StringName, seconds: float) -> float:
	var start = player.position
	Input.action_press(action)
	await _wait(seconds)
	Input.action_release(action)
	return player.position.distance_to(start)


# Caminho do primeiro quadro de uma animação do jogador.
func _player_frame_path(main: Node, animation: StringName) -> String:
	var frames = main.get_node("Player/AnimatedSprite2D").sprite_frames
	return frames.get_frame_texture(animation, 0).resource_path


# ---------------------------------------------------------------------- testes

func _test_config_coerente() -> void:
	print("Config: valores coerentes")
	_expect(cfg.PLAYER_SPEED > 0, "PLAYER_SPEED maior que zero")
	_expect(cfg.MOB_MIN_SPEED > 0, "MOB_MIN_SPEED maior que zero")
	_expect(cfg.MOB_MIN_SPEED <= cfg.MOB_MAX_SPEED, "MOB_MIN_SPEED menor ou igual a MOB_MAX_SPEED")
	_expect(cfg.MOB_SPAWN_INTERVAL > 0, "MOB_SPAWN_INTERVAL maior que zero")
	_expect(cfg.START_DELAY > 0, "START_DELAY maior que zero")


func _test_ca01_novo_jogo() -> void:
	print("CA-01: novo jogo coloca o jogador na posicao inicial com pontuacao 0")
	var main = _new_main()
	await process_frame
	main.new_game()
	await process_frame
	var player = main.get_node("Player")
	_expect(main.score == 0, "pontuacao comeca em 0")
	_expect(player.visible, "jogador fica visivel")
	_expect(player.position.is_equal_approx(main.get_node("StartPosition").position), "jogador na posicao inicial")
	_expect(main.get_node("HUD/MessageLabel").text == cfg.MSG_READY, "mensagem de preparar aparece")
	await _cleanup(main)


func _test_ca02_pontuacao_sobe() -> void:
	print("CA-02: depois do inicio, a pontuacao sobe SCORE_PER_SECOND por segundo")
	var main = _new_main()
	await process_frame
	main.new_game()
	_disable_player_collision(main)
	await _wait(cfg.START_DELAY - 0.5)
	_expect(main.score == 0, "pontuacao ainda e 0 durante o tempo de preparo")
	await _wait(0.5 + 3.5)
	_expect(main.score == 3 * cfg.SCORE_PER_SECOND, "apos 3,5 s de jogo a pontuacao e 3 x SCORE_PER_SECOND")
	await _cleanup(main)


func _test_ca03_inimigos_surgem() -> void:
	print("CA-03: inimigos surgem e se movem durante a partida")
	var main = _new_main()
	await process_frame
	main.new_game()
	_disable_player_collision(main)
	await _wait(cfg.START_DELAY + 2.0)
	var mobs = get_nodes_in_group("mobs")
	_expect(mobs.size() > 0, "existe pelo menos um inimigo em cena")
	var all_moving := true
	for mob in mobs:
		if mob.linear_velocity.length() <= 0.0:
			all_moving = false
	_expect(all_moving, "todos os inimigos estao em movimento")
	await _cleanup(main)


func _test_ca04_colisao_encerra() -> void:
	print("CA-04: tocar em um inimigo encerra a partida")
	var main = _new_main()
	await process_frame
	main.new_game()
	await _wait(cfg.START_DELAY + 1.2)
	var player = main.get_node("Player")
	# Coloca um inimigo exatamente em cima do jogador.
	var mob = main.mob_scene.instantiate()
	mob.position = player.position
	main.add_child(mob)
	await _wait(0.5)
	_expect(not player.visible, "jogador some ao ser atingido")
	_expect(main.get_node("ScoreTimer").is_stopped(), "contagem de pontos para")
	_expect(main.get_node("MobTimer").is_stopped(), "nascimento de inimigos para")
	_expect(main.get_node("HUD/MessageLabel").text == cfg.MSG_GAME_OVER, "mensagem de fim de jogo aparece")
	await _cleanup(main)


func _test_ca05_inimigos_do_tema() -> void:
	print("CA-05: inimigos mostram a arte de calor do tema")
	var main = _new_main()
	await process_frame
	main.new_game()
	_disable_player_collision(main)
	await _wait(cfg.START_DELAY + 1.2)
	var mobs = get_nodes_in_group("mobs")
	_expect(mobs.size() > 0, "existe pelo menos um inimigo em cena")
	var all_from_theme := true
	for mob in mobs:
		var sprite = mob.get_node("AnimatedSprite2D")
		if not (String(sprite.animation) in cfg.MOB_TYPES):
			all_from_theme = false
		for animation in sprite.sprite_frames.get_animation_names():
			for i in sprite.sprite_frames.get_frame_count(animation):
				if not sprite.sprite_frames.get_frame_texture(animation, i).resource_path.begins_with(cfg.ART_DIR):
					all_from_theme = false
	_expect(all_from_theme, "toda animacao e todo quadro dos inimigos vem do tema")
	await _cleanup(main)


func _test_ca06_troca_de_personagem() -> void:
	print("CA-06: na tela inicial, a troca percorre os personagens em ciclo")
	var main = _new_main()
	await process_frame
	var hud = main.get_node("HUD")
	var label = hud.get_node("CharacterPicker/CharacterLabel")
	var last = cfg.CHARACTERS.size() - 1
	_expect(hud.character_index == 0, "o primeiro personagem ja vem escolhido")
	_expect(label.text == cfg.CHARACTERS[0]["name"], "o nome do primeiro aparece")
	hud.change_character(1)
	_expect(hud.character_index == 1 and label.text == cfg.CHARACTERS[1]["name"], "para a frente vai ao segundo, e o nome acompanha")
	for i in last:
		hud.change_character(1)
	_expect(hud.character_index == 0, "depois do ultimo volta ao primeiro")
	hud.change_character(-1)
	_expect(hud.character_index == last and label.text == cfg.CHARACTERS[last]["name"], "para tras do primeiro vai ao ultimo")
	_press_start(main)
	_disable_player_collision(main)
	hud.change_character(1)
	_expect(hud.character_index == last, "durante a partida a troca e ignorada")
	await _cleanup(main)


func _test_ca07_personagem_na_partida() -> void:
	print("CA-07: o personagem escolhido aparece na partida e anima ao andar")
	var main = _new_main()
	await process_frame
	main.get_node("HUD").change_character(1)
	_press_start(main)
	_disable_player_collision(main)
	await process_frame
	var art = cfg.ART_DIR + cfg.CHARACTERS[1]["art"]
	_expect(_player_frame_path(main, &"right").begins_with(art + "_andar_"), "andando de lado usa a arte do segundo personagem")
	_expect(_player_frame_path(main, &"up").begins_with(art + "_subir_"), "andando para cima usa a arte do segundo personagem")
	var sprite = main.get_node("Player/AnimatedSprite2D")
	Input.action_press(&"move_right")
	await _wait(0.3)
	_expect(sprite.is_playing() and sprite.animation == &"right", "ao andar, a animacao toca")
	Input.action_release(&"move_right")
	await _cleanup(main)


func _test_ca08_escolha_mantida() -> void:
	print("CA-08: a escolha continua valendo na partida seguinte")
	var main = _new_main()
	await process_frame
	var hud = main.get_node("HUD")
	hud.change_character(2)
	_press_start(main)
	_disable_player_collision(main)
	await process_frame
	main.game_over()
	# Espera a mensagem de fim e o botao Jogar voltar.
	await _wait(2.5)
	_expect(hud.get_node("StartButton").visible, "botao Jogar volta depois do fim")
	_press_start(main)
	_disable_player_collision(main)
	await process_frame
	var art = cfg.ART_DIR + cfg.CHARACTERS[2]["art"]
	_expect(hud.character_index == 2, "a escolha continua a mesma")
	_expect(_player_frame_path(main, &"right").begins_with(art + "_andar_"), "o jogador continua com a arte do terceiro personagem")
	await _cleanup(main)


func _test_ca09_tela_inicial_do_tema() -> void:
	print("CA-09: a tela inicial mostra titulo, fundo e personagens do tema")
	var main = _new_main()
	await process_frame
	var hud = main.get_node("HUD")
	_expect(hud.get_node("MessageLabel").text == cfg.TITLE and "Bró" in cfg.TITLE, "titulo do tema aparece")
	_expect(main.get_node("ColorRect").color == cfg.BACKGROUND_COLOR, "fundo usa a cor do tema")
	var names_ok: bool = cfg.CHARACTERS.size() == 3
	for character in cfg.CHARACTERS:
		if character["name"].is_empty():
			names_ok = false
	_expect(names_ok, "ha tres personagens, todos com nome")
	_expect(hud.get_node("CharacterPicker").visible, "o seletor de personagem aparece")
	await _cleanup(main)


func _test_ca15_comeca_na_raul_lopes() -> void:
	print("CA-15: a partida comeca na fase 1, na Raul Lopes")
	var main = _new_main()
	await process_frame
	main.new_game()
	_disable_player_collision(main)
	await process_frame
	_expect(main.phase == 0, "a fase e a 1")
	_expect(_only(main.get_node("Scenery").segment_kinds(), cfg.PHASES[0]["scenery"]), "todo o cenario e o da Raul Lopes")
	await _cleanup(main)


func _test_ca16_chao_anda() -> void:
	print("CA-16: o chao fica parado na tela inicial e desce durante a partida")
	var main = _new_main()
	await process_frame
	var scenery = main.get_node("Scenery")
	_expect(_covers_screen(scenery), "o cenario cobre a tela inicial")
	var start_y = scenery.segments[0].position.y
	await _wait(0.3)
	_expect(scenery.segments[0].position.y == start_y, "na tela inicial o chao fica parado")
	main.new_game()
	_disable_player_collision(main)
	await _wait(cfg.START_DELAY + 0.1)
	var segment = scenery.segments[0]
	var y_before = segment.position.y
	await _wait(1.0)
	var moved = segment.position.y - y_before
	_expect(moved > cfg.SCROLL_SPEED * 0.8 and moved < cfg.SCROLL_SPEED * 1.2, "na partida o chao desce cerca de SCROLL_SPEED por segundo")
	_expect(_scroll_in_steps(scenery, 5 * 720.0), "rolando 5 telas, o cenario cobre a tela o tempo todo")
	await _cleanup(main)


func _test_ca17_fase_2_ufpi() -> void:
	print("CA-17: ao chegar ao minimo da fase 2, a UFPI comeca")
	var main = _new_main()
	await process_frame
	main.new_game()
	_disable_player_collision(main)
	await _wait(cfg.START_DELAY + 0.1)
	var phase_2 = cfg.PHASES[1]
	_reach_phase_2(main)
	_expect(main.phase == 1, "a fase passa a ser a 2")
	_expect(main.get_node("HUD/MessageLabel").text == phase_2["name"], "o nome da fase 2 aparece")
	_expect(is_equal_approx(main.get_node("MobTimer").wait_time, phase_2["mob_spawn_interval"]), "inimigos nascem no intervalo da fase 2")
	var scenery = main.get_node("Scenery")
	_expect(_scroll_in_steps(scenery, 3 * scenery.SEGMENT_HEIGHT), "na troca de fase o cenario continua cobrindo a tela")
	_expect(_only(scenery.segment_kinds(), phase_2["scenery"]), "o cenario que entra por cima e o da UFPI")
	await _cleanup(main)


func _test_ca18_volta_a_fase_1() -> void:
	print("CA-18: uma partida nova volta a fase 1")
	var main = _new_main()
	await process_frame
	main.new_game()
	_disable_player_collision(main)
	await _wait(cfg.START_DELAY + 0.1)
	_reach_phase_2(main)
	_scroll_in_steps(main.get_node("Scenery"), 3 * main.get_node("Scenery").SEGMENT_HEIGHT)
	main.game_over()
	main.new_game()
	_disable_player_collision(main)
	await process_frame
	_expect(main.phase == 0, "a fase volta a ser a 1")
	_expect(_only(main.get_node("Scenery").segment_kinds(), cfg.PHASES[0]["scenery"]), "o cenario volta a ser o da Raul Lopes")
	_expect(is_equal_approx(main.get_node("MobTimer").wait_time, cfg.PHASES[0]["mob_spawn_interval"]), "inimigos voltam ao intervalo da fase 1")
	await _cleanup(main)


func _test_ca24_obstaculo_bloqueia() -> void:
	print("CA-24: o jogador para encostado no obstaculo e desliza ao longo dele")
	var main = _new_main()
	await process_frame
	main.new_game()
	_disable_player_collision(main)
	var player = main.get_node("Player")
	var scenery = main.get_node("Scenery")
	var half = _player_half(player)
	# Obstaculo de teste no meio da avenida, logo acima do jogador (o chao ainda esta parado).
	scenery.add_obstacle(scenery.segments[0], Rect2(200, 200, 80, 40), "teste")
	player.position = Vector2(240, 300)
	var touching_y = 240 + half.y
	Input.action_press(&"move_up")
	await _wait(0.3)
	_expect(absf(player.position.y - touching_y) < 1.0, "andando contra o obstaculo, para encostado nele")
	var x_before = player.position.x
	Input.action_press(&"move_right")
	await _wait(0.15)
	Input.action_release(&"move_up")
	Input.action_release(&"move_right")
	_expect(absf(player.position.y - touching_y) < 1.0, "na diagonal, continua encostado sem atravessar")
	_expect(player.position.x > x_before + 10, "e anda de lado, deslizando ao longo do obstaculo")
	await _cleanup(main)


func _test_ca25_chao_empurra() -> void:
	print("CA-25: obstaculo que desce empurra o jogador; empurrado para fora, torrou")
	var main = _new_main()
	await process_frame
	main.new_game()
	_disable_player_collision(main)
	await _wait(cfg.START_DELAY + 0.1)
	var player = main.get_node("Player")
	var scenery = main.get_node("Scenery")
	var half = _player_half(player)
	# Obstaculo logo acima do jogador parado no meio da avenida (coordenadas do trecho, que ja desceu um pouco).
	player.position = Vector2(240, 560)
	var segment = scenery.segments[0]
	scenery.add_obstacle(segment, Rect2(200, 560 - half.y - 30 - segment.position.y, 80, 30), "teste")
	await _wait(0.5)
	_expect(player.position.y > 560 + cfg.SCROLL_SPEED * 0.5 * 0.7, "o jogador foi empurrado para baixo junto com o chao")
	_expect(player.visible, "empurrado, mas ainda na tela, continua jogando")
	await _wait(1.6)
	_expect(not player.visible, "empurrado para fora da tela por baixo, o jogador some")
	_expect(main.get_node("ScoreTimer").is_stopped(), "a partida termina")
	_expect(main.get_node("HUD/MessageLabel").text == cfg.MSG_GAME_OVER, "mensagem de fim de jogo aparece")
	await _cleanup(main)


func _test_ca26_chao_muda_o_passo() -> void:
	print("CA-26: a velocidade depende do chao sob o jogador")
	var speeds = cfg.GROUND_SPEED
	_expect(speeds["calcada"] > speeds["asfalto"], "no calcadao anda mais rapido que no asfalto")
	_expect(speeds["grama"] < speeds["asfalto"] and speeds["areia"] < speeds["asfalto"], "na grama e na areia anda mais devagar")
	var main = _new_main()
	await process_frame
	main.new_game()
	_disable_player_collision(main)
	var player = main.get_node("Player")
	var scenery = main.get_node("Scenery")
	var grounds = [scenery.ground_at(Vector2(160, 300)), scenery.ground_at(Vector2(300, 300)), scenery.ground_at(Vector2(24, 300)), scenery.ground_at(Vector2(334, 300))]
	_expect(grounds == ["asfalto", "calcada", "grama", "areia"], "a Raul Lopes tem asfalto, calcadao, grama e areia")
	player.position = Vector2(160, 650)
	var on_asphalt = await _walk(player, &"move_up", 0.2)
	player.position = Vector2(24, 650)
	var on_grass = await _walk(player, &"move_up", 0.2)
	_expect(on_asphalt > 0 and absf(on_grass / on_asphalt - speeds["grama"]) < 0.05, "na grama anda a fracao GROUND_SPEED do asfalto")
	await _cleanup(main)


func _test_ca27_obstaculos_das_fases() -> void:
	print("CA-27: cada fase tem seus obstaculos e sempre um caminho livre")
	var main = _new_main()
	await process_frame
	var scenery = main.get_node("Scenery")
	var half = _player_half(main.get_node("Player"))
	var start = main.get_node("StartPosition").position
	var expected = {"raul_lopes": ["rio", "arvore", "carnauba", "mastro", "carro"], "ufpi": ["predio", "arvore", "carro", "portal"]}
	var all_obstacles := []
	for phase in cfg.PHASES.size():
		scenery.reset(phase)
		var kind = cfg.PHASES[phase]["scenery"]
		var kinds = _obstacle_kinds(scenery)
		_expect(expected[kind].all(func(k): return k in kinds), "%s tem os obstaculos esperados" % kind)
		_expect(not _blocked(scenery, Rect2(start - half, half * 2)), "%s: a posicao inicial esta livre" % kind)
		all_obstacles.append_array(scenery.obstacle_rects())
	scenery.reset(0)
	var deck = Vector2(320, scenery.BRIDGE_Y + 40)
	_expect(_blocked(scenery, Rect2(Vector2(420, scenery.BRIDGE_Y - 100), Vector2.ONE)), "o rio bloqueia")
	_expect(not _blocked(scenery, Rect2(deck, Vector2.ONE)) and scenery.ground_at(deck) == "asfalto", "o tabuleiro da ponte e chao de andar")
	# Uma coluna da largura do jogador, de cima a baixo dos dois trechos, sem obstaculo em nenhuma fase.
	var corridor := false
	for x in range(56 + int(half.x), 272 - int(half.x)):
		var column = Rect2(x - half.x, -scenery.SEGMENT_HEIGHT, half.x * 2, 2 * scenery.SEGMENT_HEIGHT)
		if not all_obstacles.any(func(obstacle): return obstacle.intersects(column)):
			corridor = true
	_expect(corridor, "a avenida tem um corredor livre de cima a baixo nas duas fases")
	await _cleanup(main)


func _test_ca30_altura_em_perspectiva() -> void:
	print("CA-30: o que e alto aparece em perspectiva e muda conforme o chao anda")
	var tall = load("res://tall.gd")
	var camera: Vector2 = cfg.DEPTH_CAMERA
	_expect(tall.project(camera, 100.0).is_equal_approx(camera), "bem embaixo da camera, o topo nao se afasta")
	var near: Vector2 = tall.project(camera + Vector2(100, 0), 50.0) - (camera + Vector2(100, 0))
	var far: Vector2 = tall.project(camera + Vector2(200, 0), 50.0) - (camera + Vector2(200, 0))
	var higher: Vector2 = tall.project(camera + Vector2(100, 0), 100.0) - (camera + Vector2(100, 0))
	_expect(near.x > 0 and far.x > near.x and higher.x > near.x, "mais longe da camera ou mais alto, o topo se afasta mais")
	var main = _new_main()
	await process_frame
	var scenery = main.get_node("Scenery")
	scenery.reset(1)
	var buildings = _tall_things(scenery).filter(func(thing): return thing.walls and thing.label != "")
	_expect(buildings.size() > 0, "a UFPI tem predios com altura")
	if buildings.size() > 0:
		var building = buildings[0]
		var base_before = building.base
		var gap_before = building.top_rect().position - building.base.position
		scenery.scroll(200)
		var gap_after = building.top_rect().position - building.base.position
		_expect(not gap_before.is_equal_approx(gap_after), "ao rolar o chao, o topo muda de lugar em relacao ao pe")
		_expect(building.base == base_before, "o pe continua no mesmo lugar do trecho")
	await _cleanup(main)


func _test_ca31_alto_e_ordem() -> void:
	print("CA-31: as fases tem coisas altas, por cima do jogador e por baixo dos inimigos")
	var main = _new_main()
	await process_frame
	var scenery = main.get_node("Scenery")
	var things = _tall_things(scenery)
	_expect(things.any(func(thing): return not thing.cables.is_empty()), "a Raul Lopes tem o mastro com cabos")
	_expect(things.any(func(thing): return thing.texture != null), "a Raul Lopes tem copas no alto")
	scenery.reset(1)
	things = _tall_things(scenery)
	_expect(things.any(func(thing): return thing.walls and thing.label != ""), "a UFPI tem predios")
	_expect(things.any(func(thing): return thing.texture != null), "a UFPI tem copas no alto")
	var tall_z = things[0].z_index if things.size() > 0 else 0
	_expect(main.get_node("Player").z_index < tall_z, "o alto aparece por cima do jogador")
	main.new_game()
	_disable_player_collision(main)
	main._on_MobTimer_timeout()
	await process_frame
	var mobs = get_nodes_in_group("mobs")
	_expect(mobs.size() > 0 and mobs.all(func(mob): return mob.z_index > tall_z), "os inimigos aparecem por cima do alto")
	await _cleanup(main)


func _test_ca32_sombras() -> void:
	print("CA-32: jogador e inimigos tem sombra no chao, abaixo deles")
	var main = _new_main()
	await process_frame
	main.new_game()
	_disable_player_collision(main)
	var player = main.get_node("Player")
	player.position = Vector2(160, 300)
	await _walk(player, &"move_up", 0.1)
	_expect(player.has_node("Shadow") and player.get_node("Shadow").global_position.y > player.global_position.y, "andando para cima, a sombra fica nos pes")
	await _walk(player, &"move_down", 0.1)
	_expect(player.has_node("Shadow") and player.get_node("Shadow").global_position.y > player.global_position.y, "andando para baixo (jogador girado), a sombra continua nos pes")
	for i in 5:
		main._on_MobTimer_timeout()
	await process_frame
	var mobs = get_nodes_in_group("mobs")
	_expect(mobs.size() > 0 and mobs.all(func(mob): return mob.has_node("Shadow") and mob.get_node("Shadow").global_position.y > mob.global_position.y), "cada inimigo tem a sombra abaixo dele, em qualquer direcao")
	await _cleanup(main)
