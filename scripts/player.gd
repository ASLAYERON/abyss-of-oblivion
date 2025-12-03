extends CharacterBody2D
# #############################################
	#import des noeuds
@onready var climb_time: Timer = $climb_time
@onready var player: AnimatedSprite2D = $PLAYER
@onready var get_up_timer: Timer = $"get_up timer"
@onready var rest_menu: Control = $"rest menu"
@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var instruction: Label = $instruction
# #############################################

	#init des var
	
#string
var actual_action: String = "IDLE"
#float
var SPEED: float = 60.0
var CLIMB_VELOCITY: float = -80.0
var noise: float = 0
#int
var previous_velocity_y: int = 0
var life_points: int = 3
var old_direction=0 #permet de voir si l'on passe de marcha a je marche plus
var transition_direction=0
#booleen
var noise_sensor: bool = true
var is_making_noise: bool = false
var debug_mode: bool = false
var is_getting_up: bool = false
var is_climbing: bool = false
var was_on_floor: bool = false
var is_transitioning: bool = false
var is_hit: bool = false
# ##################################

#func animation
func animation(actual_action):
	player.play(actual_action)

#damage
func damage(hp,direction):
	if !is_hit:
		is_hit=true
		life_points-=hp
		if direction:
			velocity.x+=30
		else:
			velocity.x-=30

#montre un texte (instructions)
func show_text(text):
	if text=="KILL":
		if noise_sensor:
			progress_bar.visible=true
		instruction.visible=false
	else:
		if noise_sensor:
			progress_bar.visible=false
		instruction.text=text
		instruction.visible=true
	
#passe en debug mode (god mode)	
func debugMode():
	if debug_mode:
		debug_mode=false
		SPEED = 60.0
		CLIMB_VELOCITY = -80.0
	else:
		debug_mode=true
		SPEED = 200.0
		CLIMB_VELOCITY = -120.0

func handle_noise():
	if noise_sensor:
		#borne du bruit et desincrementation si silencieux
		if noise>100: noise=100
		if !is_making_noise:
			if noise >1: noise+=-0.5
			else: noise =0
		progress_bar.value=noise
		is_making_noise= false

#permet au joueur de grimper sur les echelles
func climb_straight():
			#grimpette
		if (Global.can_go_up || debug_mode):
			if Input.is_action_pressed("up"):
				velocity.y= CLIMB_VELOCITY	
			elif Input.is_action_pressed("down"):
				velocity.y= -CLIMB_VELOCITY
			else:
				velocity.y=0

#regarde si le player est mort
func check_if_is_dead():
	if life_points<1 :
		if debug_mode:
			life_points=3
		else:
			get_tree().change_scene_to_file("res://scenes/start.tscn")

#gere la gravitée et les chutes
func handle_gravity(delta):
	if is_on_floor():
		if !was_on_floor:
			#anim et gros bruit si grosse chutte
			if previous_velocity_y>200:
				if noise_sensor:
					noise+=30
					is_making_noise= true
				is_getting_up=true
				#la grosse chute a un cooldown
				get_up_timer.start()
			else: #petit bruit si petite chute
				if noise_sensor:
					noise+=10
					is_making_noise= true	
		was_on_floor=true
	else: #fait tomber le joueur
		was_on_floor=false
		# Add the gravity.
		velocity += get_gravity() * delta

#anime le joueur
func animate_player(direction):
	if debug_mode:
		actual_action="DEBUG"
	elif is_hit:
		actual_action="HIT"
	elif is_getting_up:
		actual_action="GET_UP"
	elif direction:
		if old_direction==0 or old_direction==direction*-1:
			is_transitioning=true
		if direction>0:
			if is_transitioning:
				actual_action="transitionRIGHT"
			else:
				if is_climbing:
					actual_action="climbRIGHT"	
				else:
					actual_action="RIGHT"
		else:
			if is_transitioning:
				actual_action="transitionLEFT"
			else:
				if is_climbing:
					actual_action="climbLEFT"
				else:
					actual_action="LEFT"
	else: #tu ne fait rien
		if !is_getting_up && !debug_mode:
			if old_direction or is_transitioning:
				is_transitioning=true
				if old_direction:
					transition_direction=old_direction
				if transition_direction>0:
					actual_action="transitionRIGHT"
				else:
					actual_action="transitionLEFT"
			else:
				actual_action="IDLE"

	old_direction=direction

func walk_and_wall_climb(direction):
			# marcher/grimper aux murs droite/gauche
		if direction && !is_getting_up:
			velocity.x = direction * SPEED
			if noise_sensor : #fait du bruit si tu marche
				noise+=0.1
				is_making_noise= true
			if is_on_floor() && is_on_wall() && !is_climbing:	
				climb_time.start()
				is_climbing=true
				velocity.y = CLIMB_VELOCITY
			elif is_climbing:
				velocity.y = CLIMB_VELOCITY
		else: #tu ne fait rien
			velocity.x = move_toward(velocity.x, 0, SPEED)
		previous_velocity_y=velocity.y
# ####### FONCTIONS EVENT

#timer du grimpage aux murs
func _on_climb_time_timeout() -> void:
	is_climbing=false

#timer grosse chute
func _on_get_up_timer_timeout() -> void:
	is_getting_up=false
	actual_action="IDLE"

#bouton save
func _on_save_button_pressed() -> void:
	saveSystem._save(position,player.get_tree().current_scene.scene_file_path)
	rest_menu.visible=false
	Global.state="playing"

#bouton load
func _on_load_button_pressed() -> void:
	var save_data=saveSystem._load()
	get_tree().change_scene_to_file(save_data.scene_file_path)
	Global.tp_offset=save_data.player_position
	rest_menu.visible=false
	Global.state="playing"
	
# ###################################
	#init du player

func _on_player_animation_finished() -> void:
	if is_transitioning:
		is_transitioning=false
	if is_hit:
		is_hit=false

# ##################################

#INITIALISATION
func _ready():
	rest_menu.visible = false
# ##################################

func _physics_process(delta: float) -> void:
# ###########################PLAYING
	var direction := Input.get_axis("left", "right")
	#mode playing (le perso bouge)	
	if Global.state=="playing":
		check_if_is_dead()
		
		#declenche mode debug
		if Input.is_action_just_pressed("debug"):
			debugMode()

		handle_gravity(delta)
		climb_straight()	
		
		walk_and_wall_climb(direction)
			
		#upd du bruit
		handle_noise()
		
		move_and_slide()
		global_position=round(global_position)
# #################################REST

	#etat de repos	
	elif Global.state=="rest":
		rest_menu.visible=true
		actual_action="REST"
	animate_player(direction)	
	animation(actual_action)
