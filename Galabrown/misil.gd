extends Area2D

var velocidad = 430.0
var y_explosion = 500.0

const DANIO_IMPACTO = 10

var frames = [
	preload("res://sprites/Jefe1/MISIL1.png"),
	preload("res://sprites/Jefe1/MISIL2.png"),
	preload("res://sprites/Jefe1/MISIL3.png")
]

var frame_actual = 0
var timer_anim = 0.0
var velocidad_anim = 0.1

var ExplEscena = preload("res://Explosion.tscn")

@onready var sprite = $Sprite2D


func _ready():

	sprite.texture = frames[0]


func _process(delta):

	# Animación
	timer_anim -= delta

	if timer_anim <= 0:

		timer_anim = velocidad_anim

		frame_actual = (
			frame_actual + 1
		) % frames.size()

		sprite.texture = frames[frame_actual]


	# Movimiento
	position.y += velocidad * delta


	# Explosión automática por altura
	if position.y >= y_explosion:

		_explotar()


func _on_area_entered(area):

	if area.is_in_group("jugador"):

		area.recibir_danio(DANIO_IMPACTO)

		call_deferred("_explotar")


func _explotar():

	if not is_inside_tree():
		return


	var expl = ExplEscena.instantiate()

	expl.global_position = global_position

	get_parent().add_child.call_deferred(expl)

	queue_free.call_deferred()
