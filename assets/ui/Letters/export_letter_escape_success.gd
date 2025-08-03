extends Node2D
func _ready():
	# Script wird automatisch beim Start ausgeführt
	Viewport.transparent_bg = true
	export_with_viewport()
	
func export_with_viewport():
	# SubViewport erstellen
	var sub_viewport = SubViewport.new()
	sub_viewport.size = Vector2i(1920, 1080)  # Gewünschte Auflösung
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	add_child(sub_viewport)
	
	# Deine Szene zum Viewport hinzufügen
	var scene_instance = preload("res://assets/ui/Letters/letter_escape_success.tscn").instantiate()
	sub_viewport.add_child(scene_instance)
	
	# Animation exportieren (ähnlich wie Methode 1)
	# ...
	
	# Viewport wieder entfernen
	#sub_viewport.queue_free()
