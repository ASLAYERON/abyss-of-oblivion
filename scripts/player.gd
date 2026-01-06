extends CharacterBody2D
# #############################################

	#import des noeuds
@onready var climb_time: Timer = $timers/climb_time
@onready var player: AnimatedSprite2D = $PLAYER
@onready var get_up_timer: Timer = $"timers/get_up timer"
@onready var UI: Control = $UI
@onready var iframe_timer: Timer = $timers/iframe_timer
@onready var freeze_timer: Timer = $timers/freeze_timer
@onready var camera: Camera2D = $Camera
@onready var footstep: AudioStreamPlayer = $sounds/footstep
@onready var hit_hurt: AudioStreamPlayer = $sounds/hitHurt
# #############################################

	#init des var
	
#string
var actual_action: String = "IDLE"
#float
var SPEED: float = 30.0
var CLIMB_VELOCITY: float = -60.0
var noise: float = 0.0
var previous_velocity_y: float = 0.0
#int
var max_stamina: int = 100
var stamina: int = max_stamina
var max_health: int = 30
var health_points: int = max_health
var run_factor: int = 1
var old_direction=0 #permet de voir si l'on passe de marcha a je marche plus
var hit_direction=0 #permet de savoir dans quel sens faire l'animation de hit
var knockback = 400
#booleen
var is_running: bool = false
var noise_sensor: bool = true
var is_making_noise: bool = false
var debug_mode: bool = false
var is_getting_up: bool = false
var is_wall_climbing: bool = false
var is_straight_climbing: bool = false
var was_on_floor: bool = false
var is_transitioning: bool = false
var is_iframes: bool = false
var using_stamina: bool = false
# ##################################

#func animation
func animation(actual_action):
	player.play(actual_action)

#damage
func damage(hp,direction):
	if !is_iframes:
		camera.camera_shake()
		hit_hurt.play()
		hit_direction=int(direction)
		Global.state="freeze"
		is_iframes=true
		iframe_timer.start()
		freeze_timer.start()
		UI.show_freeze_vignette(true)
		if !debug_mode :
			health_points-=hp

#montre un texte (instructions)
func show_text(text):
	if text=="KILL":
		if noise_sensor:
			UI.noise_bar.visible=true
		UI.instruction.visible=false
	else:
		if noise_sensor:
			UI.noise_bar.visible=false
		UI.instruction.text=text
		UI.instruction.visible=true
	
#passe en debug mode (god mode)	
func debugMode():
	if debug_mode:
		debug_mode=false
		SPEED = 30.0
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
		UI.noise_bar.value=noise
		is_making_noise= false

#permet au joueur de grimper sur les echelles
func climb_straight():
			#grimpette
		is_straight_climbing = false
		if (Global.can_go_up || debug_mode):
			if Input.is_action_pressed("up"):
				is_straight_climbing = true
				velocity.y= CLIMB_VELOCITY	
				if noise_sensor : #fait du bruit si tu marche
					is_making_noise=true
			elif Input.is_action_pressed("down"):
				is_straight_climbing = true
				velocity.y= -CLIMB_VELOCITY
				if noise_sensor : #fait du bruit si tu marche
					is_making_noise=true
			else:
				velocity.y=0

#regarde si le player est mort
func check_life():
	if health_points<1 and Global.state != "freeze":
		get_tree().change_scene_to_file("res://scenes/start.tscn")
	UI.upd_health(health_points,max_health)

func refill_health_points():
	health_points=max_health
	
func handle_stamina():
	if stamina <= 0:
		stamina = 0
	if stamina < max_stamina && !using_stamina:
		stamina +=1
	UI.upd_stamina(stamina,max_stamina)

#gere la gravitée et les chutes
func handle_gravity(delta):
	if is_on_floor():
		if !was_on_floor:
			#anim et gros bruit si grosse chutte
			if previous_velocity_y>200:
				if noise_sensor:
					noise += 10 + previous_velocity_y/7
					is_making_noise= true
				is_getting_up=true
				#la grosse chute a un cooldown
				get_up_timer.start()
			else: #petit bruit si petite chute
				if noise_sensor:
					noise += 10
					is_making_noise= true	
		was_on_floor=true
	else: #fait tomber le joueur
		was_on_floor=false
		# Add the gravity.
		velocity += get_gravity() * delta * 1/run_factor

