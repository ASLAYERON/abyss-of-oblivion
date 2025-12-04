extends Control
@onready var rest_menu: Control = $"rest menu"
@onready var instruction: Label = $instruction
@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var coin_counter: Label = $upper_bar/coin_counter

#updt piece
func change_coin_value(coin_value):
	coin_counter.text=str(coin_value)
#bouton save
func _on_save_button_pressed() -> void:
	get_parent().save_game()

#bouton load
func _on_load_button_pressed() -> void:
	get_parent().load_game()
