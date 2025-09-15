extends StaticBody2D
@onready var boxsize = Vector2(75,75)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	var boxpos = Vector2(DisplayServer.window_get_size() / 2)
	print(boxsize)



# Called every frame. 'delta' is the elapsed time since the previous frame.

	



func _draw_box(boxsize):
	draw_rect(Rect2(Vector2(0,0),boxsize),Color.BLACK,true,-1.0,false)
	draw_rect(Rect2(Vector2(0,0),boxsize),Color.GREEN,false,1.0,false)



func _draw() -> void:
	_draw_box(boxsize)
	_solve_box(boxsize)
	
func _solve_box(boxsize):
	$CollisionShape2D.shape.size = Vector2(1,boxsize.y)
	$CollisionShape2D.position.y = boxsize.y / 2
	
	$CollisionShape2D2.shape.size = Vector2(boxsize.x,1)
	$CollisionShape2D2.position.x = boxsize.x / 2
	
	$CollisionShape2D3.shape.size = Vector2(1,boxsize.y)
	$CollisionShape2D3.position.y = boxsize.y / 2
	$CollisionShape2D3.position.x = boxsize.x

	$CollisionShape2D4.shape.size = Vector2(boxsize.x,1)
	$CollisionShape2D4.position.x = boxsize.x / 2
	$CollisionShape2D4.position.y = boxsize.y
