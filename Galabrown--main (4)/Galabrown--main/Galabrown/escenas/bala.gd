extends Area2D

var velocidad = 900

func _process(delta):
	position.y -= velocidad * delta

	if position.y < -50:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemigos"):
		area.queue_free()
		queue_free()
