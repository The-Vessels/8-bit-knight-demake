@tool
extends Sprite2D

var boxsize := Vector2.ZERO

func _ready() -> void:
	pass

func _draw() -> void:
	draw_rect(Rect2(Vector2(0,0),boxsize),Color.BLACK,true,-1.0,false)
	draw_rect(Rect2(Vector2(0,0),boxsize),Color.GREEN,false,1.0,false)
