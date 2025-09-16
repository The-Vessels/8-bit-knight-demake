extends Node2D

@onready var stars: Node2D = $Stars
const bullet_count = 30
const star_bullet = preload("res://star_bullet.tscn")

func _ready() -> void:
	for i in range(bullet_count):
		spawn_bullet(i/10.0)
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(1.5).timeout
	stars.queue_free()
	

func spawn_bullet(timer_offset):
	var bullet_instance = star_bullet.instantiate()
	bullet_instance.timer_offset = timer_offset
	stars.add_child(bullet_instance)
