extends CharacterBody2D

const MAX_JUMPS := 2

enum State {GROUND, JUMP, FALL, DOUBLE_JUMP}

@export var acceleration:= 700
@export var air_acceleration:=400.0
@export var deceleration:= 1400
@export var max_speed:= 120
@export var max_fall_speed:= 250

@export_category("Jump")
@export_range(10.0, 200.0) var jump_height := 50.0
@export_range(0.1, 1.5) var jump_time_to_peak := 0.37
@export_range(0.1, 1.5) var jump_time_to_descent := 0.2
@export_range(50.0, 200.0) var jump_horizontal_distance := 80

@export_range(5.0, 50.0) var jump_cut_divider := 15.0

@export_category("Double Jump")
@export_range(10.0, 200.0) var double_jump_height := 30.0
@export_range(0.1, 1.5) var double_jump_time_to_peak := 0.3
@export_range(0.1, 1.5) var double_jump_time_to_descent := 0.25

var direction_x := 0.0
var current_state : State = State.GROUND
var current_gravity := 0.0

#state-specific variables:
var jump_count := 0

@onready var animated_sprite : AnimatedSprite2D = %AnimatedSprite2D
@onready var coyote_timer := Timer.new()
@onready var jump_input_buffer_timer := Timer.new()
@onready var dust: GPUParticles2D = %Dust

@onready var jump_speed = calculate_jump_speed(jump_height, jump_time_to_peak)
@onready var jump_gravity := calculate_jump_gravity(jump_height, jump_time_to_peak)
@onready var fall_gravity := calculate_fall_gravity(jump_height, jump_time_to_descent)
@onready var jump_horizontal_speed : float = calculate_jump_horizontal_speed(jump_horizontal_distance, jump_time_to_peak, jump_time_to_descent)

@onready var double_jump_speed = calculate_jump_speed(double_jump_height, double_jump_time_to_peak)
@onready var double_jump_gravity := calculate_jump_gravity(double_jump_height, double_jump_time_to_peak)
@onready var double_jump_fall_gravity := calculate_fall_gravity(double_jump_height, double_jump_time_to_descent)

func _ready() -> void:
	#Debug: Slow game down:
	#Engine.time_scale = 0.5
	_transition_to_state(State.GROUND)
	coyote_timer.wait_time = 0.05
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	jump_input_buffer_timer.wait_time = 0.05
	jump_input_buffer_timer.one_shot = true
	add_child(jump_input_buffer_timer)
	
func _physics_process(delta: float) -> void:
	direction_x = signf(Input.get_axis("move_left","move_right"))
	
	match current_state:
		State.GROUND:
			_physics_process_ground(delta)
		State.JUMP:
			_physics_process_jump(delta)
		State.FALL:
			_physics_process_fall(delta)
		State.DOUBLE_JUMP:
			_physics_process_double_jump(delta)
		
	velocity.y += current_gravity * delta
	velocity.y = minf(velocity.y, max_fall_speed)
	move_and_slide()
	
func calculate_jump_horizontal_speed(distance: float, time_to_peak: float, time_to_descent: float) -> float:
	return distance/(time_to_peak + time_to_descent)

func _physics_process_ground(delta: float) -> void:
	var is_moving := absf(direction_x) > 0.0
	if is_moving:
		velocity.x = clampf(velocity.x + direction_x * acceleration * delta, -max_speed, max_speed)
		animated_sprite.flip_h = 0.0 > direction_x
		animated_sprite.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration*delta)
		animated_sprite.play("Idle")
	
	dust.emitting = absf(direction_x) > 0.0
	
	if not jump_input_buffer_timer.is_stopped():
		_transition_to_state(State.JUMP)
	if Input.is_action_just_pressed("jump"):
		_transition_to_state(State.JUMP)
	elif not is_on_floor():
		_transition_to_state(State.FALL)
		
func _physics_process_jump(delta: float) -> void:
	if direction_x != 0.0:
		velocity.x = clampf(velocity.x + direction_x * air_acceleration * delta, -jump_horizontal_speed, jump_horizontal_speed)
		animated_sprite.flip_h = 0.0 > direction_x
	if Input.is_action_just_released("jump"):
		var jump_cut_speed : float = jump_speed / jump_cut_divider
		if velocity.y < 0.0 and velocity.y < jump_cut_divider:
			velocity.y = jump_cut_speed
	if velocity.y >= 0.0:
		_transition_to_state(State.FALL)
	elif Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		_transition_to_state(State.DOUBLE_JUMP)
			
func _physics_process_fall(delta: float) -> void:
	velocity.x = clampf(velocity.x + direction_x * acceleration * delta, -jump_horizontal_speed, jump_horizontal_speed)
	animated_sprite.flip_h = 0.0 > direction_x
	
	if Input.is_action_just_pressed("jump"):
		if not coyote_timer.is_stopped():
			_transition_to_state(State.JUMP)
		elif jump_count < MAX_JUMPS:
			_transition_to_state(State.DOUBLE_JUMP)	
		else:
			jump_input_buffer_timer.start()
	if is_on_floor():
		_transition_to_state(State.GROUND)	
	
func _physics_process_double_jump(delta: float) -> void:
	if direction_x != 0.0:
		velocity.x = clampf(velocity.x + direction_x * air_acceleration * delta, -jump_horizontal_speed, jump_horizontal_speed)
		animated_sprite.flip_h = 0.0 > direction_x
	if velocity.y >= 0.0:
		_transition_to_state(State.FALL)
		
func _transition_to_state(new_state: State):
	print("Transitioning from ", State.keys()[current_state], " to ", State.keys()[new_state])
	%Label.text = "State: " + State.keys()[new_state]
	var previous_state = current_state
	current_state = new_state
	match previous_state:
		State.FALL:
			coyote_timer.stop()
	match current_state:
		State.GROUND:
			jump_count = 0
			if previous_state == State.FALL:
				play_tween_touch_ground()
		State.JUMP:
			velocity.y = jump_speed
			current_gravity = jump_gravity
			velocity.x = direction_x * jump_horizontal_speed
			animated_sprite.play("Jump")
			jump_count = 1
			play_tween_jump()
			dust.emitting = true
		State.DOUBLE_JUMP:
			velocity.y = double_jump_speed
			current_gravity = double_jump_gravity
			velocity.x = direction_x * jump_horizontal_speed
			animated_sprite.play("Jump")
			jump_count = MAX_JUMPS
			play_tween_jump()
			dust.emitting = true
		State.FALL:
			if jump_count == MAX_JUMPS:
				current_gravity = double_jump_fall_gravity
			else:
				current_gravity = fall_gravity
				
			if previous_state == State.GROUND:
				coyote_timer.start()
				
			animated_sprite.play("Fall")
			
func calculate_jump_speed(height:float, time_to_peak:float)->float:
	return ((-2.0*height)/time_to_peak)
	
func calculate_jump_gravity(height:float, time_to_peak:float)->float:
	return (2*height/pow(time_to_peak,2.0))
	
func calculate_fall_gravity(height:float, time_to_descent:float)->float:
	return (2 * height/pow(time_to_descent,2.0))
	
func play_tween_jump() -> void:
	var tween := create_tween()
	tween.tween_property(animated_sprite, "scale", Vector2(1.15, 0.86), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2(0.86, 1.15), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2.ONE, 0.15)

func play_tween_touch_ground() -> void:
	var tween := create_tween()
	tween.tween_property(animated_sprite, "scale", Vector2(1.1, 0.9), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2(0.9, 1.1), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(animated_sprite, "scale", Vector2.ONE, 0.15)
	animated_sprite.rotation_degrees = 0.0
