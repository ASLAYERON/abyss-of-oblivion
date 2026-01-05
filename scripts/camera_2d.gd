extends Camera2D

@export var randomStrength: float = 1.0
@export var shakeFade: float = 7.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func camera_shake():
	shake_strength = randomStrength

func randomOffset():
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
		
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		offset = randomOffset()
