@tool
class_name InsidePlatform extends Platform

@export_range(0.0, 380.0, 1.0) var y_komponente :=200.0: set = set_y_pos
@export_range(0.0, 2*PI , 0.01) var start_rotation := 0.0: set = set_rot
#@export var y_komponente :=200.0: set = set_y_pos
#@export var start_rotation := 0.0: set = set_rot

func _ready() -> void:
	super()
	set_y_pos(y_komponente)
	set_rot(start_rotation)
	
func set_y_pos(value: float) -> void:
	y_komponente = value
	if $CollisionShape2D and $Sprite:
		$CollisionShape2D.position.y = y_komponente
		$Sprite.position.y = y_komponente - height/2

func set_rot(value: float) -> void:
	start_rotation = value
	rotation = start_rotation
