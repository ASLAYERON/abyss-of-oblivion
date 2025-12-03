extends Node
const save_location = "user://SaveFile.json"

var contents_to_save : Dictionary = {
	"player_position":Vector2.ZERO,
	"scene_file_path":"",
}

func _save(player_position,scene_file_path):
	contents_to_save.scene_file_path=scene_file_path
	contents_to_save.player_position=player_position
	var file = FileAccess.open(save_location,FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location,FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		return save_data
