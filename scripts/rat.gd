extends CharacterBody2D
var player = null
var SPEED = 1.5
var player_is_here :bool = false
var state :String = "sleeping"
var attack_availalbe :bool = true
var direction=0
var CLIMB_VELOCITY: float = -30.0
var is_climbing :bool=false
var attack_animation:String="attack"
const rat_attack = preload("res://scenes/rat_attack.tscn")
@onready var sprite: AnimatedSprite2D = $sprite
@onready var attack_timer: Timer = $attack_timer
@onready var climb_time: Timer = $climb_time

var path_scene:String = "" #pour se retrouver dans le dict dans Global
var path_name:String = ""
var start_position: Vector2 = Vector2(0,0)

func _ready() -> void:
	position=start_position

func _physics_process(delta: float) -> void:
	if Global.state == "playing":
		if state=="sleeping":
			if !is_on_floor() && !is_climbing:
				velocity += get_gravity() * delta
			sprite.play("SLEEP")
			if player_is_here:
				if player.noise>30:
					state = "attack"
					set_collision_layer_value(1,true)
		elif state == "attack" and Global.state == "playing":
			if !is_on_floor() && !is_climbing:
				velocity += get_gravity() * delta
			else:
				#CLIMB SYSTEM
				if is_on_wall() && !is_climbing:
					attack_animation="climb"
					climb_time.start()
					is_climbing=true
					velocity.y = CLIMB_VELOCITY
				elif is_climbing:
					velocity.y = CLIMB_VELOCITY
			
			if player!=null:
				direction=player.position.x-position.x	
				#HANDLE FLIP
				if direction < 0:
					sprite.flip_h =false
				else :
					sprite.flip_h =true
				#ATTACK SYSTEM
				if direction>=0:
					position.x += SPEED
					attack(direction)
				else:
					position.x -= SPEED
					attack(direction)	
			sprite.play(attack_animation)
			
		move_and_slide()

func _on_hear_zone_body_entered(body: Node2D) -> void:
	if body.name=="player":
		player_is_here=true
		player=body
	
func attack(direction):
	if attack_availalbe:
		attack_availalbe=false
		attack_timer.start()
		var new_attack=rat_attack.instantiate()
		if direction >=0:
			new_attack.direction=direction
		else:
			new_attack.direction=direction>=0
		add_child(new_attack)


func _on_attack_timer_timeout() -> void:
	attack_availalbe=true
	
func _on_climb_time_timeout() -> void:
	is_climbing=false
	attack_animation="attack"


func _on_forget_zone_body_exited(body: Node2D) -> void:
	if body.name=="player":
		player_is_here=false
		player=null
		state=="sleeping"
		set_collision_layer_value(1,false)
