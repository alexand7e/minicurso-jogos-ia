extends SceneTree
## Testes de aceitação do jogo. Rodam sem abrir janela.
##
## Cada grupo de verificações corresponde a um critério de aceitação (CA-xx)
## escrito em specs/000-jogo-base/spec.md. Ao criar uma spec nova, adicione
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
