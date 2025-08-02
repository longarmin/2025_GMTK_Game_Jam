@tool

extends Sprite2D

@onready var max_rot_angle : float = 0.5 * randf()
@onready var max_rot_freq : float = randf()
@onready var max_scale_y: float = (randf() + randf())/8
@onready var max_scale_x: float = (randf() + randf())/8
@onready var t: float = 0.0

func _ready():
	# Shader-Material erstellen und zuweisen
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://ui/lettershader.gdshader")
	self.material = shader_material
	
	# Parameter anpassen
	shader_material.set_shader_parameter("outline_width", 2.0)
	shader_material.set_shader_parameter("outline_color", Color(0.9, 0.75, 0.75))
	
	# Falls du den komplexen Shader mit Schatten verwendest:
	shader_material.set_shader_parameter("shadow_color", Color(0.25, 0.125, 0.375))
	shader_material.set_shader_parameter("shadow_offset", Vector2(2, 2))
	shader_material.set_shader_parameter("enable_shadow", true)

func _process(delta: float) -> void:
	t += delta
	rotation = max_rot_angle * sin(10*t*max_rot_freq)
	scale.x = max_scale_x * cos(10*t*max_rot_freq + max_scale_x) + 0.7
	scale.y = max_scale_y * cos(10*t*max_rot_freq + max_scale_y) + 0.7
