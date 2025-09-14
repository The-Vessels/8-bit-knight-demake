extends CharacterBody2D

const  SPEED = 50.0

func _physics_process(delta: float) -> void:
	var xdirection = Input.get_axis("left","right")
	var ydirection = Input.get_axis("up","down")
	if Input.is_action_pressed("cancel"):
		velocity = Vector2(xdirection,ydirection) * (SPEED / 2)
	else:
		velocity = Vector2(xdirection,ydirection) * SPEED
	position += velocity * delta
	Soulreference.soulPosition = position
	Soulreference.globalPosition = global_position
	move_and_slide()

func _ready() -> void:
	Soulreference.soulPosition = position
