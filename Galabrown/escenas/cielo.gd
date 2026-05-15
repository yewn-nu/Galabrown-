extends Sprite2D

var velocidad_cielo = 80

func _ready():
	position = Vector2(640, -720)

func _process(delta):
	position.y += velocidad_cielo * delta
	
	
	if position.y >= 1440: 
		position.y = -687
		
