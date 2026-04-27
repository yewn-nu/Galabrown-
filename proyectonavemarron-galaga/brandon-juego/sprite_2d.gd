extends Sprite2D

var velocidad = 400
var movimientoInput = Vector2()
var BalaEscena = preload("res://Bala.tscn")

func _process(delta):
	movimientoInput = Vector2()
	
	if Input.is_action_pressed("ui_left"):
		movimientoInput.x -= 1
	if Input.is_action_pressed("ui_right"):
		movimientoInput.x += 1
	if Input.is_action_pressed("ui_up"):
		movimientoInput.y -= 1
	if Input.is_action_pressed("ui_down"):
		movimientoInput.y += 1
	
	movimientoInput = velocidad*(movimientoInput.normalized())
	position += movimientoInput*delta

	if Input.is_action_just_pressed("ui_accept"): 
		var bala = BalaEscena.instantiate()
		bala.global_position = get_node("SpawnBala").global_position
		get_parent().add_child(bala)
	
	
