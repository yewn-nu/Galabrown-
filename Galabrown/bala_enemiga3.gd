extends Area2D

# ═══════════════════════════════════════════════
#  BALA ENEMIGA
# ═══════════════════════════════════════════════

const VELOCIDAD = 420
const DANIO     = 8

var direccion = Vector2(0, 1)

var frames = [
	preload("res://128px/Plasma_Large_png_processed.png"),
	preload("res://128px/Plasma_Medium_png_processed.png"),
	preload("res://128px/Plasma_Small_png_processed.png"),
]

var frame_actual  = 0
var timer_anim    = 0.0
const VEL_ANIM    = 0.10

@onready var sprite = $Sprite2D

func set_direccion(dir: Vector2) -> void:
	direccion = dir.normalized()
	rotation  = dir.angle() + deg_to_rad(90)

func _ready():
	sprite.texture = frames[0]

func _process(delta):
	position += direccion * VELOCIDAD * delta
	timer_anim -= delta
	if timer_anim <= 0:
		timer_anim   = VEL_ANIM
		frame_actual = (frame_actual + 1) % frames.size()
		sprite.texture = frames[frame_actual]
	if position.y > 820 or position.y < -50 or position.x < -50 or position.x > 1330:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("jugador"):
		area.recibir_danio(DANIO)
		queue_free()
