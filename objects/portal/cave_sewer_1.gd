extends Node2D

@onready var portal: Area2D = $portal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.dev_mode:
		portal.scene_a = "res://scenes/sewer_part_1.tscn"
