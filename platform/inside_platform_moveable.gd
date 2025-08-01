@tool
class_name InsidePlatformMoveable extends Platform

@export var map_centrum: Vector2 = Vector2.ZERO

var start_position: Vector2

func _ready() -> void:
	super ()
	if Engine.is_editor_hint():
		return
	start_position = global_position
	print(global_position)
	# Use set_deferred to ensure the change happens after the physics engine initialization
	set_deferred("global_position", map_centrum)
	print(global_position)
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