#anime le joueur
func animate_player(direction):
	if Global.state == "playing":
		## DEBUG
		if debug_mode: actual_action="DEBUG"
		## GETTING UP	
		elif Global.can_go_up:
			if is_straight_climbing: actual_action = "STRAIGHT_CLIMB"
			else: actual_action = "CLIMB_STATIC"
		elif is_getting_up: actual_action = "GET_UP"
		## WALK CLIMB TRANSITION
		elif direction:
			if old_direction == -direction: is_transitioning = true
			if direction>0:
				if is_transitioning: actual_action = "transitionRIGHT"
				else:
					if is_wall_climbing: actual_action = "climbRIGHT"	
					else: actual_action = "RIGHT"
			else:
				if is_transitioning: actual_action = "transitionLEFT"
				else:
					if is_wall_climbing: actual_action = "climbLEFT"
					else: actual_action = "LEFT"
			old_direction=direction
		else: #tu ne fait rien
			if !is_getting_up && !debug_mode:
				if old_direction:
					if old_direction > 0: actual_action = "IDLE_RIGHT"
					else: actual_action = "IDLE_LEFT"
				else: actual_action = "IDLE"
	elif Global.state == "rest":
		actual_action = "REST"
	elif Global.state == "talking":
		actual_action = "IDLE"
	elif Global.state == "freeze":
		if hit_direction: actual_action = "HIT_LEFT"
		else : actual_action = "HIT_RIGHT"
		
		
func walk_and_wall_climb(direction,delta):
			# marcher/grimper aux murs droite/gauche
	if direction && !is_getting_up:
		if abs(velocity.x) >= SPEED:
			velocity.x = direction * SPEED  * (delta*62.5) * run_factor
			#footstep.play()
		else:
			velocity.x += direction * SPEED * (delta*10) * run_factor
		if noise_sensor : #fait du bruit si tu marche
			noise+=0.1
			is_making_noise= true
		if is_on_floor() && is_on_wall() && !is_wall_climbing:	
			climb_time.start()
			is_wall_climbing=true
			velocity.y = CLIMB_VELOCITY * (delta*62.5)  * run_factor
		elif is_wall_climbing:
			velocity.y = CLIMB_VELOCITY * (delta*62.5)
	else: #tu ne fait rien
		velocity.x = move_toward(velocity.x, 0, SPEED)
	previous_velocity_y=velocity.y

func run():
	if Input.is_action_pressed("run"):
		if stamina > 0:
			run_factor = 3	
			stamina -= 2
			using_stamina = true
		else:
			run_factor = 1
			using_stamina = true
	else:
		run_factor = 1

func add_coin(coin_value):
	Global.coins+=coin_value
	UI.change_coin_value(Global.coins)		

# save
func save_game() -> void:
	saveSystem._save(position,player.get_tree().current_scene.scene_file_path,Global.Altstein_progression,Global.coins)
	UI.rest_menu.visible=false
	Global.state="playing"

# load
func load_game() -> void:
	var save_data=saveSystem._load()
	get_tree().change_scene_to_file(save_data.scene_file_path)
	Global.tp_offset=save_data.player_position
	Global.Altstein_progression=save_data.Altstein_progression
	Global.coins=save_data.Global.coins
	UI.rest_menu.visible=false
	Global.state="playing"

## #######  FONCTIONS EVENT

#timer du grimpage aux murs
func _on_climb_time_timeout() -> void:
	is_wall_climbing=false

#timer grosse chute
func _on_get_up_timer_timeout() -> void:
	is_getting_up=false
	actual_action="IDLE"

# ###################################
	#init du player

func _on_player_animation_finished() -> void:
	if is_transitioning:
		is_transitioning=false


func _on_iframe_timer_timeout() -> void:
	is_iframes = false
	UI.show_iframes_vignette(false)
	
func _on_freeze_timer_timeout() -> void:
	Global.state="playing"
	UI.show_freeze_vignette(false)
	UI.show_iframes_vignette(true)
	if hit_direction : velocity.x+= knockback
	else : velocity.x -= knockback

# ##################################

#INITIALISATION
func _ready():
	UI.change_coin_value(Global.coins)
	UI.rest_menu.visible = false
# ##################################

func _physics_process(delta: float) -> void:
# ###########################PLAYING
	var direction := Input.get_axis("left", "right")
	#mode playing (le perso bouge)	
	if Global.state=="playing":
		check_life()
		#declenche mode debug
		if Input.is_action_just_pressed("debug"):
			debugMode()

		handle_gravity(delta)
		
		climb_straight()
		
		using_stamina = false
		run()
		handle_stamina()
		
		walk_and_wall_climb(direction,delta)
		#upd du bruit
		handle_noise()
		
		move_and_slide()
		global_position=round(global_position)

	#etat de repos	
	elif Global.state=="rest":
		UI.rest_menu.visible=true
		
	#est hit
	elif Global.state=="freeze":
		pass
	animate_player(direction)	
	animation(actual_action)
