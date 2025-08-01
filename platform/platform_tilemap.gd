extends Node2D

@export var rot_spd := 0.1

func _ready() -> void:
	rotation = 0.0

func _process(delta: float) -> void:
	rotation += delta * rot_spd
