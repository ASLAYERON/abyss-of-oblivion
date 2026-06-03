extends Enemy

@onready var climb_time: Timer = $climb_time
@onready var warning: AnimatedSprite2D = $warning
@onready var sleep_sound: AudioStreamPlayer2D = $sleep_sound
@onready var awake_sound: AudioStreamPlayer2D = $awake_sound

var is_climbing: bool = false
var range = 25.0
func custom_behavior(delta):
	if direction: sprite.flip_h = true
	else:  sprite.flip_h = false
	if !is_on_floor():
		velocity += get_gravity() * delta

func _ready() -> void:
	hp = 40
	attack = preload("res://objects/attacks/rat_attack/rat_attack.tscn")
	range_component = $"components/Simple-range_component"
	attack_cast_component = $"components/Simple-cast_component"
	retreat_component = $"components/SleepSound-retreat_component"
	move_component  = $"components/Walk&Climb_component"
	attack_choose_component = $"components/Noise-attack_component"
	idle_component = $"components/Sleep-idle_component"


func _on_climb_time_timeout() -> void:
	is_climbing = false
