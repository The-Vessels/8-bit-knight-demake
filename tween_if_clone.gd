extends AnimatedSprite2D
@export var original : bool = true
var duration = 0.2;
var t = 0.0;
func _ready() -> void:
	self.play()
func _process(delta: float) -> void: 
	t += delta;
	if !original:
		self.modulate.a = clamp(self.modulate.a-delta/duration,0,1)
		if !roundi(t*48)%3:
			self.position.x += 4
