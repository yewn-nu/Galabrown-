extends Node2D

# ══════════════════════════════════════════════
# CONFIGURACIÓN
# ══════════════════════════════════════════════
var angulo_deg = 120.0
var angulo_min = 60.0
var angulo_max = 120.0

var velocidad_giro = 28.0
var sentido = -1.0

var longitud = 950.0
var fuerza_atraccion = 100.0

const CD_DANIO = 0.5
var cd_danio = 0.0


# ══════════════════════════════════════════════
# ANIMACIÓN
# ══════════════════════════════════════════════
var frames_laser = [
	preload("res://sprites/Jefe1/lazer7.png"),
	preload("res://sprites/Jefe1/lazer8.png"),
	preload("res://sprites/Jefe1/lazer9.png"),
]

var frame_actual = 0
var timer_anim = 0.0
var vel_anim = 0.08


# Referencias
var jugador_ref = null
var jugador_en_contacto = null


# ══════════════════════════════════════════════
# NODOS
# ══════════════════════════════════════════════
@onready var sprite = $Sprite

@onready var zona_contacto = $ZonaContacto
@onready var zona_atraccion = $ZonaAtraccion


# ══════════════════════════════════════════════
# INICIO
# ══════════════════════════════════════════════
func _ready():

	sprite.texture = frames_laser[0]
	sprite.flip_v = true

	# conectar señales
	zona_contacto.area_entered.connect(_on_area_entered)
	zona_contacto.area_exited.connect(_on_area_exited)


# ══════════════════════════════════════════════
# LOOP
# ══════════════════════════════════════════════
func _process(delta):

	cd_danio = max(cd_danio - delta, 0.0)

	_animar(delta)

	_rotar_laser(delta)

	_aplicar_atraccion(delta)

	_aplicar_danio()


# ══════════════════════════════════════════════
# ANIMACIÓN
# ══════════════════════════════════════════════
func _animar(delta):

	timer_anim -= delta

	if timer_anim <= 0.0:

		timer_anim = vel_anim

		frame_actual = (frame_actual + 1) % frames_laser.size()

		sprite.texture = frames_laser[frame_actual]


# ══════════════════════════════════════════════
# ROTAR
# ══════════════════════════════════════════════
func _rotar_laser(delta):

	angulo_deg += velocidad_giro * sentido * delta

	if angulo_deg <= angulo_min:
		sentido = 1.0

	elif angulo_deg >= angulo_max:
		sentido = -1.0


	var rad = deg_to_rad(angulo_deg)

	var dir = Vector2(cos(rad), sin(rad))


	sprite.rotation = rad - deg_to_rad(90.0)
	sprite.position = dir * (longitud / 2.0)


	var ancho_tex = sprite.texture.get_width()

	if ancho_tex > 0:
		sprite.scale.x = longitud / ancho_tex


	var centro = dir * (longitud / 2.0)

	zona_contacto.position = centro
	zona_contacto.rotation = rad

	zona_atraccion.position = centro
	zona_atraccion.rotation = rad


# ══════════════════════════════════════════════
# ATRACCIÓN
# ══════════════════════════════════════════════
func _aplicar_atraccion(delta):

	if not jugador_ref:
		return

	if not is_instance_valid(jugador_ref):
		return


	var rad = deg_to_rad(angulo_deg)

	var dir = Vector2(cos(rad), sin(rad))

	var a_jugador = jugador_ref.global_position - global_position

	var perp = Vector2(-dir.y, dir.x)

	var dist_lateral = perp.dot(a_jugador)


	if abs(dist_lateral) < 160:

		jugador_ref.position -= (
			perp
			* sign(dist_lateral)
			* fuerza_atraccion
			* delta
		)


# ══════════════════════════════════════════════
# DAÑO
# ══════════════════════════════════════════════
func _aplicar_danio():

	if cd_danio > 0.0:
		return

	if not jugador_en_contacto:
		return

	if not is_instance_valid(jugador_en_contacto):
		return


	jugador_en_contacto.recibir_danio(10)

	cd_danio = CD_DANIO


# ══════════════════════════════════════════════
# COLISIONES
# ══════════════════════════════════════════════
func _on_area_entered(area):

	if area.is_in_group("jugador"):
		jugador_en_contacto = area


func _on_area_exited(area):

	if area == jugador_en_contacto:
		jugador_en_contacto = null
