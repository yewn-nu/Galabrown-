extends Area2D

# ══════════════════════════════════════════════
# CONFIG
# ══════════════════════════════════════════════
const DANIO_EXPLOSION = 20

var ya_danio = false
var duracion = 0.30
var timer = 0.0


# ══════════════════════════════════════════════
# ANIMACIÓN
# ══════════════════════════════════════════════
var frames_explosion = [

	preload("res://sprites/Jefe1/explosion1.png"),
	preload("res://sprites/Jefe1/explosion2.png"),
	preload("res://sprites/Jefe1/explosion3.png")

]

var frame_actual = 0
var timer_anim = 0.0
var velocidad_anim = 0.06


# ══════════════════════════════════════════════
# NODOS
# ══════════════════════════════════════════════
@onready var sprite = $Sprite2D


# ══════════════════════════════════════════════
# READY
# ══════════════════════════════════════════════
func _ready():

	sprite.texture = frames_explosion[0]

	# Espera 1 frame físico para registrar colisiones
	await get_tree().physics_frame

	_aplicar_danio()


# ══════════════════════════════════════════════
# LOOP
# ══════════════════════════════════════════════
func _process(delta):

	timer += delta


	# Animación
	timer_anim -= delta

	if timer_anim <= 0.0:

		timer_anim = velocidad_anim

		frame_actual += 1


		if frame_actual < frames_explosion.size():

			sprite.texture = frames_explosion[frame_actual]


	# Destruir al terminar
	if timer >= duracion:

		queue_free()


# ══════════════════════════════════════════════
# DAÑO
# ══════════════════════════════════════════════
func _aplicar_danio():

	if ya_danio:
		return


	var areas = get_overlapping_areas()


	for area in areas:

		if area.is_in_group("jugador"):

			area.recibir_danio(DANIO_EXPLOSION)

			ya_danio = true

			return
