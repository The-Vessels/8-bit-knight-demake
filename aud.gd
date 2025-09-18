extends Node

const MUSIC_DIR := "res://assets/mus/"
var players: Array[AudioStreamPlayer] = []
var master_player: AudioStreamPlayer = null
var player_types := {}

func _ready() -> void:
	var dir := DirAccess.open(MUSIC_DIR)
	if dir == null:
		push_error("Could not open music directory: %s" % MUSIC_DIR)
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.to_lower().ends_with(".wav"):
			var file_path := MUSIC_DIR + file_name
			var stream := load(file_path)
			if stream is AudioStream:
				var player := AudioStreamPlayer.new()
				player.stream = stream
				player.autoplay = false
				player.bus = "Master"
				player.name = file_name.get_basename()
				add_child(player)
				players.append(player)
				
				# Inline type extraction
				var name_no_ext = file_name.get_basename()
				var parts = name_no_ext.split(" - ")
				var type_name := "Unknown"
				if parts.size() >= 2:
					var type_and_number = parts[1]
					var type_parts = type_and_number.split(" ")
					if type_parts.size() > 1 and type_parts[type_parts.size() - 1].is_valid_int():
						type_parts = type_parts.slice(0, type_parts.size() - 1)
					type_name = " ".join(type_parts)
				player_types[player] = type_name
		file_name = dir.get_next()
	dir.list_dir_end()
	
	if players.size() > 0:
		master_player = players[0]
		for p in players:
			p.play()
		var master_pos = master_player.get_playback_position()
		for i in range(1, players.size()):
			players[i].seek(master_pos)

func play_on(aud: AudioStream, type: String):
	# Mute all currently playing players of the requested type
	for p in players:
		if player_types.get(p, "") == type and p.is_playing():
			p.volume_db = -80.0

	var player := AudioStreamPlayer.new()
	player.stream = aud
	player.bus = "Master"
	add_child(player)
	players.append(player)
	player_types[player] = type

	if master_player != null:
		player.seek(master_player.get_playback_position())

	player.play()
	player.connect("finished", Callable(self, "_on_play_on_finished").bind(player, type))

func _on_play_on_finished(finished_player: AudioStreamPlayer, type: String) -> void:
	if finished_player != null and finished_player.is_inside_tree():
		players.erase(finished_player)
		player_types.erase(finished_player)
		finished_player.queue_free()
	
	# Unmute all remaining players of this type
	for p in players:
		if player_types.get(p, "") == type and p.is_playing():
			p.volume_db = 0.0

func _process(delta: float) -> void:
	if master_player == null:
		return
	if not master_player.is_playing():
		for p in players:
			p.stop()
		for p in players:
			p.play()
		var master_pos = master_player.get_playback_position()
		for i in range(1, players.size()):
			players[i].seek(master_pos)
