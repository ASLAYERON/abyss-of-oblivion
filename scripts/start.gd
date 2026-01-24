extends Control
@onready var stroke1: AnimatedSprite2D = $stroke1/stroke1
@onready var stroke2: AnimatedSprite2D = $stroke2/stroke2

var stroke1_entered=false
var stroke1_animation="empty"
var stroke2_entered=false
var stroke2_animation="empty"

func _process(delta: float) -> void:
	stroke1.play(stroke1_animation)
	stroke2.play(stroke2_animation)
	
func _on_bande_mouse_entered() -> void:
	stroke1_entered=true
	stroke1_animation="coming"
	
func _on_bande_mouse_exited() -> void:
	stroke1_entered=false
	stroke1_animation="going_away"

func _on_stroke_2_mouse_entered() -> void:
	stroke2_entered=true
	stroke2_animation="coming"
	
func _on_stroke_2_mouse_exited() -> void:
	stroke2_entered=false
	stroke2_animation="going_away"

func _on_stroke_1_animation_finished() -> void:
	if stroke1_entered:
		stroke1_animation="filled"
	else:
		stroke1_animation="empty"

func _on_stroke_2_animation_finished() -> void:
	if stroke2_entered:
		stroke2_animation="filled"
	else:
		stroke2_animation="empty"


func _on_texture_button_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/beginning_cutscene.tscn")

func _on_texture_button_2_pressed() -> void:
	saveSystem._load()
