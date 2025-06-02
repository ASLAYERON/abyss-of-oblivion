extends CharacterBody2D

const SPEED = 60.0
const CLIMB_VELOCITY = -70.0

@onready var climb_time: Timer = $climb_time
@onready var player: AnimatedSprite2D = $PLAYER
@onready var get_up_timer: Timer = $"get_up timer"

var is_getting_up=false
var is_climbing=false
var was_on_floor=false
var previous_velocity_y=0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		if !was_on_floor and previous_velocity_y>200:
			is_getting_up=true
			get_up_timer.start()
		was_on_floor=true
	else:
		was_on_floor=false
		# Add the gravity.
		velocity += get_gravity() * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction && !is_getting_up:
		velocity.x = direction * SPEED
		if is_on_floor() && is_on_wall():	
			climb_time.start()
			is_climbing=true
			velocity.y = CLIMB_VELOCITY
		elif is_climbing:
			velocity.y = CLIMB_VELOCITY
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	previous_velocity_y=velocity.y
	animation(direction,is_climbing,is_getting_up)
	move_and_slide()


func animation(direction,is_climbing,is_getting_up):
	if !is_getting_up:
		if direction:
			if direction<0:
				if is_climbing:
					player.play("climbLEFT")
				else:
					player.play("LEFT")
			elif direction >0:
				if is_climbing:
					player.play("climbRIGHT")
				else:
					player.play("RIGHT")
		else:
			player.play("IDLE")
	elif is_getting_up:
		player.play("GET_UP")



func _on_climb_time_timeout() -> void:
	is_climbing=false


func _on_get_up_timer_timeout() -> void:
	is_getting_up=false
