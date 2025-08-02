extends Node

enum GameState {
	SPLASH_MENU,
	MAIN_MENU,
	GAME,
	LEVEL_SUCCESS,
	DIED_MENU,
	END_MENU
}

const STANDARD_ROT_SPD: float = -0.2
var current_state: GameState
var rot_spd: float = -0.2: set = change_rot_speed
var current_level := 0
var lives := 3: set = change_live
var levels: Array[PackedScene] = []


func _ready() -> void:
	load_levels()


var scenes: Dictionary[GameState, PackedScene] = {
	GameState.SPLASH_MENU: preload("res://ui/splash_menu.tscn"),
	GameState.MAIN_MENU: preload("res://ui/main_menu.tscn"),
	GameState.LEVEL_SUCCESS: preload("res://ui/level_success_menu.tscn"),
	GameState.DIED_MENU: preload("res://ui/died_menu.tscn"),
	GameState.END_MENU: preload("res://ui/end_menu.tscn")
}


func load_levels() -> void:
	var level_dir := "res://level/game"
	var dir := DirAccess.open(level_dir)
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				var scene_path := level_dir + "/" + file_name
				var scene := load(scene_path) as PackedScene
				if scene:
					levels.append(scene)
			file_name = dir.get_next()
		dir.list_dir_end()


func change_state(new_state: GameState) -> void:
	current_state = new_state
	if current_state == GameState.LEVEL_SUCCESS:
		change_state(GameState.END_MENU)
		if current_level >= levels.size():
			change_state(GameState.END_MENU)
			return
	if current_state == GameState.GAME:
		print("GameState")
		if current_level <= levels.size():
			print("Levels")
			change_level()
			return
	get_tree().change_scene_to_packed(scenes[new_state])

func _input(event: InputEvent) -> void:
	# Zwecks Debugging und Testing
	if event.is_action_pressed("speed_up"):
		rot_spd -= 0.1
	elif event.is_action_pressed("speed_down"):
		rot_spd += 0.1

	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene()

func change_level() -> void:
	if current_level < levels.size():
		get_tree().change_scene_to_packed(levels[current_level])
		current_level += 1
	else:
		change_state(GameState.END_MENU)

func change_live(new_value) -> void:
	lives = new_value
	if lives <= 0:
		change_state(GameState.DIED_MENU)

func change_rot_speed(new_value) -> void:
	rot_spd = new_value
	rot_spd = clampf(rot_spd, -1.0, 6.0)
