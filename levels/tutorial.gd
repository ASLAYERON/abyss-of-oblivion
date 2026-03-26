extends Node2D
@onready var player: CharacterBody2D = $player
@onready var bg: Sprite2D = $Background/Bg

func _ready() -> void:
	player.visible=true
	bg.visible=true
	player.noise_sensor=false
	player.UI.noise_bar.visible=false
