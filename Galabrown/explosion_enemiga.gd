extends Node2D

# ═══════════════════════════════════════════════
#  EXPLOSIÓN ENEMIGA — solo visual
# ═══════════════════════════════════════════════

var frames = [
	preload("res://128px/Explosion01_Frame_01_png_processed.png"),
	preload("res://128px/Explosion01_Frame_02_png_processed.png"),
	preload("res://128px/Explosion01_Frame_03_png_processed.png"),
	preload("res://128px/Explosion01_Frame_04_png_processed.png"),
	preload("res://128px/Explosion01_Frame_05_png_processed.png"),
	preload("res://128px/Explosion01_Frame_06_png_processed.png"),
]

var frame_actual = 0
var timer_anim   = 0.0
const VEL_ANIM   = 0.07

@onready var sprite = $Sprite2D

func _ready():
	sprite.texture = frames[0]

func _process(delta):
	timer_anim -= delta
	if timer_anim <= 0:
		timer_anim = VEL_ANIM
		frame_actual += 1
		if frame_actual < frames.size():
			sprite.texture = frames[frame_actual]
		else:
			queue_free()
