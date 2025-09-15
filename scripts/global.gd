extends Node

var characters: Array[Character] = [
	Character.new("Kris",   160),
	Character.new("Susie",  190),
	Character.new("Ralsei", 140),
]

func gprint(msg: String) -> void:
	var layer = get_tree().root.get_node_or_null("GPrintCanvas")
	if layer == null:
		layer = CanvasLayer.new()
		layer.layer = 4096
		layer.name = "GPrintCanvas"
		get_tree().root.add_child(layer)
	var lbl = Label.new()
	lbl.text = msg
	lbl.set_anchors_preset(Control.PRESET_TOP_LEFT)
	lbl.add_theme_font_override("font", load("res://fonts/main.ttf"))
	lbl.modulate.a = 1.0
	var count = layer.get_child_count()
	lbl.position = Vector2(10, 10 + count * 20)
	layer.add_child(lbl)
	if count >= 10:
		layer.get_child(0).queue_free()
		for i in range(layer.get_child_count()):
			layer.get_child(i).position = Vector2(10, 10 + i * 20)
	var tween = lbl.create_tween()
	tween.tween_property(lbl, "modulate:a", 0.0, 1.0).set_delay(3.0)
	tween.tween_callback(Callable(lbl, "queue_free"))
