extends Area2D

@onready var instruction: Label = $instruction

var is_a_player_here=false	

func _ready() -> void:
	instruction.visible=false
	
func _process(delta: float) -> void:
	if is_a_player_here:
		if Input.is_action_just_pressed("interact"):
			Global.state="rest"
			instruction.visible=false
			is_a_player_here=false		


func _on_body_entered(body: Node2D) -> void:
	if body.name=="player":
		is_a_player_here=true
		instruction.visible=true


func _on_body_exited(body: Node2D) -> void:
	if body.name=="player":
		is_a_player_here=false
		instruction.visible=false
