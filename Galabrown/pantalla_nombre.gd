extends Control

@onready var input_nombre: LineEdit = $CenterContainer/VBoxContainer/InputNombre

func _ready() -> void:
	input_nombre.grab_focus()

func _confirmar() -> void:
	var nombre := input_nombre.text.strip_edges()
	if nombre == "":
		nombre = "JUGADOR"
	GameData.nombre_jugador = nombre.to_upper()
	get_tree().change_scene_to_file("res://escenas/node_2d.tscn")

func _on_boton_ok_pressed() -> void:
	_confirmar()

func _on_input_nombre_text_submitted(_text: String) -> void:
	_confirmar()
