@tool
class_name RotatingPlatform extends Platform

@export_range(0.0, 380.0, 1.0) var y_komponente := 200.0: set = set_y_pos
@export_range(0.0, 2 * PI, 0.01) var start_rotation := 0.0: set = set_rot

func _ready() -> void:
	super ()
	set_color(PlatformColor.GROUND)
	set_y_pos(y_komponente)
	set_rot(start_rotation)
	#sprite.texture = PLATFORM_TEXTURES[PlatformColor.GROUND]
	
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	rotation += delta * GameManager.rot_spd

func set_y_pos(value: float) -> void:
	y_komponente = value
	if collision_shape_2d and sprite:
		collision_shape_2d.position.y = y_komponente
		sprite.position.y = y_komponente - height / 2

func set_rot(value: float) -> void:
	start_rotation = value
	rotation = start_rotation
