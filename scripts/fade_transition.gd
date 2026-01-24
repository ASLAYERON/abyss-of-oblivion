extends CanvasModulate
@export var fade = 2
var is_fading_in = false
var is_fading_out = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_fading_in:
		if self.color != Color.WHITE:
			self.color=self.color.lerp(Color.WHITE,fade*delta)
		else:
			is_fading_in = false
	if is_fading_out:
		if self.color != Color.BLACK:
			self.color=self.color.lerp(Color.BLACK,fade*delta)
		else:
			is_fading_out = false
	else:
		pass

func fade_in():
	is_fading_in = true
	
func fade_out():
	is_fading_out = true

func white():
	self.color = Color.WHITE

func black():
	self.color = Color.BLACK	
