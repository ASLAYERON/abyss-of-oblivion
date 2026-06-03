extends Node2D
@onready var icon: Sprite2D = $Icon
var tween = create_tween()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range (3):
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_parallel(false)
		tween.tween_property($Icon,"modulate:a",1,0.2)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_property($Icon,"modulate:a",0,0.5)
