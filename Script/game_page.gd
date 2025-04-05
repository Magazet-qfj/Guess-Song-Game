extends Control


@onready var MainList = $ItemList
@onready var LetterLabel = $LetterLabel
@onready var IsShowArtist = $RightButtonGroup/IsShowArtist
@onready var OpenLetterEdit = $RightButtonGroup/OpenLetter

var isShowArtist = false
var openedLetter : Array[String] = []


func _ready() -> void:
	ShowSongList()


func ShowSongList() -> void:
	MainList.clear()
	var data = GlobalManager.data
	
	for song in data["songList"]:
		var songIndex = song["index"]
		var songName = song["songName"]
		var songArtist = song["songArtist"]

		for i in range(songName.length()):
			if !openedLetter.has(songName[i]):
				songName[i] = "*"
		for i in range(songArtist.length()):
			if !openedLetter.has(songArtist[i]):
				songArtist[i] = "*"

		var itemText = String.num(songIndex + 1, 0) + ". " + songName
		if isShowArtist:
			itemText += " - " + songArtist
		MainList.add_item(itemText)


func ReturnToHomePage() -> void:
	get_tree().change_scene_to_file("res://Scene/main_page.tscn")


func IsShowArtistToggled(toggled_on: bool) -> void:
	if toggled_on:
		IsShowArtist.text = "Hide Artist"
		isShowArtist = true
	else:
		IsShowArtist.text = "Show Artist"
		isShowArtist = false
	ShowSongList()


func ColumnCountChanged(new_text: String) -> void:
	var columnCount = 1
	if new_text:
		columnCount = int(new_text)
	MainList.max_columns = columnCount


func OpenALetter() -> void:
	var letter = OpenLetterEdit.text
	LetterLabel.text += letter + ", "
	if letter:
		openedLetter.append(letter)
	ShowSongList()


func SetWidth(new_text: String) -> void:
	var width = 0
	if new_text:
		width = float(new_text)
	MainList.fixed_column_width = width


func RestartGame() -> void:
	get_tree().reload_current_scene()
