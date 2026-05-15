extends Area2D

# BALA DEL JUGADOR

var velocidad = 900

func _process(delta):
	position.y -= velocidad * delta

	if position.y < -50:
		queue_free()


func _on_area_entered(area: Area2D) -> void:

	# Enemigos (compatibilidad con tu código y el de tu amigo)
	if area.is_in_group("enemigo") or area.is_in_group("enemigos"):

		# Sistema nuevo con vida
		if area.has_method("recibir_danio"):
			area.recibir_danio(1)

		# Sistema viejo (muere directo)
		else:
			area.queue_free()

		queue_free()
		return


	# Jefe
	if area.is_in_group("jefe"):
		queue_free()
		return
