extends Node
func idle(parent):
	if !parent.sleep_sound.playing: parent.sleep_sound.play()
	if parent.awake_sound.playing: parent.awake_sound.stop()
	parent.sprite.play("sleep")
