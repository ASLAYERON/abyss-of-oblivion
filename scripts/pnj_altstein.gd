extends Node2D
@onready var instruction: Label = $instruction
@onready var altstein_animation: AnimatedSprite2D = $"Altstein animation"
const ALTSTEIN_1 = preload("res://dialogues/ALTSTEIN1.dialogue")

var is_a_player_here=false

func _ready():
	instruction.visible=false
	
func _process(delta: float) -> void:
	altstein_animation.play("IDLE")
	if is_a_player_here:
		if Input.is_action_just_pressed("interact"):
			Global.state="talking"
			is_a_player_here=false
			instruction.visible=false
			DialogueManager.show_dialogue_balloon(ALTSTEIN_1,"start")
			

func _on_dialoguearea_body_entered(body: Node2D) -> void:
	if body.name=="player":
		is_a_player_here=true
		instruction.visible=true

func _on_dialoguearea_body_exited(body: Node2D) -> void:
	if body.name=="player":
		is_a_player_here=false
		instruction.visible=false
		
