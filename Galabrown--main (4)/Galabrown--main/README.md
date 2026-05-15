Desarrollo de Videojuego 2D Shooter Espacial

1. Introducción
El presente informe describe el desarrollo de un videojuego 2D tipo shooter espacial, implementado utilizando el motor gráfico Godot Engine y el lenguaje de programación GDScript.
El proyecto tiene como objetivo aplicar conceptos fundamentales de programación, lógica de videojuegos y diseño de sistemas interactivos, mediante la creación de un juego funcional con mecánicas completas.

2. Objetivo del Proyecto
El objetivo principal del juego es:
•	Controlar una nave espacial
•	Disparar proyectiles
•	Evitar los ataques del jefe
•	Derrotar al jefe final
El jugador debe sobrevivir el mayor tiempo posible mientras elimina amenazas en pantalla.

3. Descripción General del Juego
El juego consiste en un entorno 2D donde el jugador controla una nave que puede desplazarse dentro de los límites de la pantalla y disparar proyectiles.
Durante el juego aparece una nave enemiga estática en pantalla, así como un jefe final que presenta patrones de ataque más complejos.

4. Mecánicas Principales
4.1 Movimiento del Jugador
El jugador puede moverse en las cuatro direcciones utilizando el teclado mediante las teclas de dirección.

4.2 Sistema de Disparo
El jugador puede generar proyectiles (balas) que:
•	Se instancian dinámicamente
•	Se desplazan automáticamente
•	Detectan colisiones con la nave enemiga y el jefe

4.3 Sistema de Nave Enemiga
El juego incluye una nave enemiga con las siguientes características:
•	Presencia en pantalla junto al jefe
•	Detección de colisiones mediante Area2D
•	Reacción al impacto (cambio de color, eliminación)

4.4 Sistema de Jefe (Boss)
El jefe representa la parte más compleja del juego e incluye:
•	Movimiento lateral dinámico
•	Múltiples tipos de ataque:
o	Misiles
o	Embestida
o	Láser
•	Sistema de vida
•	Barra de vida visual
•	Animaciones según estado
•	Efecto visual al recibir daño (flash rojo)

4.5 Sistema de Colisiones
Las colisiones se manejan mediante:
•	Area2D
•	CollisionShape2D
•	Señales como area_entered y body_entered
Esto permite la interacción entre:
•	Jugador y nave enemiga
•	Balas y nave enemiga
•	Jugador y ataques del jefe

4.6 Sistema de Daño
El daño se gestiona mediante funciones como:
recibir_danio()
Cada entidad (jugador, enemigo, jefe) puede:
•	Recibir daño
•	Reducir su vida
•	Ejecutar acciones según su estado

4.7 Feedback Visual y Audio
Se implementaron efectos visuales y de audio para mejorar la experiencia del jugador:
•	Cambio de color al recibir daño (modulate)
•	Animaciones según movimiento
•	Barra de vida visible
•	Música de fondo mediante AudioStreamPlayer

4.8 Pantalla de Game Over
Cuando la nave del jugador pierde toda su vida, el juego carga una pantalla de Game Over.
5. Estructura del Proyecto
El juego está organizado en múltiples escenas independientes:
•	Jugador
•	Bala
•	Enemigo
•	Jefe
•	Misiles
•	Láser
•	Explosión
Cada escena contiene su propia lógica y comportamiento, lo que permite modularidad y reutilización de código.

6. Tecnologías Utilizadas
•	Motor gráfico: Godot Engine
•	Lenguaje de programación: GDScript
•	Sistema de nodos basado en:
o	Area2D
o	Sprite2D
o	CollisionShape2D

7. Lógica del Juego
El flujo principal del juego es el siguiente:
•	El jugador se mueve y dispara
•	Las balas impactan a la nave enemiga y al jefe
•	La nave enemiga y el jefe reciben daño o son destruidos
•	El jefe ejecuta patrones de ataque
•	El jugador evita ataques y contraataca
•	El juego continúa hasta que el jugador o el jefe es derrotado

9. Posibles Mejoras
Para futuras versiones del juego, se pueden implementar:
•	Sistema de vidas del jugador
•	Sistema de puntuación
•	Pantalla de inicio y menú
•	Niveles progresivos
•	Efectos visuales avanzados (partículas, explosiones)

10. Conclusión
El proyecto desarrollado corresponde a un videojuego shooter funcional que integra correctamente conceptos de programación, diseño de sistemas y desarrollo de videojuegos.
El equipo logró implementar las mecánicas básicas del juego utilizando Godot Engine y GDScript, incluyendo el movimiento del jugador, el sistema de disparo, las colisiones y el jefe final como elemento principal.


