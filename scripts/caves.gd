extends Node2D
@onready var player: CharacterBody2D = $player
@onready var bg: Sprite2D = $Background/Bg
const rat = preload("res://scenes/rat.tscn")
var new_enemy=null
func _ready() -> void:
	player.visible=true
	bg.visible=true
	player.noise_sensor=true
	player.UI.progress_bar.visible=true
	player.position=Global.tp_offset
	
	
	for enemy in Global.enemies["caves"]:
		if Global.enemies["caves"][enemy][0]=="rat" :
			new_enemy = rat.instantiate()
		new_enemy.path_scene="caves"
		new_enemy.path_name=enemy
		new_enemy.start_position=Global.enemies["caves"][enemy][1]
		add_child(new_enemy)
		print(new_enemy)

func _on_portal_to_arrival_body_entered(body: Node2D) -> void:
	if body.name=="player":
		Global.tp_offset=Vector2(1240,245)
		get_tree().change_scene_to_file("res://scenes/arrival.tscn")
