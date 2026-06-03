extends Node2D
#@onready var player: CharacterBody2D = $player
@onready var player: CharacterBody2D = $player

var new_enemy=null
func _ready() -> void:
	player.visible=true
	Global.have_shield = true
