extends Control


@onready var PathDialog = $PathDialog
@onready var ListNameLabel = $Information/ListName
@onready var SongCountLabel = $Information/SongCount


signal FileParseFinished


func GotoCreateNewList() -> void:
	get_tree().change_scene_to_file("res://Scene/create_new_list.tscn")


func FileSelected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		FileAccess.get_open_error()
	else:
		print("File read successfully!")
	var json = JSON.new()
	print("List parsing.")
	var json_string = file.get_as_text()
	file.close()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
	else:
		print(parse_result)
	var data = json.parse_string(json_string)
	GlobalManager.data = data
	emit_signal("FileParseFinished")


func LoadSongList() -> void:
	PathDialog.show()
	await FileParseFinished
	ListNameLabel.text += GlobalManager.data["listName"]
	SongCountLabel.text += String.num(GlobalManager.data["songCount"], 0)
	
