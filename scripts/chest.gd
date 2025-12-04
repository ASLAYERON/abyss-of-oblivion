extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $chest_body/AnimatedSprite2D
@onready var opening_timer: Timer = $opening_timer

@export var coins_content: int = 1

var coin = preload("res://scenes/coin.tscn")
var state = "default"
var timer_playing = false
var is_opened = false
var player = null

func _process(delta: float) -> void:
	if state=="default":
		animated_sprite_2d.play("default")
	elif state=="player_here":
		if timer_playing:
			if Input.is_action_pressed("interact"):
				animated_sprite_2d.play("opening")
			else:
				opening_timer.stop()
				timer_playing=false
				animated_sprite_2d.play("default")
		else :
			if Input.is_action_pressed("interact"):
				opening_timer.start()
				timer_playing=true
				animated_sprite_2d.play("opening")	
			else:
				animated_sprite_2d.play("default")		
	elif state=="opening":
		animated_sprite_2d.play("open")
	elif state=="opened":
		animated_sprite_2d.play("opened")


func _on_opening_timer_timeout() -> void:
	if timer_playing:
		state="opening"
		timer_playing=false
		player.show_text("KILL")

func _on_animated_sprite_2d_animation_finished() -> void:
	state="opened"
	for i in range(coins_content):
		var new_coin=coin.instantiate()
		is_opened=true
		add_child(new_coin)
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player" and !is_opened:
		body.show_text("MAINTENIR E")
		player=body
		state="player_here"

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player" :
		body.show_text("KILL")
		player=null
		if state=="player_here":
			state="default"
