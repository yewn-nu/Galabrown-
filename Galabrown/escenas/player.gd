extends Area2D

var velocidad  = 400
var BalaEscena = preload("res://escenas/Bala.tscn")

var vida_max = 100
var vida     = vida_max

@onready var barra = $BarraVida

func _ready():
	barra.max_value = vida_max
	barra.value     = vida_max

func _process(delta):
	var movimientoInput = Vector2()

	if Input.is_action_pressed("ui_left"):
		movimientoInput.x -= 1
	if Input.is_action_pressed("ui_right"):
		movimientoInput.x += 1
	if Input.is_action_pressed("ui_up"):
		movimientoInput.y -= 1
	if Input.is_action_pressed("ui_down"):
		movimientoInput.y += 1

	movimientoInput = velocidad * movimientoInput.normalized()
	position += movimientoInput * delta

	if Input.is_action_just_pressed("ui_accept"):
		var bala = BalaEscena.instantiate()
		bala.global_position = get_node("SpawnBala").global_position
		get_parent().add_child(bala)

func recibir_danio(cantidad = 1):
	vida -= cantidad
	barra.value = vida
	if vida <= 0:
		_morir()

func _morir():
	queue_free()
