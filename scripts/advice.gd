extends Node2D
@onready var dialogue_area: Area2D = $dialogue_area
var is_a_player_here=false
var player=null
const ADVICE = preload("res://dialogues/advices.dialogue")

@export var advice_dialogue = ""

func _on_dialogue_area_body_entered(body: Node2D) -> void:
	if body.name=="player":
		is_a_player_here=true
		player=body
		player.show_text("E POUR LIRE")

func _on_dialogue_area_body_exited(body: Node2D) -> void:
	if body.name=="player":
		is_a_player_here=false
		player=body
		player.show_text("KILL")

func _process(delta: float) -> void:
	if is_a_player_here:
		if Input.is_action_just_pressed("interact"):
			Global.state="talking"
			is_a_player_here=false
			player.show_text("KILL")
			DialogueManager.show_dialogue_balloon(ADVICE,advice_dialogue)
