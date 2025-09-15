extends ColorRect
var select = preload("res://assets/sounds/select.wav")
var move = preload("res://assets/sounds/move.wav")
var canmove = true
@onready var soul: Sprite2D = $MarginContainer/ColorRect/Soul
enum {
	CHOICE_ATTACK,
	CHOICE_DEFEND,
	CHOICE_HEAL,
	CHOICE_NUMBER
}
var choice := 0
var labels = ["MarginContainer/ColorRect/Attack","MarginContainer/ColorRect/Defend","MarginContainer/ColorRect/Heal"]
func anim(type: int) -> void: # 0 is go down, 1 is come up
	if type == 0:
		self.position = Vector2(3.0,200.0)
		$MarginContainer/ColorRect/Attack.hide()
		$MarginContainer/ColorRect/Defend.hide()
		$MarginContainer/ColorRect/Heal.hide()
		$MarginContainer/ColorRect/Soul.hide()
		create_tween().tween_property(self,"position:y",226.455,0.5)
	if type == 1:
		self.position = Vector2(3.0,226.455)
		await create_tween().tween_property(self,"position:y",200,0.5).finished
		$MarginContainer/ColorRect/Attack.show()
		$MarginContainer/ColorRect/Defend.show()
		$MarginContainer/ColorRect/Heal.show()
		$MarginContainer/ColorRect/Soul.show()
		canmove = true
func get_btn(idx: int) -> Label:
	return $MarginContainer/ColorRect.get_child(idx + 1)
	
func _input(event: InputEvent) -> void:
	var old_choice := choice
	if canmove:
		if event.is_action_pressed("right"):
			choice = posmod(choice + 1, CHOICE_NUMBER)
		if event.is_action_pressed("left"):
			choice = posmod(choice - 1, CHOICE_NUMBER)	
	get_node(labels[old_choice]).modulate = Color(1.0, 1.0, 1.0)
	get_node(labels[choice]).modulate = Color(1.0, 1.0, 0.0)
	if choice != old_choice:
		soul.set_position(get_btn(choice).position)
		$UiSFX.stream = move
		$UiSFX.play()
	if canmove:
		if event.is_action_pressed("confirm"):
			# todo: actually do something lol
			$UiSFX.stop()
			$UiSFX.stream = select
			$UiSFX.play()
			canmove = false
			for i in range(4):
				get_node(labels[choice]).hide()
				await get_tree().create_timer(0.05).timeout
				get_node(labels[choice]).show()
				await get_tree().create_timer(0.05).timeout
			match choice:
				0: # FIGHT
					print("FIGHT")
				1: # DEFEND
					print("DEFEND")
				2: # HEAL
					print("HEAL")
