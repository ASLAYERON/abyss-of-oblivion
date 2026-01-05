extends Node2D
@onready var shader: CanvasModulate = $CanvasModulate
@onready var text: Label = $text
@onready var timer: Timer = $Timer
@onready var beginning_cutscene: Sprite2D = $BeginningCutscene
@onready var timer_2: Timer = $Timer2
@onready var title: AnimatedSprite2D = $AnimatedSprite2D

# ###################################
var state = "beginning"
var step=0
var text_list=[
	"Maintenant, il ne reste que des ruines des etages superieurs
	 Et pour les profondeurs, nul ne sait ce qui en advient..." ,
	"Le royaume connut son heure de gloire, en des temps anciens.
	 Mais dans leur faste, dans leur orgueuil,terrible orgeuil" ,
	"Ils firent lumiere de savoirs, des savoirs proscrit, nombre 
	 d'arcanes interdites, des reliques apostates, rien de bon" ,
	"Ce fut leur chute, ce fut la decheance de tout leur peuple, 
	 de leurs palais, de leur or, pour un seul peche, " ,
	"HERESIE HERESIE HERESIE HERESIE HERESIE HERESIE HERESIE HERESIE
	HERESIE HERESIE HERESIE HERESIE HERESIE HERESIE HERESIE HERESIE " ,
	"Le fruit de leurs travaux damnes hante encore l'abysse, se refusant a la mort,
	a l'oubli, et il prend tout aux pauvres fous sur qui il tombe",

	]
# ##################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader.visible=true
	text.visible_ratio=0
	text.text=text_list[step]
	beginning_cutscene.frame=0
	timer.start()
	
# ####################################

func _on_timer_timeout() -> void:
	if state=="wait":
		state="fade_out"
	elif state=="beginning":
		state="fade_in"

# #####################################

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "wait":
		pass
		
	elif  state == "fade_in":
		var actual_color=shader.get_color()
		if actual_color[0]<=1:
			shader.set_color(Color(actual_color[0]+0.01,actual_color[1]+0.01,actual_color[2]+0.01,))
		if text.visible_ratio<1:
			text.visible_ratio+=0.003
		else:
			state = "wait"
			timer.start()

	elif state == "fade_out":
		var actual_color=shader.get_color()
		if actual_color[0]>0:
			shader.set_color(Color(actual_color[0]-0.01,actual_color[1]-0.01,actual_color[2]-0.01,))
		else:
			state = "change"
	
	elif state == "change":
		if step<5:
			step+=1
			beginning_cutscene.frame=step
			text.visible_ratio=0
			text.text=text_list[step]
			state="fade_in"
		else :
			text.visible=false
			beginning_cutscene.visible=false
			title.visible=true
			state="title"
	elif state=="title":
		var actual_color=shader.get_color()
		if actual_color[0]<=1:
			shader.set_color(Color(actual_color[0]+0.01,actual_color[1]+0.01,actual_color[2]+0.01,))
		else:
			title.play("title")	


func _on_animated_sprite_2d_animation_finished() -> void:
	Global.tp_offset=Vector2(-752,-476)
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
