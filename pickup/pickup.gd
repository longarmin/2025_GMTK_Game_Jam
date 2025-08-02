class_name Pickup extends Area2D

@export var energy_gain := 10.0
@onready var audio: AudioStreamPlayer = %AudioStreamPlayer

func _ready() -> void:
	var start_position = position
	position = Vector2.ZERO
	$Sprite2D.global_position = start_position
	$CollisionShape2D.global_position = start_position
	body_entered.connect(func(body: Node2D) -> void:
		if body is Player:
			audio.play()
			body.energy += energy_gain
			queue_free()
	)
	
func _physics_process(delta: float) -> void:
	rotation += GameManager.rot_spd * delta
