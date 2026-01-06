extends Node2D
@onready var player: CharacterBody2D = $player
@onready var bg: Sprite2D = $Background/Bg

func _ready() -> void:
	player.visible=true
	bg.visible=true
	player.noise_sensor=false
	player.UI.noise_bar.visible=false

func _on_portal_to_arrival_body_entered(body: Node2D) -> void:
	if body.name=="player":
		Global.tp_offset=Vector2(-752.0,-476.0)
		get_tree().change_scene_to_file("res://scenes/arrival.tscn")
