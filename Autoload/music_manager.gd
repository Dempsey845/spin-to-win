extends Node

var fade_duration := 2.0

var playlist: Array[AudioStream] = []
var current_index := 0

var player: AudioStreamPlayer
var tween: Tween

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	
	var song_1: AudioStream = load("uid://4dgihb4rwtkw")
	var song_2: AudioStream = load("uid://dno0ds6ycolty")

	player = AudioStreamPlayer.new()
	player.bus = "Music"
	add_child(player)

	playlist = [song_1, song_2]

	player.finished.connect(_on_song_finished)

	_play_song(current_index)


func _play_song(index: int) -> void:
	if playlist.is_empty():
		return

	player.stream = playlist[index]

	player.volume_db = -80
	player.play()

	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(
		player,
		"volume_db",
		0.0,
		fade_duration
	)


func _on_song_finished() -> void:
	if tween:
		tween.kill()

	tween = create_tween()

	tween.tween_property(
		player,
		"volume_db",
		-80.0,
		fade_duration
	)

	await tween.finished

	current_index = (current_index + 1) % playlist.size()

	_play_song(current_index)