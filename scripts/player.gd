extends CharacterBody2D

var save_path="user://variable.save"

const SPEED = 60.0
const CLIMB_VELOCITY = -70.0

@onready var climb_time: Timer = $climb_time
@onready var player: AnimatedSprite2D = $PLAYER
@onready var get_up_timer: Timer = $"get_up timer"
@onready var rest_menu: Control = $"rest menu"



var is_getting_up=false
var is_climbing=false
var was_on_floor=false
var previous_velocity_y=0

func _ready():
	rest_menu.visible=false

func _physics_process(delta: float) -> void:
	if Global.state=="playing":
		if is_on_floor():
			if !was_on_floor and previous_velocity_y>200:
				is_getting_up=true
				get_up_timer.start()
			was_on_floor=true
		else:
			was_on_floor=false
			# Add the gravity.
			if !Global.can_go_up:
				velocity += get_gravity() * delta
		if Global.can_go_up and Input.is_action_just_pressed("up"):
			velocity.y= CLIMB_VELOCITY	
		if Global.can_go_up and Input.is_action_just_pressed("down"):
			velocity.y= -CLIMB_VELOCITY	
			
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
	elif Global.state=="rest":
		rest_menu.visible=true


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



func _on_save_button_pressed() -> void:
	save()
	rest_menu.visible=false
	Global.state="playing"

func _on_load_button_pressed() -> void:
	load_data()
	rest_menu.visible=false
	Global.state="playing"

	
func save():
	var file= FileAccess.open(save_path,FileAccess.WRITE)
	file.store_var(global_position.x)
	file.store_var(global_position.y)
	
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file= FileAccess.open(save_path,FileAccess.READ)
		global_position.x=file.get_var(global_position.x)
		global_position.y=file.get_var(global_position.y)
	else:
		print("no existing save")
		
