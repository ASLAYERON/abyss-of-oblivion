extends Node
func retreat(parent):
	if parent.sleep_sound.playing: parent.sleep_sound.stop()
	if !parent.awake_sound.playing: parent.awake_sound.play()
	
