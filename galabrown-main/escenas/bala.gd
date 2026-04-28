extends Area2D

var velocidad = 900

func _process(delta):
	position.y -= velocidad * delta  # se mueve hacia arriba

func _on_area_entered(area: Area2D) -> void:
	print("impacto con:", area.name)
	
	if area.name == "Enemigo":
		area.queue_free()  # elimina enemigo
		queue_free()       # elimina bala
