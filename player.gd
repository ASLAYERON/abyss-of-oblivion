extends CharacterBody2D

const SPEED = 60.0
const CLIMB_VELOCITY = -70.0
@onready var climb_time: Timer = $climb_time
var is_climbing=false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor() && is_on_wall():	
			climb_time.start()
			is_climbing=true
			velocity.y = CLIMB_VELOCITY
		elif is_climbing:
			velocity.y = CLIMB_VELOCITY
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_climb_time_timeout() -> void:
	is_climbing=false
