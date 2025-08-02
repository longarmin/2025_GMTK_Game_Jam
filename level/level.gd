class_name Level extends Node2D

@onready var player: Player = %Player
@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var node_rotate: Node2D = %RotationCenter
@onready var panel: PanelContainer = %PanelContainer
@onready var start_label: Label = %StartLabel
@onready var timer_start: Timer = Timer.new()

var has_timer_started := false

func _ready() -> void:
	timer_start.autostart = false
	timer_start.wait_time = 3.0
	add_child(timer_start)
	disable_all_physics(false)

	animation.play("intro")
	animation.animation_finished.connect(func(_anim_name: String) -> void:
		timer_start.start()
		has_timer_started = true
	)
	timer_start.timeout.connect(func() -> void:
		panel.hide()
		disable_all_physics(true)
	)

func _physics_process(delta):
	node_rotate.rotate(delta * GameManager.rot_spd)

func _process(_delta: float) -> void:
	if has_timer_started:
		start_label.text = "Start in " + str(timer_start.time_left).pad_decimals(2)

func _input(event: InputEvent) -> void:
	# Zwecks Debugging und Testing
	if event.is_action_pressed("level_success"):
		GameManager.change_state(GameManager.GameState.LEVEL_SUCCESS)
	if event.is_action_pressed("ui_accept"):
		animation.advance(5.0)


func disable_all_physics(enable: bool) -> void:
	# Disable/enable physics for the level itself
	set_physics_process(enable)
	
	# Recursively disable/enable physics for all children
	for node in get_tree().current_scene.get_children():
		set_node_physics_recursive(node, enable)

func set_node_physics_recursive(node: Node, enable: bool) -> void:
	if node.has_method("_physics_process"):
		node.set_physics_process(enable)
	
	# Recursively process children
	for child in node.get_children():
		set_node_physics_recursive(child, enable)