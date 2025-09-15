extends Bullet



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_level = true
	$AnimationTree.play("attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $AnimationTree.current_animation == "attack":
		global_position = Soulreference.globalPosition + (-transform.y * 50)


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		$AnimationTree.play("flash")
		$CollisionShape2D.disabled = false
		top_level = false
	if anim_name == "flash":
		queue_free()
