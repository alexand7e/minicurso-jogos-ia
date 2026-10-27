extends Node2D
## Chão das fases (spec 002): desce durante a partida, dando a sensação de avançar pela rua.
##
## O chão é feito de trechos de 480 x SEGMENT_HEIGHT px. Dois trechos ficam empilhados; quando um sai
## por baixo da tela, ele é apagado e um trecho novo, da fase atual, é montado em cima do outro.
## Cada trecho é montado por código, com peças prontas (art/teresina/cenario/) e formas simples.
## As posições abaixo fazem o papel de uma cena: mude-as aqui para mexer no cenário.
##
## As duas fases têm a avenida no mesmo lugar (x de 56 a 272), para a rua continuar na troca de fase.

const SEGMENT_HEIGHT := 1536.0   # 12 ladrilhos de asfalto: o desenho dos ladrilhos emenda sem corte
const WIDTH := 480.0
const PIECES := "res://art/teresina/cenario/"

const CONCRETE := Color(0.82, 0.8, 0.74)       # calçada
const LANE_WHITE := Color(1, 1, 1, 0.85)       # faixas pintadas
const LANE_YELLOW := Color(1.0, 0.8, 0.1)
const RIVER_TINT := Color(0.7, 0.85, 0.72)     # o Poti é verde-amarronzado, não azul de piscina
const ASPHALT_TINT := Color(0.62, 0.62, 0.66)

var running = false # Verdadeiro durante a partida: só aí o chão anda.
var phase = 0       # Fase cujo cenário é usado nos trechos novos (posição em Config.PHASES).
var segments = []   # Trechos montados, de qualquer ordem.

var _font = preload("res://fonts/Xolonium-Regular.ttf")


func _ready():
	reset(0)


func _process(delta):
	if running:
		scroll(Config.SCROLL_SPEED * delta)


# Volta ao começo: chão parado e dois trechos da fase "new_phase", o de baixo cobrindo a tela.
func reset(new_phase):
	running = false
	phase = new_phase
	for segment in segments:
		segment.queue_free()
	segments.clear()
	_add_segment(0.0)
	_add_segment(-SEGMENT_HEIGHT)


# Os trechos que entrarem por cima a partir de agora serão da fase "new_phase".
func set_phase(new_phase):
	phase = new_phase


# Desce o chão "distance" pixels. Trecho que sai por baixo vira um trecho novo por cima.
func scroll(distance):
	for segment in segments:
		segment.position.y += distance
	for segment in segments.duplicate():
		if segment.position.y >= get_viewport_rect().size.y:
			segments.erase(segment)
			segment.queue_free()
			_add_segment(_top() - SEGMENT_HEIGHT)


# Tipo de cenário de cada trecho montado (por exemplo, ["raul_lopes", "ufpi"]).
func segment_kinds():
	return segments.map(func(segment): return segment.get_meta("scenery"))


func _top():
	var top = INF
	for segment in segments:
		top = min(top, segment.position.y)
	return top


func _add_segment(y):
	var kind = Config.PHASES[phase]["scenery"]
	var segment = Node2D.new()
	segment.set_meta("scenery", kind)
	segment.position.y = y
	match kind:
		"raul_lopes":
			_build_raul_lopes(segment)
		"ufpi":
			_build_ufpi(segment)
	add_child(segment)
	segments.append(segment)


# ------------------------------------------------------------ partes comuns

# Faixa da esquerda (grama), a avenida de mão dupla e o meio-fio dos dois lados.
func _build_avenue(segment):
	_tiles(segment, "grama", Rect2(0, 0, WIDTH, SEGMENT_HEIGHT))
	_tiles(segment, "asfalto", Rect2(56, 0, 216, SEGMENT_HEIGHT), ASPHALT_TINT)
	_box(segment, CONCRETE, Rect2(48, 0, 8, SEGMENT_HEIGHT))
	_box(segment, CONCRETE, Rect2(272, 0, 8, SEGMENT_HEIGHT))
	# Faixa dupla amarela no meio e faixas brancas tracejadas entre as pistas.
	_box(segment, LANE_YELLOW, Rect2(159, 0, 3, SEGMENT_HEIGHT))
	_box(segment, LANE_YELLOW, Rect2(166, 0, 3, SEGMENT_HEIGHT))
	for y in range(0, int(SEGMENT_HEIGHT), 64):
		_box(segment, LANE_WHITE, Rect2(106, y, 4, 32))
		_box(segment, LANE_WHITE, Rect2(218, y, 4, 32))


# Faixa de pedestres atravessando a avenida na altura "y".
func _crosswalk(segment, y):
	for x in range(60, 270, 18):
		_box(segment, LANE_WHITE, Rect2(x, y, 10, 36))


