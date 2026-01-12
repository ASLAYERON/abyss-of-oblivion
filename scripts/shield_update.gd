extends Area2D
@onready var texture_rect: TextureRect = $TextureRect
@onready var shield: Sprite2D = $Shield
@onready var pop_up: Label = $"POP-UP"

func _ready() -> void:
	if Global.have_shield:
		queue_free()	

func _process(delta: float) -> void:
	if Global.state == "cutscene":
		var shield_opacity = shield.modulate.a8 #a8 = canal alpha
		var pop_up_opacity = pop_up.modulate.a8
		print("shield ",shield_opacity," pop up",pop_up_opacity)
		if shield_opacity >= 0.2:
			shield.modulate.a8 = shield_opacity - 0.05
			pop_up.modulate.a8 = pop_up_opacity + 1
			shield.position.y -= 0.01
		else:
			Global.state = "playing"
			Global.have_shield = true
			queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Global.state = "cutscene"
