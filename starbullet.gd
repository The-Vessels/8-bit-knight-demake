extends Bullet
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var star_bullet: Area2D = $"."
@export var timer_offset: float
var start_pos: Vector2
var end_pos: Vector2
var reverse = false
var slowdown = false
var velocity = Vector2(150.0,150.0)

func _ready() -> void:
	start_pos = position
	end_pos = Vector2(position.x - randf_range(-5.0,-15.0), position.y - randf_range(-4.0,4.0))
	scale = Vector2(0.25, 0.25)
	await get_tree().create_timer(3.25-timer_offset).timeout
	reverse = true
	slowdown = true
	velocity = velocity / 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if reverse:
		scale -= Vector2(0.01, 0.01)
		position -= (velocity * delta) * (position - end_pos).normalized()
	else:
		scale += Vector2(0.0125, 0.0125)
		position += (velocity * delta) * (position - end_pos).normalized()

	if (slowdown and velocity > Vector2.ZERO):
		self.modulate -= Color(0.0, 1.0, 1.0, 0.0) * delta
	
	if scale < Vector2(0.75, 0.75) and reverse:
		scale = Vector2(0.75, 0.75)
		
	if velocity < Vector2.ZERO:
		velocity = Vector2.ZERO
