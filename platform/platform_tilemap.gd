# Hamsterrad mit Area2D als Child
extends RigidBody2D

@export var rotation_speed: float = 0.1
var players_on_platform: Array = []

func _ready():
	gravity_scale = 0
	
	# Area2D für Player-Detection
	var area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(200, 20)  # Anpassen an dein Hamsterrad
	
	collision_shape.shape = shape
	area.add_child(collision_shape)
	add_child(area)
	
	area.body_entered.connect(_on_player_entered)
	area.body_exited.connect(_on_player_exited)

func _physics_process(delta):
	angular_velocity = rotation_speed
	
	# Alle Player auf der Platform mitrotieren
	for player in players_on_platform:
		if is_instance_valid(player):
			rotate_player_around_center(player, delta)

func rotate_player_around_center(player: Node2D, delta: float):
	var offset = player.global_position - global_position
	offset = offset.rotated(angular_velocity * delta)
	player.global_position = global_position + offset

func _on_player_entered(body):
	if body.is_in_group("player"):  # Player in Gruppe "player" einordnen
		players_on_platform.append(body)

func _on_player_exited(body):
	if body in players_on_platform:
		players_on_platform.erase(body)


#extends RigidBody2D
#
#@export var rot_spd := 0.1
#
#
#func _ready() -> void:
	##rotation = 0.0
	## RigidBody als kinematic setzen für volle Kontrolle
	#freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	#freeze = true
	#set_gravity_scale(0)
	#
#func _physics_process(delta):
	## Einfach die Winkelgeschwindigkeit setzen
	#angular_velocity = rot_spd
	#freeze = false



#func _process(delta: float) -> void:
	##rotation += delta * rot_spd
	#pass
#func _physics_process(delta):
	## AnimatableBody2D bewegt sich und überträgt automatisch Bewegung
	##var movement = Vector2(rot_spd * delta, 0)
	##move_and_collide(movement)
	#rotation += delta * rot_spd

# Hamsterrad als AnimatableBody2D
#extends AnimatableBody2D
#
#@export var rotation_speed: float = 0.1
#var center_point: Vector2
#
#func _ready():
	#center_point = global_position
#
#func _physics_process(delta):
	## Rotation um den Mittelpunkt
	#rotate(rotation_speed * delta)
	#
	## Oder für mehr Kontrolle:
	## rotation += rotation_speed * delta
