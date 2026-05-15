extends Node

# ═══════════════════════════════════════════════════════
#  GAME DATA — Autoload global
#  Guarda el estado de la partida actual.
#  Al terminar, pantallagameover.gd y pantallavictoria.gd
#  leen esto para guardar el score en el JSON.
# ═══════════════════════════════════════════════════════

# Nombre del jugador (se escribe en pantalla_nombre)
var nombre_jugador: String = "JUGADOR"

# Score de esta partida (temporal, no toca el JSON hasta el final)
var puntuacion: int = 0

# ── Cuántos puntos para invocar al jefe ─────────────────
const SCORE_PARA_JEFE: int = 1000

# Para que el jefe aparezca solo UNA VEZ
var jefe_aparecio: bool = false

# ── Señales ─────────────────────────────────────────────
signal score_cambiado(nuevo_score: int)
signal invocar_jefe

# ── Llamar cuando un enemigo recibe daño ────────────────
func sumar_puntos(cantidad: int) -> void:
	puntuacion += cantidad
	emit_signal("score_cambiado", puntuacion)

	if puntuacion >= SCORE_PARA_JEFE and not jefe_aparecio:
		jefe_aparecio = true
		emit_signal("invocar_jefe")

# ── Llamar al inicio de cada partida ────────────────────
func reiniciar() -> void:
	puntuacion    = 0
	jefe_aparecio = false
