extends Node2D

@export var origin_sprite : AnimatedSprite2D;
@export var delta : float = 1;
@export var path : Node2D;
var time_off : float = 0.0;
var prev_frame : int = -1;
var prev_anim : StringName;
var time : float = 0;
func _process(dt : float):
	time_off += dt;
	time += dt;
	var target_y = self.position.y + sin(time) / 10.0
	self.position.y = lerp(self.position.y, target_y, 1)

	
	#var frame : int = origin_sprite.frame;
	#var anim : StringName = origin_sprite.animation;
	#if (frame != prev_frame || anim != prev_anim) || time_off > delta:
	#	spawn_phantom(anim,frame);
	#	time_off = 0.0;
		
func destroy_clone(clone : AnimatedSprite2D):
	clone.queue_free()
func spawn_phantom(animation : StringName, frame : int):
	if !path: return;
	var clone : AnimatedSprite2D = origin_sprite.duplicate()
	path.add_child(clone);
	clone.play(animation)
	clone.original = false;
	clone.frame = max(frame-1,0);
	var count = clone.sprite_frames.get_frame_count(animation)
	prev_frame = frame;
	prev_anim = animation;
	clone.modulate.a = 1.0;
	var duration : float = min((float)(count-frame)/frame,delta*2)
	clone.z_index = origin_sprite.z_index - 1;
