extends Node2D
@onready var geld_kampfer_animation: AnimatedSprite2D = $"Geld Kampfer animation"
const GELD_KAMPFER = preload("res://dialogues/GELD_KAMPFER.dialogue")

var dialogues=["start","train"]
var is_a_player_here=false
var player=null
	
func _process(delta: float) -> void:
	if Global.state == "talking":
		geld_kampfer_animation.play("TALKING")
	else :
		geld_kampfer_animation.play("IDLE")
		if is_a_player_here:
			if Input.is_action_just_pressed("interact"):
				Global.state="talking"
				is_a_player_here=false
				player.show_text("KILL")
				DialogueManager.show_dialogue_balloon(GELD_KAMPFER,dialogues[Global.Geld_Kampfer_progression])
			

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
		
