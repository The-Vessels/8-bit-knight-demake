extends Node2D

func get_label(idx: int) -> Label:
	return get_child(idx)

func _ready() -> void:
	for i in range(len(Global.characters)):
		var hp := Global.characters[i].hp
		get_label(i).text = str(hp)

func _process(_delta: float) -> void:
	for i in range(len(Global.characters)):
		var hp := Global.characters[i].hp
		if get_label(i).text != str(hp):
			get_child(i).text = str(hp)
