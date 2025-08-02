class_name Level extends Node2D

@onready var player: Player = %Player
@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var node_rotate: Node2D = %RotationCenter

func _ready() -> void:
	GameManager.rot_spd = 0.0
	var player_speed = player.max_speed
	player.max_speed = 10
	animation.play("intro")
	animation.animation_finished.connect(func(_anim_name: String) -> void:
		GameManager.rot_spd = -0.1
		player.max_speed = player_speed
	)

func _physics_process(delta):
	node_rotate.rotate(delta * GameManager.rot_spd)


func _input(event: InputEvent) -> void:
	# Zwecks Debugging und Testing
	if event.is_action_pressed("level_success"):
		GameManager.change_state(GameManager.GameState.LEVEL_SUCCESS)