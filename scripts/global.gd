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

var enemies={ #dict des mobs, la scene genere des ennemis sur la base de ce dict.
	"caves":{
		"rat01":["rat",Vector2(958,584)], #type,position
		"rat02":["rat",Vector2(1120,552)],
		"rat03":["rat",Vector2(1223,528)],
		"rat04":["rat",Vector2(1362,482)],
		"rat05":["rat",Vector2(1347,967)],
		"rat06":["rat",Vector2(1322,966)],
		"rat07":["rat",Vector2(1154,998)],
		"rat08":["rat",Vector2(1124,999)],
		"rat09":["rat",Vector2(1154,852)],
		"rat10":["rat",Vector2(1118,854)],
		"rat11":["rat",Vector2(941,1174)],
		"rat12":["rat",Vector2(916,1190)],
		"rat13":["rat",Vector2(544,405)],
		"rat14":["rat",Vector2(378,369)],
	},
	"mines":{
		
	},
	"debug_room":{
		"rat01":["rat",Vector2(52,-9)],		
	}
}

func reset_enemies():#recerée tout les ennemis a chaque repos, est appelé par checkpoint
	enemies={
		"caves":{
		"rat01":["rat",Vector2(958,584)], #type,position
		"rat02":["rat",Vector2(1120,552)],
		"rat03":["rat",Vector2(1223,528)],
		"rat04":["rat",Vector2(1362,482)],
		"rat05":["rat",Vector2(1347,967)],
		"rat06":["rat",Vector2(1322,966)],
		"rat07":["rat",Vector2(1154,998)],
		"rat08":["rat",Vector2(1124,999)],
		"rat09":["rat",Vector2(1154,852)],
		"rat10":["rat",Vector2(1118,854)],
		"rat11":["rat",Vector2(941,1174)],
		"rat12":["rat",Vector2(916,1190)],
		"rat13":["rat",Vector2(544,405)],
		"rat14":["rat",Vector2(378,369)],
		},
		"mines":{
			
	},
	"debug_room":{
		"rat01":["rat",Vector2(52,-9)],		
	}
	}
