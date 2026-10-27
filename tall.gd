extends Node2D
## Algo alto no cenário (spec 004): prédio, pilar, mastro da ponte, copa de árvore, letreiro.
##
## A câmera olha o chão de cima, a Config.DEPTH_CAMERA_HEIGHT pixels de altura sobre o ponto Config.DEPTH_CAMERA.
## Um ponto alto aparece afastado desse ponto, tanto mais quanto mais alto e mais longe ele estiver: é a perspectiva.
## Como o chão anda, o afastamento muda a cada quadro e a coisa parece ter volume.
## O pé ("base") fica no chão, no mesmo lugar do obstáculo (spec 003); só o que é alto se desloca.
## Quem monta cada coisa alta é o scenery.gd.

const Z_ABOVE_PLAYER := 20    # o jogador tem z_index 10: o alto cobre quem passa atrás dele
const CABLE_COLOR := Color(1, 1, 1, 0.9)

var base = Rect2()            # pé, no chão (coordenadas do trecho)
var height = 0.0              # altura do topo, em pixels
var roof_color = Color.WHITE
var wall_color = Color.GRAY
var walls = true              # falso para o que fica no alto sem paredes (copa, letreiro, placa)
var round_top = false         # topo redondo (o mirante do mastro)
var label = ""                # texto escrito no topo
var label_size = 20
var label_color = Color(0.25, 0.25, 0.3)
var texture = null            # copa de árvore: desenhada no topo, no lugar do telhado
var cables = []               # pontos no chão ligados ao topo por cabos (Ponte Estaiada)

var _font = preload("res://fonts/Xolonium-Regular.ttf")


# Onde aparece na tela um ponto "point" (da tela, no chão) levado à altura "h".
static func project(point, h):
	var camera = Config.DEPTH_CAMERA
	return camera + (point - camera) * Config.DEPTH_CAMERA_HEIGHT / (Config.DEPTH_CAMERA_HEIGHT - h)


func _init():
	z_index = Z_ABOVE_PLAYER


func _process(_delta):
	queue_redraw() # o chão andou: o topo mudou de lugar


# Ponto "point" deste nó, no chão, levado à altura "h" (também em coordenadas deste nó).
func lift(point, h = height):
	return to_local(project(to_global(point), h))


# Retângulo do topo, em coordenadas deste nó.
func top_rect():
	var start = lift(base.position)
	return Rect2(start, lift(base.end) - start)


func _draw():
	var top = top_rect()
	if walls:
		_draw_walls()
	for point in cables:
		draw_line(top.get_center(), point, CABLE_COLOR, 1.5)
	if texture:
		draw_texture_rect(texture, top, false)
	elif round_top:
		draw_circle(top.get_center(), top.size.x / 2, roof_color.darkened(0.25))
		draw_circle(top.get_center(), top.size.x / 2 - 4, roof_color)
	else:
		draw_rect(top, roof_color.darkened(0.25))
		draw_rect(top.grow(-4), roof_color)
	if label != "":
		var baseline = Vector2(top.position.x, top.get_center().y + label_size * 0.35)
		draw_string(_font, baseline, label, HORIZONTAL_ALIGNMENT_CENTER, top.size.x, label_size, label_color)


# Paredes: cada lado do pé ligado ao mesmo lado do topo. Só as viradas para a câmera; as outras ficam atrás do telhado.
func _draw_walls():
	var corners = [base.position, Vector2(base.end.x, base.position.y), base.end, Vector2(base.position.x, base.end.y)]
	var camera = to_local(Config.DEPTH_CAMERA)
	for i in 4:
		var a = corners[i]
		var b = corners[(i + 1) % 4]
		var outward = (b - a).rotated(-PI / 2) # aponta para fora do prédio (os cantos vão em sentido horário)
		if outward.dot(camera - a) > 0:
			var shade = 0.0 if i % 2 == 0 else 0.15 # paredes dos lados um pouco mais escuras que as da frente
			draw_colored_polygon(PackedVector2Array([a, b, lift(b), lift(a)]), wall_color.darkened(shade))
