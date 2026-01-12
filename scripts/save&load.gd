extends Node
const save_location = "user://SaveFile.json"

var contents_to_save : Dictionary = {
	"player_position":Vector2.ZERO,
	"scene_file_path":"",
	"Altstein_progression":0,
	"Vespillo_progression":0,
	"Geld_Kampfer_progression":0,
	"have_shield":0,
	"coins":0,
}

func _save(player_position,scene_file_path,Altstein_progression,Vespillo_progression,Geld_Kampfer_progression,have_shield,coins):
	contents_to_save.scene_file_path = scene_file_path
	contents_to_save.player_position = player_position
	contents_to_save.Altstein_progression = Altstein_progression
	contents_to_save.Vespillo_progression = Vespillo_progression
	contents_to_save.Geld_Kampfer_progression = Geld_Kampfer_progression
	contents_to_save.have_shield = have_shield
	contents_to_save.coins = coins
	var file = FileAccess.open(save_location,FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location,FileAccess.READ)
		var data = file.get_var()
		file.close()
		var save_data = data.duplicate()
		Global.tp_offset = save_data.player_position
		Global.Altstein_progression = save_data.Altstein_progression
		Global.Vespillo_progression = save_data.Vespillo_progression
		Global.Geld_Kampfer_progression = save_data.Geld_Kampfer_progression
		Global.have_shield = save_data.have_shield
		Global.coins = save_data.coins
		return save_data
