extends CharacterBody2D

@onready var range_component: Node = null
@onready var attack_cast_component: Node = null
@onready var retreat_component: Node = null
@onready var move_component: Node = null
@onready var attack_choose_component: Node = null
@onready var idle_component: Node = null
@onready var damage_component: Node = null

@onready var sprite: AnimatedSprite2D = $sprite

@export var hp = 1

var is_attacking: bool = false
var is_player_here: bool = false
var attack_available: bool = false

var actual_action = ""
var attack = null
var player = null
var direction = 0
#FUNC
func damage(hp,direction,caster):
	damage_component.damage(hp,direction,caster)
func custom_behavior():
	pass

#EVENTS
func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.name == "player":
		is_player_here = true
		player = body


func _on_forget_zone_body_exited(body: Node2D) -> void:
	if body.name == "player" && is_player_here:
		is_player_here = false
		player = null


#MAIN LOOP
func _ready() -> void:
	assert(range_component,"need range_component")
	assert(attack_cast_component,"need attack_cast_component")
	assert(retreat_component,"need retreat_component")
	assert(move_component,"need move_component")
	assert(attack_choose_component,"attack_choose_component")
	assert(idle_component,"idle_component")
	assert(damage_component,"damage_component")
	
func _physics_process(delta: float) -> void:
	if Global.state == "playing":
		custom_behavior()
		sprite.play(actual_action)
		if is_attacking:
			#
			if range_component.player_in_range(self,player,attack):
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
				if attack_choose_component.attack_or_not(self,attack,player):
					is_attacking = true
				else:
					idle_component.idle(self)
			else:
				idle_component.idle(self)
