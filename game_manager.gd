extends Node

enum GameState {
	SPLASH_MENU,
	MAIN_MENU,
	GAME,
	LEVEL_SUCCESS,
	DIED_MENU,
	END_MENU
}

var current_state: GameState
var rot_spd: float = -0.2
var current_level := 0


var scenes: Dictionary[GameState, PackedScene] = {
	GameState.SPLASH_MENU: preload("res://ui/splash_menu.tscn"),
	GameState.MAIN_MENU: preload("res://ui/main_menu.tscn"),
	GameState.LEVEL_SUCCESS: preload("res://ui/level_success_menu.tscn"),
	GameState.DIED_MENU: preload("res://ui/died_menu.tscn"),
	GameState.END_MENU: preload("res://ui/end_menu.tscn")
}

var levels: Array[PackedScene] = [
	preload("res://level/Level_easy.tscn"),
	preload("res://level/Level_golden_ratio.tscn"),
	preload("res://level/level_chaos.tscn"),
	preload("res://level/level_dog.tscn"),
]

func change_state(new_state: GameState) -> void:
	current_state = new_state
	if current_state == GameState.LEVEL_SUCCESS:
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

func change_level() -> void:
	get_tree().change_scene_to_packed(levels[current_level])
	current_level += 1
