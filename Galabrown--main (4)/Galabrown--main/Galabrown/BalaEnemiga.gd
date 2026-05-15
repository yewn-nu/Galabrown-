extends Area2D

var velocidad = 350
var danio = 10

func _process(delta):
	position.y += velocidad * delta  # baja hacia el jugador

	if position.y > 800:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("jugador"):
		if area.has_method("recibir_danio"):
			area.recibir_danio(danio)

		queue_free()
