extends Area2D
@export var checkpoint_name: String = ""
var is_a_player_here=false	
var player = null
	
func _process(delta: float) -> void:
	if is_a_player_here:
		if Input.is_action_just_pressed("interact"):
			print(player.position)
			Global.state="rest"
			player.UI.upper_bar.visible = false
			player.UI.rest_menu.visible = true
			player.camera.offset = Vector2(-20,0)
			player.refill_health_points()
			Global.reset_enemies()
			Global.save_game(checkpoint_name)
			player.position = Global.checkpoints[checkpoint_name][0]
			is_a_player_here=false
			player.show_text("KILL")


func _on_body_entered(body: Node2D) -> void:
	if body.name=="player":
		is_a_player_here=true
		player=body
		player.show_text("E POUR SE REPOSER")


func _on_body_exited(body: Node2D) -> void:
	if body.name=="player":
		is_a_player_here=false
		body.show_text("KILL")
