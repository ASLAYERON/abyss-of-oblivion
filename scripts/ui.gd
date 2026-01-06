extends Control
@onready var rest_menu: Control = $"rest menu"
@onready var instruction: Label = $instruction
@onready var coin_counter: Label = $upper_bar/coin_counter
@onready var freeze_vignette: Sprite2D = $freeze_vignette
@onready var iframes_vignette: Sprite2D = $iframes_vignette
@onready var stamina_bar: TextureProgressBar = $upper_bar/VBoxContainer/stamina_bar
@onready var health_bar: TextureProgressBar = $upper_bar/VBoxContainer/health_bar
@onready var noise_bar: TextureProgressBar = $upper_bar/noise_bar

#updt health and stamina
func upd_health(health,max_health):
	health_bar.value = (float(health) / float(max_health)) * 100.0
	
func upd_stamina(stamina,max_stamina):
	stamina_bar.value = (float(stamina) / float(max_stamina)) * 100.0

#updt piece
func change_coin_value(coin_value):
	coin_counter.text=str(coin_value)
#bouton save
func _on_save_button_pressed() -> void:
	get_parent().save_game()

#bouton load
func _on_load_button_pressed() -> void:
	get_parent().load_game()
	
func show_freeze_vignette(Bool):
	freeze_vignette.visible = Bool
	
func show_iframes_vignette(Bool):
	iframes_vignette.visible = Bool
