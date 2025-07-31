class_name Pickup extends Area2D

@export var power_gain := 10.0

func _ready() -> void:
	body_entered.connect(func(body: Node2D) -> void:
		if body is Player:
			print(body.energy)
			body.energy += power_gain
			queue_free()
	)
