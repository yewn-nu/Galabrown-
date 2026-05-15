extends Area2D

var velocidad  = 400
var BalaEscena = preload("res://escenas/Bala.tscn")

var vida_max = 100
var vida     = vida_max

var velocidad_dash = 850
var duracion_dash = 0.35
var cooldown_dash = 0.8

var tiempo_dash = 0.0
var cooldown_actual = 0.0
var direccion_dash = Vector2.ZERO
var ultima_direccion = Vector2.UP

@onready var barra = $BarraVida

func _ready():
	barra.max_value = vida_max
	barra.value     = vida_max

func _process(delta):
	var movimientoInput = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		movimientoInput.x -= 1
	if Input.is_action_pressed("ui_right"):
		movimientoInput.x += 1
	if Input.is_action_pressed("ui_up"):
		movimientoInput.y -= 1
	if Input.is_action_pressed("ui_down"):
		movimientoInput.y += 1

	if movimientoInput != Vector2.ZERO:
		movimientoInput = movimientoInput.normalized()
		ultima_direccion = movimientoInput

	cooldown_actual -= delta
	
	if Input.is_key_pressed(KEY_SHIFT) and cooldown_actual <= 0:
		print("DASH ACTIVADO")
		tiempo_dash = duracion_dash
		cooldown_actual = cooldown_dash
		direccion_dash = ultima_direccion

	if tiempo_dash > 0:
		position += direccion_dash * velocidad_dash * delta
		tiempo_dash -= delta
	else:
		position += movimientoInput * velocidad * delta

	var pantalla = get_viewport_rect().size
	position.x = clamp(position.x, 40, pantalla.x - 40)
	position.y = clamp(position.y, 40, pantalla.y - 40)

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
	get_tree().change_scene_to_file("res://pantallagameover.tscn")
	
	
