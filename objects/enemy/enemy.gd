extends CharacterBody2D
class_name Enemy
@onready var range_component: Node = null
@onready var attack_cast_component: Node = null
@onready var retreat_component: Node = null
@onready var move_component: Node = null
@onready var attack_choose_component: Node = null
@onready var idle_component: Node = null
@onready var attack_timer: Timer = $attack_timer
@onready var sprite: AnimatedSprite2D = $sprite
@onready var i_frames: Timer = $i_frames
@onready var hit: AudioStreamPlayer2D = $hit
@onready var critical: AnimatedSprite2D = $critical

@export var hp = 1

var is_attacking: bool = false
var is_player_here: bool = false
var attack_available: bool = true
var is_stunned: bool = false
var knockback: float = 0

var actual_action = ""
var attack = null
var player = null
var direction = 0
#FUNC
#func damage(hp,direction,caster):
#	damage_component.damage(hp,direction,caster)
func damage(dp,hit_direction,caster):
	is_attacking = true
	if Global.state != "playing":
		return
	if is_stunned:
		critical.visible = true
		Global.state = "cutscene"
		caster.visible = false
		sprite.visible = false
		critical.play("crit")
		await critical.animation_finished
		critical.visible = false
		caster.visible = true
		sprite.visible = true
		Global.state = "playing"
		dp = dp * 3 + int(hp/7)
	direction = !hit_direction
	if hit_direction : velocity.x += knockback
	else : velocity.x -= knockback
	if i_frames.time_left == 0:
		if dp < hp:
			hp -= dp
			hit.play()
			modulate = Color.RED
			Global.freeze_mode = "enemy_hit"
			Global.state = "freeze"
		else:
			hp = 0
			sprite.play("die")
		i_frames.start()
func custom_behavior(delta):
	pass
func stun():
	is_stunned = true
	sprite.play("stunned")
#EVENTS
func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.name == "player":
		is_player_here = true
		player = body
func _on_forget_zone_body_exited(body: Node2D) -> void:
	if body.name == "player" && is_player_here:
		is_player_here = false
		player = null
func _on_sprite_animation_finished() -> void:
	if sprite.animation == "stunned":
		is_stunned = false
	elif sprite.animation == "die":
		queue_free()
func _on_attack_timer_timeout() -> void:
	attack_available = true
func _on_i_frames_timeout() -> void:
	modulate = Color.WHITE
	Global.state = "playing"

#MAIN LOOP
func _ready() -> void:
	assert(range_component,"need range_component")
	assert(attack_cast_component,"need attack_cast_component")
	assert(retreat_component,"need retreat_component")
	assert(move_component,"need move_component")
	assert(attack_choose_component,"attack_choose_component")
	assert(idle_component,"idle_component")
	
func _physics_process(delta: float) -> void:
	if Global.state == "playing":
		if hp > 0 && !is_stunned:
			custom_behavior(delta)
			if is_attacking && player:
				#
				if range_component.player_in_range(self,player):
					#
					if attack_available:
						attack_cast_component.send_attack(self,attack)
					else:
						retreat_component.retreat(self,)
				else:
					move_component.move_towards_player(self,player)
			else:
				if is_player_here:
					#
					if attack_choose_component.attack_or_not(self,player):
						is_attacking = true
					else:
						idle_component.idle(self)
				else:
					idle_component.idle(self)
			move_and_slide()
