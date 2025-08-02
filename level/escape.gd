class_name Escape extends Area2D
@onready var level_complete:bool = false
var escape_successful_splasher = preload("res://assets/ui/Letters/letter_escape_success.tscn")
@onready var timer_end: Timer = Timer.new()

func _ready() -> void:
	timer_end.autostart = false
	timer_end.one_shot = true
	add_child(timer_end)
	timer_end.timeout.connect(func() -> void:
		get_parent().start_label.hide()
		get_parent().end_label.show()
		get_parent().panel.show()
	)
	body_entered.connect(func(body: Node2D) -> void:
		if body is Player:
			body.energy_timer.stop()
			body.set_physics_process(false)
			body.inhibit_motion = true
			level_complete = true
			var splasher_presenter = escape_successful_splasher.instantiate()
			add_child(splasher_presenter)
			get_parent().end_label.text = "Ready For Another Rat Race?\nPress Enter!"
			timer_end.start(5.0)
			)

func _process(delta: float) -> void:
	if level_complete:
		var pos:Vector2=get_parent().start_label.get_position()
		get_parent().start_label.set_position(Vector2(pos.x, get_viewport().get_visible_rect().size.y*0.8),0)

func _physics_process(delta: float) -> void:
	if level_complete:
		if GameManager.rot_spd < 6:
			GameManager.rot_spd += delta
		if Input.is_action_just_pressed("ui_accept"):
			level_complete = false
			GameManager.rot_spd = GameManager.STANDARD_ROT_SPD
			GameManager.change_level()
