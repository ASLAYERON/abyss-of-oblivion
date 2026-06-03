
extends Node
func player_in_range(parent,player):
	if abs(player.position.x - parent.position.x) <= parent.range:
		return true
	return false
