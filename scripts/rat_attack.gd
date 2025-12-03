extends Node2D
var turn :bool = false
var offset=Vector2(0,0)
var direction:bool=false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if direction:
		turn=true
		offset=Vector2(10,0)
	else:
		turn=false
		offset=Vector2(-10,0)		
	animated_sprite_2d.flip_h=turn
	animated_sprite_2d.play("attack")
	position=offset
	
func _on_attack_body_entered(body: Node2D) -> void:
	if body.name=="player":
		pass
		body.damage(1,direction)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
