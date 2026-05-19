extends Node
@export var CLIMB_VELOCITY = 0
@export var SPEED = 0

func move_towards_player(parent,player):
	parent.direction = player.position.x - parent.position.x
	if parent.is_on_floor() && parent.is_on_wall() && !parent.is_climbing:
		parent.climb_time.start()
		parent.is_climbing=true
		parent.velocity.y = CLIMB_VELOCITY
		parent.actual_action = "climb"
	else:
		if parent.is_climbing:
			parent.velocity.y = CLIMB_VELOCITY
			parent.actual_action = "climb"
		else:
			if parent.direction > 0:
				#sprite.flip_h =true
				parent.position.x += SPEED
			else :
				#sprite.flip_h =false
				parent.position.x -= SPEED
