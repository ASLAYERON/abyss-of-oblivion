extends Node2D
@onready var geld_kampfer_animation: AnimatedSprite2D = $"Geld Kampfer animation"
@export var SPEED = 4
const GELD_KAMPFER = preload("res://dialogues/GELD_KAMPFER.dialogue")

var dialogues = ["first_encounter","already_met","have_shield","training1",null,"training1_done","sending_you"]
var is_a_player_here = false
var player = null
var initial_position_x = null
var initial_position_y = null
var can_move = false
var stunned = false
	
func _ready() -> void:
	initial_position_x = position.x
	initial_position_y = position.y


func _process(delta: float) -> void:
	if Global.state == "talking":
		geld_kampfer_animation.play("TALKING")
	else :
		if Global.Geld_Kampfer_progression == 4:
			if can_move:
				if stunned:
					Global.Geld_Kampfer_progression = 5
					stunned = false
					can_move = false
					position.x = initial_position_x
					position.y = initial_position_y
				elif position.x <= initial_position_x-99:
					Global.Geld_Kampfer_progression = 0
					can_move = false
					position.x = initial_position_x
					position.y = initial_position_y
					Global.Geld_Kampfer_progression = 3
				position = position.lerp(Vector2(initial_position_x - 100,initial_position_y),SPEED * delta)
				geld_kampfer_animation.play("ATTACK_2")
			else:
				geld_kampfer_animation.play("ATTACK")
		else:
			geld_kampfer_animation.play("IDLE")
			if is_a_player_here:
				if Input.is_action_just_pressed("interact"):
					Global.state="talking"
					is_a_player_here=false
					player.show_text("KILL")
					DialogueManager.show_dialogue_balloon(GELD_KAMPFER,dialogues[Global.Geld_Kampfer_progression])
	
func stun():
	stunned = true	
			

func _on_dialoguearea_body_entered(body: Node2D) -> void:
	if body.name=="player":
		is_a_player_here=true
		player=body
		player.show_text("E POUR PARLER")

func _on_dialoguearea_body_exited(body: Node2D) -> void:
	if body.name=="player":
		is_a_player_here=false
		player=body
		player.show_text("KILL")
		
func _on_geld_kampfer_animation_animation_looped() -> void:
	if geld_kampfer_animation.animation == "ATTACK":
		can_move = true

func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.name == "player" && can_move:
		body.damage(0,-1,self)
