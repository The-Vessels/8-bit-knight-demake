extends Node2D
@export var attack_scene:PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Soul.position = (Vector2(256,224) / 2)
	$Battlebox.position = (Vector2(256,224) / 2) - (($Battlebox.boxsize + Vector2(1,1)) / 2)
	print(Vector2(get_viewport().size / 2))
	$Battlebox.modulate = Color(1,1,1,0)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Battlebox,"modulate",Color(1,1,1,1),0.5)
	await tween.finished
	_spawn_attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _spawn_attack():
	var attack = attack_scene.instantiate()
	attack.global_position = $Battlebox.position + ($Battlebox.boxsize / 2)
	$Battlebox.add_child(attack)
