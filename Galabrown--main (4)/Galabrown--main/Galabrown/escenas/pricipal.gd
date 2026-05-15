extends Node2D

var EnemigoEscena = preload("res://enemigo.tscn")
var rng = RandomNumberGenerator.new()

var max_enemigos = 5
var tiempo_spawn = 2.0
var contador_spawn = 0.0

func _ready():
	rng.randomize()

func _process(delta):
	contador_spawn -= delta

	if contador_spawn <= 0:
		crear_enemigos_si_faltan()
		contador_spawn = tiempo_spawn

func crear_enemigos_si_faltan():
	var enemigos_actuales = get_tree().get_nodes_in_group("enemigos").size()

	if enemigos_actuales >= max_enemigos:
		return

	var espacios_libres = max_enemigos - enemigos_actuales
	var cantidad = rng.randi_range(1, espacios_libres)

	for i in range(cantidad):
		var enemigo = EnemigoEscena.instantiate()

		var x_aleatoria = rng.randf_range(80, 1200)
		var y_aleatoria = rng.randf_range(-200, -50)

		enemigo.position = Vector2(x_aleatoria, y_aleatoria)
		enemigo.add_to_group("enemigos")

		add_child(enemigo)
