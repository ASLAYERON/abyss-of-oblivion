extends CharacterBody2D
## ONREADY
@onready var sprite: AnimatedSprite2D = $sprite
@onready var attack_timer: Timer = $attack_timer
@onready var climb_time: Timer = $climb_time

## OBJECT
var player = null
const rat_attack = preload("res://scenes/rat_attack.tscn")

## INT
var SPEED = 1.4
var direction = 0

## BOOL
var player_is_here: bool = false
var is_climbing: bool=false
var attack_availalbe :bool = true
var is_awake: bool = false

## STRING
var path_scene: String = "" #pour se retrouver dans le dict dans Global
var path_name: String = ""

## FLOAT
var CLIMB_VELOCITY: float = -30.0

## Vector2
var start_position: Vector2 = Vector2(0,0)

## EVENT FUNCTIONS
func _on_attack_timer_timeout() -> void:
	attack_availalbe = true

func _on_climb_time_timeout() -> void:
	is_climbing = false

func _on_hear_zone_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_is_here = true
		player = body

func _on_forget_zone_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_is_here = false
		player = null
		is_awake = false

## MAIN LOOP
func _ready() -> void:
	position=start_position

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
	if !is_awake:
		set_collision_layer_value(1,false)
		if player_is_here:
			if player.noise > 30:
				is_awake = true
				set_collision_layer_value(1,true)

		sprite.play("SLEEP")
	else:
		set_collision_layer_value(1,true)
		direction = player.position.x-position.x
		if abs(direction) < 20: #attack range
			if attack_availalbe:
				attack_availalbe=false
				attack_timer.start()
				var new_attack=rat_attack.instantiate()
				if direction >= 0:
					new_attack.direction = direction
				else:
					new_attack.direction = direction >= 0
				add_child(new_attack)
				sprite.play("ATTACK")
			else:
				sprite.play("ATTACK")
		else:
			if is_on_floor() && is_on_wall() && !is_climbing:
				climb_time.start()
				is_climbing=true
				velocity.y = CLIMB_VELOCITY
				sprite.play("climb")
			else:
				if is_climbing:
					velocity.y = CLIMB_VELOCITY
					sprite.play("climb")
				else:
					if direction > 0:
						sprite.flip_h =true
						position.x += SPEED
					else :
						sprite.flip_h =false
						position.x -= SPEED
					sprite.play("ATTACK")
	move_and_slide()
