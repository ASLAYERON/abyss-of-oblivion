extends Node
@export var CLIMB_VELOCITY = 0.0
@export var SPEED = 0.0

func move_towards_player(parent,player):
	parent.direction = player.position.x - parent.position.x > 0
	if parent.is_on_floor() && parent.is_on_wall() && !parent.is_climbing:
		parent.climb_time.start()
		parent.is_climbing=true
		parent.velocity.y = CLIMB_VELOCITY
		parent.sprite.play("climb")
	else:
		if parent.is_climbing:
			parent.velocity.y = CLIMB_VELOCITY
			parent.sprite.play("climb")
		else:
			if parent.direction:
				parent.position.x += SPEED
			else :
				parent.position.x -= SPEED
			parent.sprite.play("move")
