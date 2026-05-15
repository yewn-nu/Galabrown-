extends Node2D

@onready var musica: AudioStreamPlayer = $Musica

var musicafondo = preload("res://Musicas/Musica1.ogg")
var EscenaJefe  = preload("res://escenas/Jefe.tscn")

func _ready() -> void:
	musica.stream = musicafondo
	musica.play()
	
	var jefe = EscenaJefe.instantiate()
	add_child(jefe)
