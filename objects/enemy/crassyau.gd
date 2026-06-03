extends Enemy

@onready var climb_time: Timer = $climb_time

var is_climbing: bool = false
var range = 19.0
func custom_behavior(delta):
	if direction: sprite.flip_h = true
	else:  sprite.flip_h = false
	if !is_on_floor():
		velocity += get_gravity() * delta

func _ready() -> void:
	hp = 60
	knockback = 0
	attack = preload("res://objects/attacks/rat_attack/rat_attack.tscn")
	range_component = $"components/Simple-range_component"
	attack_cast_component = $"components/Simple-cast_component"
	retreat_component = $"components/AttackAnimation-Retreat_component"
	move_component  = $"components/Walk&Climb_component"
	attack_choose_component = $components/Always_attack_component
	idle_component = $components/OnlyAnimateIdle_component


func _on_climb_time_timeout() -> void:
	is_climbing = false
