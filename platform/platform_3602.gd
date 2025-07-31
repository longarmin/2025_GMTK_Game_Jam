extends AnimatableBody2D
@export var rot_spd := -.1
func _process(delta: float) -> void:
	rotation += delta * rot_spd
