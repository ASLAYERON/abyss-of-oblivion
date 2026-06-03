extends Node
func retreat(parent):
	parent.sprite.stop()
	parent.sprite.animation = "attack"
	parent.sprite.frame = 0
	
