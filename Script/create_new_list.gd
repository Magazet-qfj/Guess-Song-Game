extends Control


@onready var SongNameEdit = $InfoEdit/SongName/SongNameEdit
@onready var SongArtistEdit = $InfoEdit/SongArtist/SongNameEdit
@onready var ListNameEdit = $InfoEdit/SongListName/SongNameEdit

@onready var IndexText = $InfoEdit/SongIndex
@onready var CountText = $InfoEdit/SongCount

@onready var OperateButtonGroup = $OperateButtonGroup
@onready var InfoEdit = $InfoEdit
@onready var PathDialog = $PathDialog
@onready var FileSelectDialog = $FileSelectDialog


signal FileParseFinished


var songIndex : int = 0
var songCount : int = 0
var songList = []
var list = {}
var savePath = ""


func AddNewSong() -> void:
	var song = {
		"index" : songIndex,
		"songName" : SongNameEdit.text,
		"songArtist" : SongArtistEdit.text
	}
	if songCount == songIndex:
		songList.append(song)
		songCount += 1
		songIndex += 1
		print("Add successfully!")
	else:
		songList[songIndex - 1] = song
		print("Rewrite successfully!")
	SongNameEdit.text = ""
	SongArtistEdit.text = ""
	print("Now songCount & songIndex is " + str(songCount) + " " + str(songIndex))


func SaveSongList() -> void:
	PathDialog.show()
	await PathDialog.dir_selected
	var json = JSON.new()
	var listName = ListNameEdit.text
	var file = FileAccess.open(savePath + "/" + listName + ".json", FileAccess.WRITE)
	list["listName"] = listName
	list["songCount"] = songCount
	list["songList"] = songList
	json = JSON.stringify(list)
	file.store_string(json)
	file.close()


func DirSelected(dir: String) -> void:
	savePath = dir


func _process(delta: float) -> void:
	IndexText.text = "Song Index: " + str(songIndex)
	CountText.text = "Song Count: " + str(songCount)


func EditLastSong() -> void:
	if songIndex == 1:
		print("This is the first song.")
		return
	songIndex -= 1
	print("Switch to last song, index: " + str(songIndex))
	SongNameEdit.text = songList[songIndex - 1]["songName"]
	SongArtistEdit.text = songList[songIndex - 1]["songArtist"]


func EditNextSong() -> void:
	if songIndex == songCount:
		print("This is the last song.")
		return
	songIndex += 1
	print("Switch to last song, index: " + str(songIndex))
	SongNameEdit.text = songList[songIndex - 1]["songName"]
	SongArtistEdit.text = songList[songIndex - 1]["songArtist"]


func ReturnToHomePage() -> void:
	get_tree().change_scene_to_file("res://Scene/main_page.tscn")


func CreateSongList() -> void:
	OperateButtonGroup.hide()
	InfoEdit.show()


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
	FileSelectDialog.show()
	await FileParseFinished
	var data = GlobalManager.data
	songList = data["songList"]
	songCount = int(data["songCount"])
	ListNameEdit.text = data["listName"]
	SongNameEdit.text = "Read list succesfully!"
	SongArtistEdit.text = "Click \"Next\" to edit the list."
	songIndex = 0
	OperateButtonGroup.hide()
	InfoEdit.show()
