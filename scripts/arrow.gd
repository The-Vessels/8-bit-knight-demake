extends Sprite2D

@onready var hpboxes: HBoxContainer = $"../HPBoxes"

func move_to(character: int):
	print(character)
	var child: NinePatchRect = hpboxes.get_child(character).get_node("Box")
	set_position(child.global_position)
