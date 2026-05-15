extends Node2D

const ENEMIGOS_POR_OLEADA = 12
const TIEMPO_ENTRE_OLEADAS = 11.0
const MAX_ENEMIGOS = 30

@onready var musica : AudioStreamPlayer = $Musica

# Por ahora no existe el Label visual
var label_score = null

const JEFE_ESCENA = preload("res://escenas/Jefe.tscn")
var jefe = null

var musicafondo = preload("res://Musicas/Musica1.ogg")

# Tus 2 enemigos
var EnemigoMio = preload("res://enemigo_disparador.tscn")
var EnemigoAmigo = preload("res://enemigo.tscn")

var cd_oleada = 2.0


func _ready() -> void:
	musica.stream = musicafondo
	musica.play()

	GameData.reiniciar()

	GameData.score_cambiado.connect(_actualizar_score)
	GameData.invocar_jefe.connect(_mostrar_jefe)


func _process(delta) -> void:
	if GameData.jefe_aparecio:
		return

	cd_oleada -= delta

	if cd_oleada <= 0:
		cd_oleada = TIEMPO_ENTRE_OLEADAS
		_spawnear_oleada()


func _spawnear_oleada() -> void:

	var vivos = get_tree().get_nodes_in_group("enemigos").size()

	if vivos >= MAX_ENEMIGOS:
		return

	var cantidad = min(ENEMIGOS_POR_OLEADA, MAX_ENEMIGOS - vivos)

	for i in range(cantidad):

		var enemigo

		# Elegir aleatoriamente cuál aparece
		if randf() > 0.5:
			enemigo = EnemigoMio.instantiate()
		else:
			enemigo = EnemigoAmigo.instantiate()

		enemigo.position = Vector2(
			randf_range(100, 1180),
			-60 - (i * 40)
		)

		add_child(enemigo)


func _mostrar_jefe() -> void:
	if jefe != null:
		return

	jefe = JEFE_ESCENA.instantiate()
	add_child(jefe)


func _actualizar_score(nuevo_score: int) -> void:
	if label_score:
		label_score.text = "SCORE: %06d" % nuevo_score
