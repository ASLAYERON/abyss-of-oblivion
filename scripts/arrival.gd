extends Node2D
@onready var player: CharacterBody2D = $player
@onready var bg: Sprite2D = $Background/Bg
@onready var ambiance: AudioStreamPlayer = $ambiance/Ambiance

func _ready() -> void:
	player.visible=true
	bg.visible=true
	player.noise_sensor=false
	player.UI.noise_bar.visible=false
	player.position=Global.tp_offset

func _on_portal_to_caves_body_entered(body: Node2D) -> void:
	if body.name=="player":
		Global.tp_offset=Vector2(851,136)
		get_tree().change_scene_to_file("res://scenes/caves.tscn")

func _on_ambiance_finished() -> void:
	ambiance.play()
