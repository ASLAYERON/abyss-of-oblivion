extends Node2D
@onready var vespillo_animation: AnimatedSprite2D = $"Vespillo animation"

const VESPILLO = preload("res://dialogues/VESPILLO.dialogue")

var dialogues=["start","start"]
var is_a_player_here=false
var player=null
	
func _process(delta: float) -> void:
	vespillo_animation.play("IDLE")
	if is_a_player_here:
		if Input.is_action_just_pressed("interact"):
			Global.state="talking"
			is_a_player_here=false
			player.show_text("KILL")
			DialogueManager.show_dialogue_balloon(VESPILLO,dialogues[Global.Vespillo_progression])
			

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
		
