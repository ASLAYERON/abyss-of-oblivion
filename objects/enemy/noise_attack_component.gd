extends Node
func attack_or_not(parent,player):
	if parent.is_player_here:
		if player.noise > 30:
			parent.warning.play("almost_attacking")
		if player.noise > 50:
			parent.is_attacking = true
		else:
			parent.warning.frame = 0
	
