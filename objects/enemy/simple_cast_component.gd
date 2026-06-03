extends Node
@export var frame = 3
func send_attack(parent,attack):
	parent.direction = parent.player.position.x - parent.position.x > 0
	#
	if parent.attack_available:
		parent.sprite.play("attack")
		if parent.sprite.frame == frame:
			parent.attack_available=false
			parent.attack_timer.start()
			var new_attack=parent.attack.instantiate()
			if parent.direction:
				new_attack.direction = true
			else:
				new_attack.direction = false
			new_attack.caster = parent
			parent.add_child(new_attack)
	else:
		parent.sprite.frame = 1
		parent.sprite.stop()
