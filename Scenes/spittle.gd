extends Node2D


var speed: float = 400.0
var direction: Vector2

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	# No normalices aquí, se normaliza al asignar
	direction = direction.normalized()

func _physics_process(delta):
	position += direction * speed * delta

	# Destruir el proyectil si sale de la pantalla
	#if position.x < 0 or position.x > get_viewport().size.x or position.y < 0 or position.y > get_viewport().size.y:
		#queue_free()
