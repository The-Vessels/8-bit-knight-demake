extends Node2D

@export var origin_sprite : AnimatedSprite2D
@export var delta : float = 1
@export var path : Node2D
@export var afterimage_speed : float = 50.0
@export var afterimage_lifetime : float = 0.5
@export var spawn_interval : float = 0.05
@export var afterimage_fps : int = 25
@export var spacing : float = 5.0

var time_off : float = 0.0
var prev_frame : int = -1
var prev_anim : StringName
var time : float = 0
var afterimages : Array = []
var spawn_timer : float = 0.0

func _process(dt : float):
	time_off += dt
	time += dt
	spawn_timer += dt

	var target_y = origin_sprite.position.y + sin(time) / 10.0
	origin_sprite.position.y = lerp(origin_sprite.position.y, target_y, 100 * dt)

	var frame : int = origin_sprite.frame
	var anim : StringName = origin_sprite.animation
	if frame != prev_frame or anim != prev_anim:
		prev_frame = frame
		prev_anim = anim

	if spawn_timer >= spawn_interval:
		spawn_afterimage(frame, anim)
		spawn_timer = 0.0

	for i in range(afterimages.size() - 1, -1, -1):
		var img = afterimages[i]
		img.position.x += afterimage_speed * dt
		img.modulate.a -= dt / afterimage_lifetime
		if img.modulate.a <= 0:
			img.queue_free()
			afterimages.remove_at(i)

func spawn_afterimage(frame : int, animation : StringName):
	if !path: return
	var clone : AnimatedSprite2D = origin_sprite.duplicate()
	path.add_child(clone)
	clone.play(animation)
	clone.frame = frame
	clone.animation = animation
	clone.speed_scale = float(afterimage_fps) / origin_sprite.sprite_frames.get_animation_speed(animation)
	clone.modulate = origin_sprite.modulate
	clone.z_index = origin_sprite.z_index - 1
	clone.position.x += spacing
	afterimages.append(clone)
