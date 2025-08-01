@tool
class_name InsidePlatformMoveable extends Platform

@export var map_centrum: Vector2 = Vector2.ZERO

var start_position: Vector2

func _ready() -> void:
	super ()
	set_color(PlatformColor.GROUND)
	if Engine.is_editor_hint():
		return
	start_position = position
	position = map_centrum
	var difference_position = start_position - map_centrum
	collision_shape_2d.global_position += difference_position
	sprite.global_position += difference_position

func set_height(value: float) -> void:
	height = value
	if shape == null:
		return
	shape.size.y = height
	sprite.position.y = - height / 2.0
	sprite.size.y = height
