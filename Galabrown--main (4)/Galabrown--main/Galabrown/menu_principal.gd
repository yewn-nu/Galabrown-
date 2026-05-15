extends Control


func _ready() -> void:
	pass


func _on_boton_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://pantalla_nombre.tscn")

func _on_boton_scoreboard_pressed() -> void:
	get_tree().change_scene_to_file("res://scoreboard.tscn")

func _on_boton_salir_pressed() -> void:
	get_tree().quit()
