@tool
extends StaticBody2D

@export var boxsize = Vector2(75,75):
	set(new):
		boxsize = new
		if Engine.is_editor_hint():
			$"Sprite2D".boxsize = boxsize
			_solve_box(boxsize)
			$"Sprite2D".queue_redraw()

@export var afterimages := false:
	set(new):
		var should_gen := new and not afterimages
		afterimages = new
		if should_gen and not Engine.is_editor_hint():
			gen_afterimages() # this is coroutine!!!

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var boxpos = Vector2(DisplayServer.window_get_size() / 2)
	# this stopped me from testing my shish soz
	# Global.gprint(boxsize)
	_solve_box(boxsize)
	$"Sprite2D".boxsize = boxsize

func gen_afterimages():
	while afterimages:
		var clone: Sprite2D = $"Sprite2D".duplicate()
		clone.boxsize = boxsize
		clone.global_position = $"Sprite2D".global_position
		get_parent().add_child(clone)
		var tween = create_tween()
		tween.tween_property(clone, "modulate:a", 0.0, 1.0)
		tween.tween_callback(clone.queue_free)
		await get_tree().create_timer(1.0/30.0).timeout

func _solve_box(boxsize):
	$CollisionShape2D.shape.size = Vector2(1,boxsize.y)
	$CollisionShape2D.position.y = boxsize.y / 2
	
	$CollisionShape2D2.shape.size = Vector2(boxsize.x,1)
	$CollisionShape2D2.position.x = boxsize.x / 2
	
	$CollisionShape2D3.shape.size = Vector2(1,boxsize.y)
	$CollisionShape2D3.position.y = boxsize.y / 2
	$CollisionShape2D3.position.x = boxsize.x

	$CollisionShape2D4.shape.size = Vector2(boxsize.x,1)
	$CollisionShape2D4.position.x = boxsize.x / 2
	$CollisionShape2D4.position.y = boxsize.y
