extends Node2D

@export var rotation_speed: float = 0.1

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	
@export var rotation_speed: float = 1.0

func _physics_process(delta):
	rotation += rotation_speed * delta

func get_velocity_at_point(point: Vector2) -> Vector2:
	# Berechnet die tangentiale Geschwindigkeit an einem Punkt
	# Platform-Mittelpunkt ist bei global_position
	var radius_vector = point - global_position
	
	# Tangentiale Geschwindigkeit = Kreuzprodukt von Winkelgeschwindigkeit und Radius
	# v = ω × r, in 2D: v = (-ry * ω, rx * ω)
	var tangential_velocity = Vector2(-radius_vector.y, radius_vector.x) * rotation_speed
	
	return tangential_velocity
