extends Control

func _ready():
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/node_2d.tscn")
