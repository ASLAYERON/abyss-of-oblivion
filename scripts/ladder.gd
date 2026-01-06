extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name=="player":
		Global.can_go_up=true

func _on_body_exited(body: Node2D) -> void:
	if body.name=="player":
		Global.can_go_up=false
