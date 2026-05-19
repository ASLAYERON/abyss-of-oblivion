extends Node2D
@onready var player: CharacterBody2D = $player
@onready var bg: Sprite2D = $Background/Bg
#@onready var ambiance: AudioStreamPlayer = $Ambiance/Ambiance
@onready var shield_update: Area2D = $shield_update
@onready var chests: Node = $CHESTS
@onready var music: AudioStreamPlayer = $music

var new_enemy=null

func _ready() -> void:
	player.visible=true
	bg.visible=true
	player.noise_sensor=true
	player.UI.noise_bar.visible=true
	player.position=Global.tp_offset
	
	var chest_indice = 0
	for chest in chests.get_children():
		chest.level = "caves"
		chest.indice = chest_indice
		chest.is_opened = Global.chest["caves"][chest_indice]
		chest_indice += 1

#func _on_ambiance_finished() -> void:
#	ambiance.play()

func _on_music_finished() -> void:
	music.play()
