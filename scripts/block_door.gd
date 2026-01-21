extends Node2D
@onready var door: StaticBody2D = $door
@onready var scratch: AudioStreamPlayer2D = $scratch

var have_to_open = false
var have_to_close = false
var y_offset = 40
var start_y = 0
func _ready():
	start_y = door.position.y
	
func _process(delta: float) -> void:
	if have_to_open:
		if door.position.y > start_y - y_offset:
			door.position.y -= 1
		else:
			have_to_open = false
			scratch.stop()
	elif have_to_close:
		if door.position.y <= start_y :
			door.position.y += 2
		else:
			have_to_close = false
			scratch.stop()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if Global.have_shield:
			have_to_close = false
			have_to_open = true
			scratch.play()
			door.set_collision_layer_value(1,false)
		else:
			body.show_text("BESOIN DU BOUCLIER")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if Global.have_shield:
			have_to_close = true
			scratch.play()
			door.set_collision_layer_value(1,true)
		else:
			body.show_text("KILL")
