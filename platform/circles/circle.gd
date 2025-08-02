@tool

extends Node2D


func _ready() -> void:
	rotation = 0.0
	var i = 0
	for child in get_children():
		if child is Platform:
			child.rotation_degrees = i * 20
			i += 1

func _process(delta: float) -> void:
	pass
