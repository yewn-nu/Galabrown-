extends Control

func _ready() -> void:
	Scoreboard.guardar_score(GameData.nombre_jugador, GameData.puntuacion)

func _on_boton_jugar_de_nuevo_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")

func _on_boton_menu_principal_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")

func _on_boton_salir_pressed() -> void:
	get_tree().quit()
