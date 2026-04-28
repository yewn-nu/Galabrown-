extends Node2D

var EnemigoEscena = preload("res://enemigo.tscn")

func _ready():
	var enemigo = EnemigoEscena.instantiate()
	enemigo.position = Vector2(500, 100) # posición visible
	add_child(enemigo)
