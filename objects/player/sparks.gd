extends AnimatedSprite2D
var rng = RandomNumberGenerator.new()
func sparks(direction):
	position.x = 10
	if direction: position.x = -position.x
	visible = true
	play(str(rng.randi_range(1,3)))

func _on_animation_finished() -> void:
	visible = false
	position.x = 0
