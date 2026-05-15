extends Control
class_name Scoreboard

const ARCHIVO := "user://scores.json"
const MAX_ENTRADAS := 10

@onready var contenedor: VBoxContainer = $VBoxContainer/ScrollContainer/Lista

func _ready() -> void:
	_mostrar_scores()

static func guardar_score(nombre: String, puntaje: int) -> void:
	var lista: Array = _cargar()
	lista.append({"nombre": nombre, "puntaje": puntaje})
	lista.sort_custom(func(a, b): return a["puntaje"] > b["puntaje"])

	if lista.size() > MAX_ENTRADAS:
		lista.resize(MAX_ENTRADAS)

	var file := FileAccess.open(ARCHIVO, FileAccess.WRITE)

	if file:
		file.store_string(JSON.stringify(lista))
		file.close()

static func _cargar() -> Array:
	if not FileAccess.file_exists(ARCHIVO):
		return []

	var file := FileAccess.open(ARCHIVO, FileAccess.READ)

	if not file:
		return []

	var contenido := file.get_as_text()
	file.close()

	var resultado = JSON.parse_string(contenido)

	if resultado is Array:
		return resultado

	return []

func _mostrar_scores() -> void:
	var lista: Array = _cargar()

	if lista.is_empty():
		var lbl := Label.new()
		lbl.text = "Aún no hay puntajes guardados."
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		contenedor.add_child(lbl)
		return

	for i in lista.size():
		var entrada: Dictionary = lista[i]

		var fila := HBoxContainer.new()

		var lbl_pos := _make_label("%d." % (i + 1), 60, Color(0.6, 0.6, 0.7))
		var lbl_nom := _make_label(str(entrada["nombre"]), 220, Color(1.0, 1.0, 1.0))
		var lbl_pts := _make_label("%06d" % int(entrada["puntaje"]), 130, Color(1.0, 0.85, 0.1))

		fila.add_child(lbl_pos)
		fila.add_child(lbl_nom)
		fila.add_child(lbl_pts)

		contenedor.add_child(fila)

func _make_label(texto: String, ancho: int, color: Color) -> Label:
	var lbl := Label.new()
	lbl.text = texto
	lbl.custom_minimum_size = Vector2(ancho, 0)
	lbl.add_theme_color_override("font_color", color)
	lbl.add_theme_font_size_override("font_size", 22)

	return lbl

func _on_boton_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
