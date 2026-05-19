extends CharacterBody2D
var is_climbing: bool = false
@onready var attack_timer: Timer = $attack_timer
@onready var climb_time: Timer = $climb_time
@onready var i_frames: Timer = $i_frames
