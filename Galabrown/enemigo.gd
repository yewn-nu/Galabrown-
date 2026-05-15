extends Area2D

var velocidad = 80
var tiempo_disparo = 1.5
var contador_disparo = 0.0

var BalaEnemiga = preload("res://BalaEnemiga.tscn")

@onready var spawn_bala = $SpawnBala

func _ready():
	add_to_group("enemigos")

func _process(delta):
	position.y += velocidad * delta  # baja hacia el jugador

	var pantalla = get_viewport_rect().size

	if global_position.y > pantalla.y + 80:
		queue_free()

	contador_disparo -= delta

	if contador_disparo <= 0:
		disparar()
		contador_disparo = tiempo_disparo

func disparar():
	var bala = BalaEnemiga.instantiate()
	get_parent().add_child(bala)
	bala.global_position = spawn_bala.global_position

func _on_area_entered(area):
	print("me chocaron:", area.name)
	queue_free()
