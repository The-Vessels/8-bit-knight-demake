extends ColorRect
var select = preload("res://assets/sounds/select.wav")
var move = preload("res://assets/sounds/move.wav")

var can_choose = true

@onready var soul: Sprite2D = $MarginContainer/ColorRect/Soul
@onready var arrow: Sprite2D = $"../Arrow"
@onready var hp_boxes: Control = $"../HPBoxes"
enum {
	CHOICE_ATTACK,
	CHOICE_DEFEND,
	CHOICE_HEAL,
	CHOICE_NUMBER
}
enum {
	STATE_CHOOSE_ACTION,
	STATE_CHOOSE_HEAL,
	STATE_ATTACK
}
var choice := CHOICE_ATTACK
var state := STATE_CHOOSE_ACTION

var healee := 0
var unselected_modulate := Color.from_hsv(0.0, 0.0, 0.7)

var labels = ["MarginContainer/ColorRect/Attack","MarginContainer/ColorRect/Defend","MarginContainer/ColorRect/Heal"]

func anim(type: int) -> void: # 0 is go down, 1 is come up
	# TODO I'll work on this later.
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
		can_choose = true

func get_btn(idx: int) -> Label:
	return $MarginContainer/ColorRect.get_child(idx + 1)
func get_hpbox(idx: int) -> Control:
	return hp_boxes.get_child(idx)

#
#func _ready():
	#var a = await btn_pressed
	#print(a)


signal choice_selected(choice: int)
signal heal_selected(healee: int)

func wave() -> void:
	var choices: Array[int] = []
	var healees: Array[int] = []
	choices.resize(len(Global.characters))
	healees.resize(len(Global.characters))
	choices.fill(0)
	healees.fill(-1)
	
	for current_chara in range(len(Global.characters)):
		arrow.move_to(current_chara) # move_to() is defined in arrow.gd
		choice = CHOICE_ATTACK
		soul.set_position(get_btn(choice).position)
		state = STATE_CHOOSE_ACTION
		choices[current_chara] = await choice_selected
		if choices[current_chara] == CHOICE_HEAL:
			state = STATE_CHOOSE_HEAL
			healee = 0
			for i in range(hp_boxes.get_child_count()):
				if i != healee:
					get_hpbox(i).modulate = unselected_modulate
			healees[current_chara] = await heal_selected
			for i in range(hp_boxes.get_child_count()):
				get_hpbox(i).modulate = Color.WHITE
	
	for i in range(len(choices)):
		if choices[i] == CHOICE_ATTACK:
			Global.gprint("%s attacks!" % Global.characters[i].name)
		elif choices[i] == CHOICE_DEFEND:
			Global.gprint("%s defends!" % Global.characters[i].name)
		elif choices[i] == CHOICE_HEAL:
			Global.gprint("%s heals %s!" % [
				Global.characters[i].name, Global.characters[healees[i]].name
			])

func _ready() -> void:
	wave()

func _input(event: InputEvent) -> void:
	if state == STATE_CHOOSE_ACTION:
		var old_choice := choice
		if event.is_action_pressed("right"):
			choice = posmod(choice + 1, CHOICE_NUMBER)
		if event.is_action_pressed("left"):
			choice = posmod(choice - 1, CHOICE_NUMBER)
		if choice != old_choice:
			soul.set_position(get_btn(choice).position)
			$"../AUD".play_on(move, "Pulse")

		if event.is_action_pressed("confirm"):
			$"../AUD".play_on(select, "Sawtooth")
			choice_selected.emit(choice)

		
	elif state == STATE_CHOOSE_HEAL:
		var old_healee := healee
		if event.is_action_pressed("right"):
			healee = posmod(healee + 1, len(Global.characters))
		if event.is_action_pressed("left"):
			healee = posmod(healee - 1, len(Global.characters))
		if healee != old_healee:
			get_hpbox(old_healee).modulate = unselected_modulate
			get_hpbox(healee).modulate = Color.WHITE
			$"../AUD".play_on(move, "Pulse")
		
		if event.is_action_pressed("confirm"):
			$"../AUD".play_on(select, "Sawtooth")
			heal_selected.emit(healee)
	
	#var old_choice := choice
#
	#get_node(labels[old_choice]).modulate = Color(1.0, 1.0, 1.0)
	#get_node(labels[choice]).modulate = Color(1.0, 1.0, 0.0)
#
	#if can_choose:
		#if event.is_action_pressed("confirm"):
			## todo: actually do something lol
			#$UiSFX.stop()
			#$UiSFX.stream = select
			#$UiSFX.play()
			#can_choose = false
			#for i in range(4):
				#get_node(labels[choice]).hide()
				#await get_tree().create_timer(0.05).timeout
				#get_node(labels[choice]).show()
				#await get_tree().create_timer(0.05).timeout
			#match choice:
				#0: # FIGHT
					#$MarginContainer/ColorRect/Attack.hide()
					#$MarginContainer/ColorRect/Prompt.hide()
					#$MarginContainer/ColorRect/Defend.hide()
					#$MarginContainer/ColorRect/Heal.hide()
					#$MarginContainer/ColorRect/Soul.hide()
					#$MarginContainer/ColorRect/attack.show()
				#1: # DEFEND
					#Global.gprint("DEFEND")
				#2: # HEAL
					#Global.gprint("HEAL")
