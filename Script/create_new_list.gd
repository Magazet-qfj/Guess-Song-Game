extends Control


@onready var SongNameEdit = $InfoEdit/SongName/SongNameEdit
@onready var SongArtistEdit = $InfoEdit/SongArtist/SongNameEdit
@onready var ListNameEdit = $InfoEdit/SongListName/SongNameEdit

@onready var IndexText = $InfoEdit/SongIndex
@onready var CountText = $InfoEdit/SongCount

@onready var PathDialog = $PathDialog


var songIndex = 0
var songCount = 0
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
