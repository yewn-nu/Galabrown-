extends Area2D

# ═══════════════════════════════════════════════
# ENEMIGO DISPARADOR
# ═══════════════════════════════════════════════

const VIDA_MAX          = 3
const VELOCIDAD_BASE    = 90.0
const VELOCIDAD_LATERAL = 60.0
const FRECUENCIA_CAMBIO = 1.2
const CD_DISPARO        = 2.5
const DANIO_AL_JUGADOR  = 15
const PUNTOS_POR_DANIO  = 10

var frames = [
	preload("res://128px/Enemy01_Green_Frame_1_png_processed.png"),
	preload("res://128px/Enemy01_Green_Frame_2_png_processed.png"),
	preload("res://128px/Enemy01_Green_Frame_3_png_processed.png"),
]

var BalaEnemigaEscena      = preload("res://bala_enemiga.tscn")
var ExplosionEnemigaEscena = preload("res://explosion_enemiga.tscn")

var vida          = VIDA_MAX
var jugador       = null
var dir_lateral   = 1.0
var cd_disparo    = 0.0
var timer_lateral = 0.0
var frame_actual  = 0
var timer_anim    = 0.0

const VEL_ANIM = 0.15

@onready var sprite = $Sprite2D


func _ready():

	# IMPORTANTE: agregar al grupo de enemigos
	add_to_group("enemigos")

	sprite.texture = frames[0]
	jugador = get_tree().get_first_node_in_group("jugador")
	cd_disparo = randf_range(0.3, CD_DISPARO)
	timer_lateral = randf_range(0.3, FRECUENCIA_CAMBIO)
	dir_lateral = 1.0 if randf() > 0.5 else -1.0


func _process(delta):

	jugador = get_tree().get_first_node_in_group("jugador")

	_moverse(delta)
	_animar(delta)
	_manejar_disparo(delta)

	if position.y > 820:
		queue_free()


func _moverse(delta):

	if not jugador or not is_instance_valid(jugador):
		position.y += VELOCIDAD_BASE * delta
		return

	var dir = (jugador.global_position - global_position).normalized()

	position += dir * VELOCIDAD_BASE * delta

	timer_lateral -= delta

	if timer_lateral <= 0:
		timer_lateral = FRECUENCIA_CAMBIO
		dir_lateral = -dir_lateral

	position.x += dir_lateral * VELOCIDAD_LATERAL * delta
	position.x = clamp(position.x, 30, 1250)


func _animar(delta):

	timer_anim -= delta

	if timer_anim <= 0:
		timer_anim = VEL_ANIM
		frame_actual = (frame_actual + 1) % frames.size()
		sprite.texture = frames[frame_actual]


func _manejar_disparo(delta):

	cd_disparo -= delta

	if cd_disparo <= 0:
		cd_disparo = CD_DISPARO
		_disparar()


func _disparar():

	var bala = BalaEnemigaEscena.instantiate()

	bala.global_position = global_position

	if jugador and is_instance_valid(jugador):
		bala.set_direccion(jugador.global_position - global_position)

	get_parent().add_child(bala)


func recibir_danio(cantidad: int = 1) -> void:

	vida -= cantidad

	sprite.modulate = Color(1, 0.2, 0.2)

	await get_tree().create_timer(0.1).timeout

	if is_instance_valid(self):
		sprite.modulate = Color(1, 1, 1)

	GameData.sumar_puntos(cantidad * PUNTOS_POR_DANIO)

	if vida <= 0:
		_morir()


func _morir():

	var expl = ExplosionEnemigaEscena.instantiate()

	expl.global_position = global_position

	get_parent().add_child(expl)

	queue_free()


func _on_area_entered(area: Area2D) -> void:

	if area.is_in_group("bala_jugador"):
		area.queue_free()
		recibir_danio(1)
		return

	if area.is_in_group("jugador"):
		area.recibir_danio(DANIO_AL_JUGADOR)
		_morir()
