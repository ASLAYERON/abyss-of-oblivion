extends Node2D
#@onready var player: CharacterBody2D = $player
const rat = preload("res://scenes/rat.tscn")
@onready var player: CharacterBody2D = $player

var new_enemy=null
func _ready() -> void:
#	player.visible=true
#	player.noise_sensor=true
#	player.progress_bar.visible=true
	for enemy in Global.enemies["debug_room"]:
		if Global.enemies["debug_room"][enemy][0]=="rat" :
			new_enemy = rat.instantiate()
		new_enemy.path_scene="debug_room"
		new_enemy.path_name=enemy
		new_enemy.start_position=Global.enemies["debug_room"][enemy][1]
		add_child(new_enemy)
