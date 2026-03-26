extends Node2D
var turn :bool = false
var direction:bool=false
var caster = null
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if direction:
		turn=true
	else:
		turn=false
	animated_sprite_2d.flip_h=turn
	animated_sprite_2d.play("attack")
	
func _on_attack_body_entered(body: Node2D) -> void:
	if (body.name=="player" or (body.is_in_group("enemy") && !caster.is_in_group("enemy"))) && body != caster :
		body.damage(25,direction,caster)
	elif body.is_in_group("attack"):
		caster.is_attacking = false
		body.queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	caster.is_attacking = false
	queue_free()
