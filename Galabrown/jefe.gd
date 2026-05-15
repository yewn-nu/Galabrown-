extends Area2D

# ═══════════════════════════════════════════════════════
#  JEFE — res://jefe.gd
#  GRUPO que debe tener el nodo raíz: jefe
#
#  CAMBIO RESPECTO AL ORIGINAL:
#  _morir() ahora va a pantallavictoria.tscn en vez de
#  solo hacer queue_free()
# ═══════════════════════════════════════════════════════

# ── CONFIGURACIÓN ────────────────────────────────────────
const VIDA_MAX       = 200
const VEL_BASE       = 140.0
const VEL_ESQUIVE    = 360.0
const LIMITE_IZQ     = 80.0
const LIMITE_DER     = 1200.0

const DURACION_ESQUIVE = 1.0
const CD_ESQUIVE       = 12.0

const CD_LASER         = 24.0
const CD_EMBESTIDA     = 5.0
const CD_MISILES       = 3.0

const VEL_EMBESTIDA    = 770
const DURACION_LASER   = 3.5

# ── SPRITES ──────────────────────────────────────────────
var tex_base       = preload("res://sprites/Jefe1/Base.png")
var tex_base_sin   = preload("res://sprites/Jefe1/Base-sin-misiles.png")
var tex_izquierda  = preload("res://sprites/Jefe1/IZQUIERDA.png")
var tex_izquierda2 = preload("res://sprites/Jefe1/IZQUIERDA 2.png")
var tex_derecha    = preload("res://sprites/Jefe1/DERECHA.png")
var tex_derecha2   = preload("res://sprites/Jefe1/DERECHA2.png")
var tex_embestida  = preload("res://sprites/Jefe1/EMBESTIDA.png")
var tex_rayo       = preload("res://sprites/Jefe1/NAVE-RAYO.png")

# ── VARIABLES ────────────────────────────────────────────
var vida = VIDA_MAX

var direccion  = 1.0
var mov_x_ant  = 0.0
var x_base     = 0.0

var cd_laser     = 0.0
var cd_embestida = 0.0
var cd_misiles   = 0.0
var cd_esquive   = 0.0

var esquivando       = false
var timer_esquive    = 0.0
var regresando_base  = false

var timer_ataque  = 1.5
var indice_ataque = 0

var embestiendo       = false
var pos_origen        = Vector2()
var objetivo_embestida = Vector2()
var regresando        = false

var misiles_usados = false

var laser_activo = false
var laser_nodo   = null
var laser_timer  = 0.0

var timer_anim   = 0.0
var dir_anterior = 0.0

var EscenaMisil = preload("res://escenas/Misil.tscn")
var EscenaLaser = preload("res://escenas/Laser.tscn")

@onready var sprite = $Sprite
@onready var barra  = $BarraVida

var jugador = null

# ── READY ────────────────────────────────────────────────
func _ready():
	position = Vector2(640, 80)
	x_base   = position.x

	jugador = get_tree().get_first_node_in_group("jugador")

	barra.max_value = VIDA_MAX
	barra.value     = VIDA_MAX
	sprite.texture  = tex_base

# ── PROCESO ─────────────────────────────────────────────
func _process(delta):
	jugador = get_tree().get_first_node_in_group("jugador")

	cd_laser     = max(cd_laser     - delta, 0.0)
	cd_embestida = max(cd_embestida - delta, 0.0)
	cd_misiles   = max(cd_misiles   - delta, 0.0)
	cd_esquive   = max(cd_esquive   - delta, 0.0)

	if laser_activo:
		laser_timer -= delta
		if laser_timer <= 0.0:
			_terminar_laser()

	if regresando_base:
		position.x = move_toward(position.x, x_base, VEL_ESQUIVE * delta)
		mov_x_ant  = sign(x_base - position.x)
		if abs(position.x - x_base) < 3.0:
			position.x      = x_base
			regresando_base = false
		_actualizar_sprite(delta)
		return

	if not esquivando and cd_esquive <= 0.0:
		esquivando    = true
		timer_esquive = DURACION_ESQUIVE
		cd_esquive    = CD_ESQUIVE

	if esquivando:
		_esquivar(delta)
		timer_esquive -= delta
		if timer_esquive <= 0.0:
			esquivando      = false
			regresando_base = true
	else:
		_modo_ataque(delta)

	_actualizar_sprite(delta)

# ── ESQUIVE ──────────────────────────────────────────────
func _esquivar(delta):
	if not jugador:
		return
	var input_jug = 0
	if Input.is_action_pressed("ui_right"):
		input_jug = 1
	elif Input.is_action_pressed("ui_left"):
		input_jug = -1

	var dif_x    = position.x - jugador.position.x
	var dir_huida: float

	if input_jug != 0:
		dir_huida = float(input_jug)
		if dif_x * dir_huida > 380:
			dir_huida = 0.0
	else:
		dir_huida = sign(dif_x) if dif_x != 0 else 1.0

	position.x = clamp(position.x + dir_huida * VEL_ESQUIVE * delta, LIMITE_IZQ, LIMITE_DER)
	mov_x_ant  = dir_huida

