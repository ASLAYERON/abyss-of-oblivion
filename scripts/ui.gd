extends Control
@onready var rest_menu: Control = $"rest menu"
@onready var instruction: Label = $instruction
@onready var coin_counter: Label = $upper_bar/coin_counter
## VIGNETTE
@onready var damage_vignette: Sprite2D = $damage_vignette
@onready var iframes_vignette: Sprite2D = $iframes_vignette
@onready var shield_hit_vignette: Sprite2D = $shield_hit_vignette
@onready var parry_vignette: Sprite2D = $parry_vignette
@onready var hit_animation: AnimatedSprite2D = $hit_animation


@onready var upper_bar: HBoxContainer = $upper_bar
@onready var health_bar: TextureProgressBar = $upper_bar/VBoxContainer/health_bar
@onready var stamina_bar: TextureProgressBar = $upper_bar/VBoxContainer/stamina_bar
@onready var noise_bar: TextureProgressBar = $upper_bar/noise_bar

#updt health and stamina
func upd_health(health,max_health):
	health_bar.value = (float(health) / float(max_health)) * 100.0
	
func upd_stamina(stamina,max_stamina):
	stamina_bar.value = (float(stamina) / float(max_stamina)) * 100.0

#updt piece
func change_coin_value(coin_value):
	coin_counter.text=str(coin_value)
#bouton quit
func _on_quit_button_pressed() -> void:
	rest_menu.visible = false
	upper_bar.visible = true
	get_parent().get_parent().camera.offset = Vector2(0,0)
	Global.state = "playing"

#bouton load
func _on_load_button_pressed() -> void:
	pass
	#get_parent().load_game()
	
func show_damage_vignette(Bool):
	damage_vignette.visible = Bool
	hit_animation.play("hit")
	
func show_iframes_vignette(Bool):
	if Bool: iframes_vignette.modulate.a = 1
	else : iframes_vignette.modulate.a = 0 

func show_shield_hit_vignette(Bool):
	if Bool: iframes_vignette.modulate.a = 1
	else : iframes_vignette.modulate.a = 0 	

func freeze():
	if Global.state == "playing":
		Global.state = "freeze"
		if Global.freeze_mode == "player_hit":
			damage_vignette.visible = true
		elif Global.freeze_mode == "shield_hit":
				var tween = create_tween()
				tween.set_ease(Tween.EASE_OUT)
				tween.set_trans(Tween.TRANS_CUBIC)
				tween.set_parallel(false)
				tween.tween_property(shield_hit_vignette,"modulate:a",1,0.1)
				tween.set_trans(Tween.TRANS_LINEAR)
				tween.tween_property(shield_hit_vignette,"modulate:a",0,0.3)
		elif Global.freeze_mode == "parry":
			parry_vignette.visible = true
		
func unfreeze():
	if Global.freeze_mode == "player_hit":
		damage_vignette.visible = false
		iframes_vignette.modulate.a = 1
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(iframes_vignette,"modulate:a",0,1)
	elif Global.freeze_mode == "shield_hit":
		shield_hit_vignette.modulate.a = 0
	elif Global.freeze_mode == "parry":
		parry_vignette.visible = false
