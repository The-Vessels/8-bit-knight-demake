class_name Character

var name: String
var max_hp: int
var hp: int

func _init(name: String, max_hp: int, hp: int = -1) -> void:
	self.name = name
	self.max_hp = max_hp
	if hp == -1:
		self.hp = max_hp
	else:
		self.hp = clamp(hp, 0, max_hp)

func set_hp(hp: int) -> void:
	self.hp = clamp(hp, 0, max_hp)