# ── ATAQUE ───────────────────────────────────────────────
func _modo_ataque(delta):
	if embestiendo:
		_ejecutar_embestida(delta)
		return
	if laser_activo:
		return

	var mov   = VEL_BASE * direccion * delta
	position.x += mov
	mov_x_ant  = mov

	if position.x >= LIMITE_DER or position.x <= LIMITE_IZQ:
		direccion *= -1

	timer_ataque -= delta
	if timer_ataque <= 0.0:
		_intentar_ataque()
		timer_ataque = 3.0

func _intentar_ataque():
	var intentos = 0
	while intentos < 3:
		match indice_ataque:
			0:
				if cd_misiles <= 0.0:
					_atacar_misiles()
					indice_ataque = 1
					return
			1:
				if cd_embestida <= 0.0:
					_atacar_embestida()
					indice_ataque = 2
					return
			2:
				if cd_laser <= 0.0:
					_atacar_laser()
					indice_ataque = 0
					return
		indice_ataque = (indice_ataque + 1) % 3
		intentos += 1

func _atacar_misiles():
	if not jugador:
		return
	cd_misiles = CD_MISILES
	var y_obj  = jugador.position.y
	for offset in [-60, 60]:
		var m = EscenaMisil.instantiate()
		m.global_position = global_position + Vector2(offset, 30)
		m.y_explosion      = y_obj
		get_parent().add_child(m)
	misiles_usados = true

func _atacar_embestida():
	if not jugador:
		return
	cd_embestida = CD_EMBESTIDA
	embestiendo  = true
	regresando   = false
	pos_origen   = position
	objetivo_embestida   = jugador.position
	objetivo_embestida.y += 100

func _ejecutar_embestida(delta):
	if not jugador:
		return
	if not regresando:
		position = position.move_toward(objetivo_embestida, VEL_EMBESTIDA * delta)
		mov_x_ant = sign(objetivo_embestida.x - position.x)
		if position.distance_to(objetivo_embestida) < 8:
			regresando = true
	else:
		position = position.move_toward(pos_origen, VEL_EMBESTIDA * 0.6 * delta)
		mov_x_ant = sign(pos_origen.x - position.x)
		if position.distance_to(pos_origen) < 5:
			embestiendo = false

func _atacar_laser():
	cd_laser     = CD_LASER
	laser_activo = true
	laser_timer  = DURACION_LASER
	var l = EscenaLaser.instantiate()
	l.global_position = global_position
	l.jugador_ref      = jugador
	get_parent().add_child(l)
	laser_nodo = l

func _terminar_laser():
	laser_activo = false
	if is_instance_valid(laser_nodo):
		laser_nodo.queue_free()

# ── DAÑO ─────────────────────────────────────────────────
func recibir_danio(cantidad = 1):
	vida -= cantidad
	barra.value = vida
	flash_rojo()
	if vida <= 0:
		_morir()

func flash_rojo():
	sprite.modulate = Color(0.827, 0.0, 0.0, 1.0)
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color(1, 1, 1)

# ── MUERTE ───────────────────────────────────────────────
func _morir():
	_terminar_laser()
	# Al morir el jefe → pantalla de victoria
	# pantallavictoria.gd ya guarda el score en el JSON automáticamente
	get_tree().change_scene_to_file("res://pantallavictoria.tscn")

# ── SPRITES ──────────────────────────────────────────────
func _actualizar_sprite(delta):
	if laser_activo:
		sprite.texture = tex_rayo
		return
	if embestiendo:
		sprite.texture = tex_embestida
		return

	var dir_actual = 0.0
	if mov_x_ant > 0.1:
		dir_actual = 1.0
	elif mov_x_ant < -0.1:
		dir_actual = -1.0

	if dir_actual != dir_anterior:
		timer_anim   = 0.5
		dir_anterior = dir_actual

	timer_anim = max(timer_anim - delta, 0.0)

	if dir_actual > 0.0:
		sprite.texture = tex_derecha if timer_anim > 0.0 else tex_derecha2
	elif dir_actual < 0.0:
		sprite.texture = tex_izquierda if timer_anim > 0.0 else tex_izquierda2
	else:
		sprite.texture = tex_base_sin if misiles_usados else tex_base

# ── COLISIONES ───────────────────────────────────────────
func _on_area_entered(area):
	if area.is_in_group("bala_jugador"):
		recibir_danio(1)
		area.queue_free()
		return
	if area.is_in_group("jugador"):
		area.recibir_danio(20)
