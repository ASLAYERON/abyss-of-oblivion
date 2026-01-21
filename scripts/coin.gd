extends Node2D
@onready var coin_sprite: AnimatedSprite2D = $coin_body/coin_sprite
@onready var coin_body: RigidBody2D = $coin_body
@onready var timer: Timer = $coin_body/Timer
@onready var depop_timer: Timer = $depop_timer
var sound_player = preload("res://scenes/sound_2d.tscn")

var rng = RandomNumberGenerator.new()
var can_be_picked_up = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_body.apply_impulse(Vector2(rng.randf_range(-100.0, 100.0),-300))
	timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	coin_sprite.play("default")

func _on_add_coin_area_body_entered(body: Node2D) -> void:
	if body.name=="player" and can_be_picked_up:
		body.add_coin(1)
		var sound = sound_player.instantiate()
		sound.stream=preload("res://assets/sounds/common/coin_clinging.mp3")
		get_parent().add_child(sound)
		queue_free()


func _on_timer_timeout() -> void:
	can_be_picked_up=true


func _on_depop_timer_timeout() -> void:
	queue_free()
