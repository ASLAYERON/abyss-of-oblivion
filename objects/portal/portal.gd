extends Area2D
@onready var void_sprite: AnimatedSprite2D = $void_sprite
@onready var cool_down: Timer = $cool_down
@export var scene_a = ""
@export var scene_b = ""
@export var tp_a = Vector2(0,0)
@export var tp_b = Vector2(0,0)

var can_tp = false

func _ready() -> void:
	cool_down.start()

func _process(delta: float) -> void:
	void_sprite.play()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" && can_tp:
		print(scene_a," ",scene_b," ",get_tree().current_scene.scene_file_path)
		if scene_a == String(get_tree().current_scene.scene_file_path):
			Global.tp_offset = tp_b
			get_tree().change_scene_to_file(scene_b)
		else:
			Global.tp_offset = tp_a
			get_tree().change_scene_to_file(scene_a)


func _on_cool_down_timeout() -> void:
	can_tp = true
