extends Area2D

var velocidad = 30

func _process(delta):
	position.y += velocidad * delta  # baja hacia el jugador

func _on_area_entered(area):
	print("me chocaron:", area.name)
	queue_free()
