@tool

class_name Circle extends Node2D

@export var platform_count: int = 18: set = set_platforms

@onready var platform_scene: PackedScene = preload("res://platform/platform.tscn")

func _ready() -> void:
	if platform_scene:
		set_platforms(platform_count)
	

func set_platforms(new_count: int) -> void:
	# Remove existing platforms first
	for child in get_children():
		if child is Platform:
			remove_child(child)
			child.queue_free()

	platform_count = new_count
	if platform_scene:
		for count in range(platform_count):
			var platform: Platform = platform_scene.instantiate()
			add_child(platform)
			var rotation_angle := count * (2 * PI / platform_count)
			var angle_to_border := Vector2.from_angle(rotation_angle)
			platform.position = Vector2(angle_to_border * 25.0 * platform_count)
			platform.rotate(rotation_angle + PI / 2)
			

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	rotate(delta * GameManager.rot_spd)
