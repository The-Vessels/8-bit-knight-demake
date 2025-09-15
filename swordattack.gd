extends Node2D
@export var sword_scene:PackedScene
var lastrot = -1

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _spawn_sword():
	var sword_obj = sword_scene.instantiate()
	sword_obj.rotation = randi_range(0,7) * 45
	if sword_obj.rotation == lastrot:
		sword_obj.rotation = randi_range(0,7) * 45
	lastrot = sword_obj.rotation
	add_child(sword_obj)


func _on_timer_timeout() -> void:
	_spawn_sword()
