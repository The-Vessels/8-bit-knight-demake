extends Node2D

func _unhandled_input(event):
	$GameViewport.push_input(event)
