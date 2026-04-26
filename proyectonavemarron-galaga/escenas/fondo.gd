extends Node2D


var velocidad = 60


var nubes = []

func _ready():
	
	for i in range(8):
		crear_nube()

func crear_nube():
	var nube = Sprite2D.new()
	
	
	nube.texture = preload("res://sprites/nube-chica.png")
	
	
	nube.position.x = randf_range(0, 1280)
	nube.position.y = randf_range(0, 720)
	
	
	add_child(nube) # crear en si el objeto
	nubes.append(nube)  #para que este se mueva
	

func _process(delta):
	
	for nube in nubes:
		nube.position.y += velocidad * delta
		
		
		if nube.position.y > 720:# cuando la nube se caiga la sube de nuevo y se repite el ciclosjdkd
			nube.position.y = 0 
			nube.position.x = randf_range(0, 1280)
