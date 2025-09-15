extends ColorRect

var damage = 0
var move_speed: float = 100.0
var interval: float = 0.05
var start_pos: Vector2 = Vector2(150.0, 2.55)
var max_damage: int = 50
var min_damage: int = 20
var target: NodePath = "../ColorRect2"
var past_timer: float = -1.0
var move_timer: float = 0.0

func _ready() -> void:
	position = start_pos

func _process(delta: float) -> void:
	if not get_parent().visible:
		return

	move_timer += delta
	if move_timer >= interval:
		move_timer = 0.0
		position.x -= move_speed * interval

	var target_node = get_node(target)
	if position.x < target_node.position.x:
		if past_timer < 0.0:
			past_timer = 0.0
		else:
			past_timer += delta
		if past_timer >= 1.0:
			hide()

	if Input.is_action_just_pressed("confirm"):
		var dist = abs(position.x - target_node.position.x)
		var max_dist = 200.0
		var t = clamp(1.0 - dist / max_dist, 0.0, 1.0)
		damage = int(lerp(min_damage, max_damage, t))
		move_speed = 0
		print("bar.gd, damage is %s" % damage)
