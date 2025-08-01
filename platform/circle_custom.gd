@tool

class_name CircleCustom extends Node2D

@onready var escape: Area2D = %Escape
@onready var platform_scene: PackedScene = preload("res://platform/platform.tscn")
@export var platform_count: int = 18: set = set_platforms

func _ready() -> void:
	escape.body_entered.connect(func(body: Node2D) -> void:
		if body is Player:
			GameManager.change_state(GameManager.GameState.END_MENU)
	)
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
			
	var i = 0
	for platform in get_children():
		if platform is Platform:
			# Use set_deferred to ensure the changes aren't overridden by the physics engine
			platform.sprite.set_deferred("position", Vector2(-platform.width / 2, platform_count * 25.0 - platform.height / 2.0))
			platform.collision_shape_2d.set_deferred("position", Vector2(0.0, platform_count * 25.0))
			platform.set_deferred("rotation_degrees", i * (360 / platform_count))
			i += 1