# ------------------------------------------------------- fase 1: Raul Lopes

func _build_raul_lopes(segment):
	_build_avenue(segment)
	# Lado direito: calçadão, margem de areia e o rio Poti.
	_box(segment, CONCRETE, Rect2(280, 0, 44, SEGMENT_HEIGHT))
	_tiles(segment, "areia", Rect2(324, 0, 20, SEGMENT_HEIGHT))
	_tiles(segment, "agua", Rect2(344, 0, WIDTH - 344, SEGMENT_HEIGHT), RIVER_TINT)
	for y in [180, 420, 940, 1180, 1420]:
		_piece(segment, "arvore_pequena", Vector2(302, y), 0.3)
	for y in [100, 380, 760, 1040, 1320]:
		_piece(segment, "carnauba", Vector2(24, y), 0.9)
	# Aguapés boiando no rio.
	for spot in [Vector2(380, 160), Vector2(452, 300), Vector2(398, 860), Vector2(458, 1060), Vector2(372, 1340)]:
		_piece(segment, "aguape", spot, 0.6, spot.x)
	_crosswalk(segment, 700)
	_build_bridge(segment, 560)
	_text(segment, "Rio\nPoti", Vector2(412, 1200), 22, Color(1, 1, 1, 0.75))
	# Nome da avenida pintado no asfalto, nas duas pistas.
	_text(segment, "RAUL\nLOPES", Vector2(218, 1000), 22, LANE_WHITE)
	_text(segment, "RAUL\nLOPES", Vector2(108, 280), 22, LANE_WHITE)


# Ponte Estaiada cruzando o rio a partir da avenida, com o mastro e os cabos vistos de cima.
func _build_bridge(segment, y):
	var deck = Rect2(272, y, WIDTH - 272, 80)
	var mast = Vector2(412, y + 40)
	_tiles(segment, "asfalto", deck, ASPHALT_TINT)
	_box(segment, Color.WHITE, Rect2(deck.position.x, y, deck.size.x, 4))
	_box(segment, Color.WHITE, Rect2(deck.position.x, y + 76, deck.size.x, 4))
	# Sombra comprida do mastro (ele é bem alto), caindo sobre o rio.
	var shadow = Polygon2D.new()
	shadow.color = Color(0, 0, 0, 0.22)
	shadow.polygon = PackedVector2Array([mast + Vector2(-6, 0), mast + Vector2(6, 0), mast + Vector2(66, 300), mast + Vector2(54, 302)])
	segment.add_child(shadow)
	# Cabos saindo do topo do mastro até as bordas do tabuleiro.
	for x in [292, 322, 352, 382, 442, 472, 502]:
		_line(segment, Color(1, 1, 1, 0.9), mast, Vector2(x, y + 4), 1.5)
		_line(segment, Color(1, 1, 1, 0.9), mast, Vector2(x, y + 76), 1.5)
	# Mastro com o mirante no alto.
	_circle(segment, Color(0.75, 0.75, 0.8), mast, 13)
	_circle(segment, Color.WHITE, mast, 9)
	_text(segment, "Ponte\nEstaiada", Vector2(412, y + 140), 18, Color.WHITE)


# --------------------------------------------------------------- fase 2: UFPI

func _build_ufpi(segment):
	_build_avenue(segment)
	_box(segment, CONCRETE, Rect2(280, 0, 20, SEGMENT_HEIGHT))
	for y in [60, 300, 980, 1300]:
		_piece(segment, "arvore_pequena", Vector2(24, y), 0.3)
	# Placa da avenida.
	_box(segment, Color.WHITE, Rect2(302, 22, 176, 40))
	_box(segment, Color(0.1, 0.45, 0.25), Rect2(304, 24, 172, 36))
	_text(segment, "Av. Universitária", Vector2(390, 42), 13, Color.WHITE)
	# Prédios do campus.
	_building(segment, Rect2(308, 100, 80, 100), "CCN", Color(0.93, 0.9, 0.82))
	_building(segment, Rect2(396, 100, 80, 100), "CCHL", Color(0.9, 0.84, 0.74))
	_build_gate(segment, 560)
	_building(segment, Rect2(308, 700, 80, 90), "RU", Color(0.96, 0.82, 0.62))
	_build_parking(segment, Rect2(396, 690, 80, 110))
	_building(segment, Rect2(308, 860, 168, 90), "Biblioteca", Color(0.85, 0.88, 0.92))
	_building(segment, Rect2(308, 1120, 80, 100), "CT", Color(0.9, 0.9, 0.86))
	_building(segment, Rect2(396, 1120, 80, 100), "CCS", Color(0.93, 0.86, 0.86))
	# Muitas árvores: Teresina é a "Cidade Verde".
	for spot in [Vector2(340, 280), Vector2(440, 270), Vector2(390, 400), Vector2(340, 1030), Vector2(440, 1040), Vector2(350, 1300), Vector2(440, 1330)]:
		_piece(segment, "arvore_grande", spot, 0.42)
	_crosswalk(segment, 500)
	# Rua cruzando no fim do trecho: ajuda a emendar com o trecho de baixo, seja da fase que for.
	_tiles(segment, "asfalto", Rect2(280, SEGMENT_HEIGHT - 80, WIDTH - 280, 80), ASPHALT_TINT)


