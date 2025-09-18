extends Node2D

@export var origin_sprite : AnimatedSprite2D
@export var path : Node2D
@export var afterimage_speed : float = 50.0
@export var afterimage_lifetime : float = 0.5
@export var spawn_interval : float = 0.08
@export var spacing : float = 5.0
@export var movement_speed : float = 200.0

var time : float = 0.0
var spawn_timer : float = 0.0
var frame_history : Array = []
var afterimages : Array = []

func _process(dt : float):
	time += dt
	spawn_timer += dt

	var target_y = origin_sprite.position.y + sin(time * 2) / 8.0
	origin_sprite.position.y = lerp(origin_sprite.position.y, target_y, 300 * dt)

	var frame = origin_sprite.frame
	frame_history.insert(0, frame)
	if frame_history.size() > 6:
		frame_history.pop_back()

	if spawn_timer >= spawn_interval:
		spawn_afterimage(origin_sprite.animation)
		spawn_timer = 0.0

	for i in range(afterimages.size() - 1, -1, -1):
		var data = afterimages[i]
		var img : AnimatedSprite2D = data.sprite

		img.position.x += movement_speed * dt
		img.modulate.a -= dt / afterimage_lifetime

		data.frame_timer += dt
		if data.frame_timer >= data.frame_interval and data.frame_index < data.frames.size():
			data.frame_timer = 0.0
			img.frame = data.frames[data.frame_index]
			data.frame_index += 1

		if img.modulate.a <= 0:
			img.queue_free()
			afterimages.remove_at(i)

func spawn_afterimage(animation : StringName):
	if not path:
		return
	var clone : AnimatedSprite2D = origin_sprite.duplicate()
	path.add_child(clone)
	clone.play(animation)
	clone.animation = animation

	var mod = origin_sprite.modulate
	mod.a = 0.35
	clone.modulate = mod

	clone.z_index = origin_sprite.z_index - 1
	clone.position.x += spacing

	var data = {
		"sprite": clone,
		"frames": frame_history.duplicate(),
		"frame_index": 0,
		"frame_timer": 0.0,
		"frame_interval": 0.1
	}
	afterimages.append(data)
