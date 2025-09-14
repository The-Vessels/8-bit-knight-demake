extends ColorRect

@onready var soul: Sprite2D = $MarginContainer/ColorRect/Soul
enum {
	CHOICE_ATTACK,
	CHOICE_DEFEND,
	CHOICE_HEAL,
	CHOICE_NUMBER
}
var choice := 0

func get_btn(idx: int) -> Label:
	return $MarginContainer/ColorRect.get_child(idx + 1)

func _input(event: InputEvent) -> void:
	var old_choice := choice
	if event.is_action_pressed("right"):
		choice = posmod(choice + 1, CHOICE_NUMBER)
	if event.is_action_pressed("left"):
		choice = posmod(choice - 1, CHOICE_NUMBER)
	
	if choice != old_choice:
		soul.set_position(get_btn(choice).position)
