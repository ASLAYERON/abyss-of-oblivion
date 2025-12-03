extends Node2D
@onready var void_sprite: AnimatedSprite2D = $void_sprite

func _process(delta: float) -> void:
	void_sprite.play("void")
