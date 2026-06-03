extends Node
var can_go_up = false #echelle et grimpable qui previennent le player que "up" marche
var state = "playing" #le "state" rythmes les phases (jeu, ui, cutscene ...)
var tp_offset = Vector2(-752,-476)#spawn au tt debut du jeu, 
							   #apres pour tp le player devant le bon portail a l'entree d'une zone
var is_loading = false
var Altstein_progression = 0
var Vespillo_progression = 0
var Geld_Kampfer_progression = 0
var coins = 0
var have_shield = false
var max_health = 50
var health_points = max_health
var max_stamina = 70
var stamina = max_stamina
var active_checkpoint: String = ""

var freeze_mode = ""
var dev_mode = true

var checkpoints = {
	"Foret des morts": [Vector2(-135.0, 232.0),"res://levels/arrival.tscn"],
	"Antre des rats": [Vector2(1161.0, 184.0),"res://levels/caves.tscn"],
	"Camp de l'ancien heros": [Vector2(1465.0, 1224.0),"res://levels/caves.tscn"],
	"Caveau du roi des rats": [Vector2(-408.0, 1032.0),"res://levels/caves.tscn"],
	"Rives des ruines": [Vector2(-321.0,599.0),"res://levels/sewer_part2.tscn"]
}

var chest = {
	"caves": [false, false,false, false,false, false,false]
}

func save_game(new_active_checkpoint) -> void:
	active_checkpoint = new_active_checkpoint
	saveSystem._save()
