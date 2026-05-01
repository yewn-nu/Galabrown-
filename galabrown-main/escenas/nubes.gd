extends Node2D


var velocidad = 150


var nubes = []

var texturas = [
		preload("res://sprites/Fondo/nube-chica.png"),
		preload("res://sprites/Fondo/nube-mediana.png"),
		preload("res://sprites/Fondo/nube-grande.png")
	]

func _ready():
	
	for i in range(8):
		crear_nube()

func crear_nube():
	var nube = Sprite2D.new()
	
	nube.texture = texturas[randi() % texturas.size()]

	nube.position.x = randf_range(0, 1280)
	nube.position.y = randf_range(0, 720)
	
	
	add_child(nube) # crear en si el objeto
	nubes.append(nube)  #para que este se mueva
	

func _process(delta):
	
	for nube in nubes:
		nube.position.y += velocidad * delta
		
		
		if nube.position.y > 820:# cuando la nube se caiga la sube de nuevo y se repite el ciclosjdkd
			nube.position.y = -100 
			nube.position.x = randf_range(0, 1280)
