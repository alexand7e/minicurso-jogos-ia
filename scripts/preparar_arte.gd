extends SceneTree
## Prepara a arte do tema B-R-O Bró (specs 001 e 002) a partir dos pacotes originais, todos CC0.
## Só precisa rodar de novo se quiser trocar ou ajustar a arte; o resultado já está em art/teresina/.
##
## 1) Baixe e extraia numa pasta qualquer (fora do projeto):
##    - https://kenney.nl/assets/toon-characters   -> pasta kenney_toon-characters/
##    - https://kenney.nl/assets/particle-pack     -> pasta kenney_particle-pack/
##    - https://opengameart.org/content/shiny-sun  -> arquivo sun_shiny.png (na raiz da pasta)
##    - https://kenney.nl/assets/racing-pack       -> pasta kenney_racing-pack/
##    - https://kenney.nl/assets/pirate-pack       -> pasta kenney_pirate-pack/
## 2) Rode, na raiz do projeto:
##    godot --headless --path . -s res://scripts/preparar_arte.gd -- /caminho/da/pasta
## 3) Rode scripts/check.sh para a Godot importar os arquivos novos.

const OUT_DIR := "res://art/teresina/"

# Personagem do jogo -> pasta e nome usados pelo pacote Toon Characters.
const CHARACTERS := {
	"vendedor": ["Male person", "malePerson"],
	"estudante": ["Female person", "femalePerson"],
	"teresinense": ["Male adventurer", "maleAdventurer"],
}
const CHARACTER_SIZE := Vector2i(144, 192)   # o jogador aparece com metade disso na tela
const MOB_SIZE := Vector2i(128, 128)         # o inimigo aparece com 3/4 disso na tela

# Peças do cenário das fases (spec 002), copiadas sem mudança: nome no jogo -> arquivo no pacote.
const SCENERY := {
	"asfalto": "kenney_racing-pack/PNG/Tiles/Asphalt road/road_asphalt22.png",
	"grama": "kenney_racing-pack/PNG/Tiles/Grass/land_grass04.png",
	"arvore_grande": "kenney_racing-pack/PNG/Objects/tree_large.png",
	"arvore_pequena": "kenney_racing-pack/PNG/Objects/tree_small.png",
	"carro_1": "kenney_racing-pack/PNG/Cars/car_blue_small_1.png",
	"carro_2": "kenney_racing-pack/PNG/Cars/car_red_small_3.png",
	"agua": "kenney_pirate-pack/PNG/Default size/Tiles/tile_73.png",
	"areia": "kenney_pirate-pack/PNG/Default size/Tiles/tile_68.png",
	"carnauba": "kenney_pirate-pack/PNG/Default size/Tiles/tile_71.png",
	"aguape": "kenney_pirate-pack/PNG/Default size/Tiles/tile_70.png",
}

var src := ""


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		push_error("Informe a pasta dos pacotes. Veja o comentario no topo deste arquivo.")
		quit(2)
		return
	src = args[0]
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT_DIR + "cenario"))
	_prepare_characters()
	_prepare_mobs()
	_prepare_scenery()
	print("Arte pronta em ", OUT_DIR)
	quit()


func _prepare_characters() -> void:
	for character in CHARACTERS:
		var folder: String = CHARACTERS[character][0]
		var kenney_name: String = CHARACTERS[character][1]
		var poses := "%s/kenney_toon-characters/%s/PNG/Poses HD/character_%s_" % [src, folder, kenney_name]
		# "andar": andando de lado (8 quadros). "subir": de costas, subindo (2 quadros).
		for i in 8:
			_save(_resized(Image.load_from_file(poses + "walk%d.png" % i), CHARACTER_SIZE), "%s_andar_%d" % [character, i])
		for i in 2:
			_save(_resized(Image.load_from_file(poses + "climb%d.png" % i), CHARACTER_SIZE), "%s_subir_%d" % [character, i])


func _prepare_mobs() -> void:
	var particles := src + "/kenney_particle-pack/PNG (Transparent)/"
	var sun_disc := _resized(Image.load_from_file(src + "/sun_shiny.png"), Vector2i(100, 100))

	# Sol: raios coloridos de laranja a amarelo, com o disco do sol por cima.
	var sun_colors := _gradient([Color(0.95, 0.35, 0.05), Color(1.0, 0.75, 0.1), Color(1.0, 1.0, 0.7)])
	var sun_rays := ["star_09", "star_08"]
	for i in 2:
		var img := _colored(_cropped(particles + sun_rays[i] + ".png", 40), sun_colors)
		img.blend_rect(sun_disc, Rect2i(Vector2i.ZERO, sun_disc.get_size()), (MOB_SIZE - sun_disc.get_size()) / 2)
		_save(img, "sol_%d" % (i + 1))

	# Brasa: fogo de vermelho escuro a amarelo.
	var fire_colors := _gradient([Color(0.6, 0.05, 0.0), Color(1.0, 0.4, 0.0), Color(1.0, 0.9, 0.3)])
	for i in 2:
		_save(_colored(_cropped(particles + "fire_0%d.png" % (i + 1), 120), fire_colors), "brasa_%d" % (i + 1))

	# Mormaço: nuvem de poeira quente, cor de areia.
	var dust_colors := _gradient([Color(0.85, 0.55, 0.3), Color(1.0, 0.9, 0.7)])
	var dust_clouds := ["smoke_04", "smoke_07"]
	for i in 2:
		_save(_colored(_cropped(particles + dust_clouds[i] + ".png", 24), dust_colors), "mormaco_%d" % (i + 1))


func _prepare_scenery() -> void:
	for piece in SCENERY:
		_save(Image.load_from_file(src + "/" + SCENERY[piece]), "cenario/" + piece)


# ---------------------------------------------------------------- utilitarios

func _resized(img: Image, size: Vector2i) -> Image:
	img.convert(Image.FORMAT_RGBA8)
	img.resize(size.x, size.y, Image.INTERPOLATE_LANCZOS)
	return img


# Corta "margin" pixels de cada lado (as partículas têm muita borda vazia) e reduz para MOB_SIZE.
func _cropped(path: String, margin: int) -> Image:
	var img := Image.load_from_file(path)
	img.convert(Image.FORMAT_RGBA8)
	var side := img.get_width() - 2 * margin
	return _resized(img.get_region(Rect2i(margin, margin, side, side)), MOB_SIZE)


func _gradient(colors: Array) -> Gradient:
	var gradient := Gradient.new()
	gradient.colors = PackedColorArray(colors)
	var offsets := PackedFloat32Array()
	for i in colors.size():
		offsets.append(i / float(colors.size() - 1))
	gradient.offsets = offsets
	return gradient


# As partículas são brancas; aqui o brilho de cada pixel vira uma cor do degradê.
func _colored(img: Image, gradient: Gradient) -> Image:
	for y in img.get_height():
		for x in img.get_width():
			var pixel := img.get_pixel(x, y)
			var color := gradient.sample(pixel.v * pixel.a)
			color.a = pixel.a
			img.set_pixel(x, y, color)
	return img


func _save(img: Image, file_name: String) -> void:
	var path := ProjectSettings.globalize_path(OUT_DIR + file_name + ".png")
	var err := img.save_png(path)
	if err != OK:
		push_error("Nao consegui salvar " + path)
