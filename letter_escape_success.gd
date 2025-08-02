extends Node2D
# Im Inspector oder per Code:
var sprite = $Sprite2D
var material = ShaderMaterial.new()
material.shader = load("res://ui/lettershader.gdshader")
sprite.material = material

# Parameter anpassen:
material.set_shader_parameter("outline_width", 2.0)
material.set_shader_parameter("outline_color", Color(0.75, 0.75, 0.75))