# Entrada do campus: rua para dentro e o portal com o letreiro.
func _build_gate(segment, y):
	_tiles(segment, "asfalto", Rect2(280, y, WIDTH - 280, 72), ASPHALT_TINT)
	_box(segment, Color(0.35, 0.35, 0.4), Rect2(300, y - 14, 18, 100))
	_box(segment, Color(0.35, 0.35, 0.4), Rect2(458, y - 14, 18, 100))
	_box(segment, Color(0, 0, 0, 0.25), Rect2(300, y + 34, 176, 40))
	_box(segment, Color(0.1, 0.28, 0.6), Rect2(300, y + 14, 176, 44))
	_text(segment, "UFPI", Vector2(388, y + 36), 30, Color.WHITE)


# Estacionamento com vagas e dois carros parados.
func _build_parking(segment, rect):
	_box(segment, Color(0.45, 0.45, 0.5), rect)
	for x in range(int(rect.position.x) + 26, int(rect.end.x), 26):
		_box(segment, LANE_WHITE, Rect2(x, rect.position.y + 6, 2, 46))
	_piece(segment, "carro_1", rect.position + Vector2(13, 30), 0.55)
	_piece(segment, "carro_2", rect.position + Vector2(65, 30), 0.55)


# Prédio visto de cima: sombra, telhado, borda e o nome no telhado.
func _building(segment, rect, label, roof):
	_box(segment, Color(0, 0, 0, 0.25), Rect2(rect.position + Vector2(6, 6), rect.size))
	_box(segment, roof.darkened(0.25), rect)
	_box(segment, roof, rect.grow(-4))
	_text(segment, label, rect.get_center(), 20 if label.length() <= 4 else 16, Color(0.25, 0.25, 0.3))


# ------------------------------------------------------------- utilitarios

# Peça repetida como ladrilho para preencher "rect".
func _tiles(segment, piece, rect, tint = Color.WHITE):
	var sprite = Sprite2D.new()
	sprite.texture = load(PIECES + piece + ".png")
	sprite.centered = false
	sprite.region_enabled = true
	sprite.region_rect = Rect2(Vector2.ZERO, rect.size)
	sprite.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	sprite.position = rect.position
	sprite.modulate = tint
	segment.add_child(sprite)


# Uma peça solta (árvore, carro...) centrada em "pos".
func _piece(segment, piece, pos, scale_factor = 1.0, angle = 0.0):
	var sprite = Sprite2D.new()
	sprite.texture = load(PIECES + piece + ".png")
	sprite.position = pos
	sprite.scale = Vector2.ONE * scale_factor
	sprite.rotation = angle
	segment.add_child(sprite)


func _box(segment, color, rect):
	var box = Polygon2D.new()
	box.color = color
	box.polygon = PackedVector2Array([rect.position, Vector2(rect.end.x, rect.position.y), rect.end, Vector2(rect.position.x, rect.end.y)])
	segment.add_child(box)


func _circle(segment, color, center, radius):
	var points = PackedVector2Array()
	for i in 24:
		points.append(center + Vector2.from_angle(TAU * i / 24) * radius)
	var circle = Polygon2D.new()
	circle.color = color
	circle.polygon = points
	segment.add_child(circle)


func _line(segment, color, from, to, width):
	var line = Line2D.new()
	line.default_color = color
	line.width = width
	line.points = PackedVector2Array([from, to])
	segment.add_child(line)


# Texto centrado em "center"; "angle" gira o texto (PI = de cabeça para baixo).
func _text(segment, text, center, size, color, angle = 0.0):
	var label = Label.new()
	label.text = text
	label.add_theme_font_override(&"font", _font)
	label.add_theme_font_size_override(&"font_size", size)
	label.add_theme_color_override(&"font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.size = Vector2(200, size * 3)
	label.position = center - label.size / 2
	label.pivot_offset = label.size / 2
	label.rotation = angle
	segment.add_child(label)
