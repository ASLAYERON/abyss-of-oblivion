extends StaticBody2D
@onready var knight_statue: Sprite2D = $KnightStatue
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.visible = false

func damage(hp,direction,caster):
	if caster.name == "player":
		animated_sprite_2d.visible = true
		knight_statue.visible = false
		animated_sprite_2d.play("break")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
