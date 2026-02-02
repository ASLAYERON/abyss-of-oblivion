extends Control
@onready var fade_transition: CanvasModulate = $fade_transition
@onready var logo: Sprite2D = $logo
@onready var ui: MarginContainer = $UI
@onready var logo_fade_out_timer: Timer = $logo_fade_out_timer
var logo_appeared = false

func _ready():
	$UI/VBoxContainer/START.grab_focus.call_deferred()
	fade_transition.visible = true
	ui.visible = false
	#fade_transition.fade = 1
	fade_transition.fade_in()
	logo.visible=true
	
func _process(delta: float) -> void:
	if !logo_appeared:
		if logo.scale.x < 1.5:
			logo.scale = logo.scale.slerp(Vector2(1.6,1.6),delta)
		else:
			fade_transition.fade_out()
			logo_fade_out_timer.start()
			logo_appeared = true
		


func _on_texture_button_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/beginning_cutscene.tscn")

func _on_texture_button_2_pressed() -> void:
	saveSystem._load()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/beginning_cutscene.tscn")

func _on_load_pressed() -> void:
	saveSystem._load()

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit() 





func _on_logo_fade_out_timer_timeout() -> void:
	logo.visible = false
	fade_transition.fade_in()
	ui.visible = true
