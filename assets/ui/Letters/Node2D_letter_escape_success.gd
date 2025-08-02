extends Node2D

@onready var t = 0.0
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	t += delta
	var wiggle = sin(50 * t * delta)/2
	rotation = wiggle
	var scale_wiggle = (sin(230 * t * delta)/2)/t + 1
	scale = Vector2(scale_wiggle, scale_wiggle)
