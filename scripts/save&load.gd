extends Node
const save_location = "user://SaveFile.json"

var contents_to_save : Dictionary = {
	"active_checkpoint":"",
	"Altstein_progression":0,
	"Vespillo_progression":0,
	"Geld_Kampfer_progression":0,
	"have_shield":0,
	"coins":0,
	"max_health":50,
	"max_stamina":50,
}

func _save():
	contents_to_save.active_checkpoint = Global.active_checkpoint
	contents_to_save.Altstein_progression = Global.Altstein_progression
	contents_to_save.Vespillo_progression = Global.Vespillo_progression
	contents_to_save.Geld_Kampfer_progression = Global.Geld_Kampfer_progression
	contents_to_save.have_shield = Global.have_shield
	contents_to_save.coins = Global.coins
	contents_to_save.max_health = Global.max_health
	contents_to_save.max_stamina = Global.max_stamina
	var file = FileAccess.open(save_location,FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location,FileAccess.READ)
		var data = file.get_var()
		file.close()
		var save_data = data.duplicate()
		Global.active_checkpoint = save_data.active_checkpoint
		Global.tp_offset = Global.checkpoints[save_data.active_checkpoint][0]
		Global.Altstein_progression = save_data.Altstein_progression
		Global.Vespillo_progression = save_data.Vespillo_progression
		Global.Geld_Kampfer_progression = save_data.Geld_Kampfer_progression
		Global.have_shield = save_data.have_shield
		Global.coins = save_data.coins
		Global.max_health = save_data.max_health
		Global.max_stamina = save_data.max_stamina
		get_tree().change_scene_to_file(Global.checkpoints[save_data.active_checkpoint][1])
		Global.state = "playing"
		return save_data
