extends Sprite2D

var velocidad = 900

func _process(delta):
	position.y -= velocidad * delta
	
