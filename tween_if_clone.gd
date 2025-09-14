extends AnimatedSprite2D
@export var original : bool = true
var duration = 0.2;
func _ready() -> void:
	self.play()
func _process(delta: float) -> void: 
	if !original:
		self.modulate.a = clamp(self.modulate.a-delta/duration,0,1)
