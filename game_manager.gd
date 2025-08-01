extends Node

enum GameState {
	SPLASH_MENU,
	MAIN_MENU,
	GAME,
	END_MENU
}

var current_state: GameState


var scenes: Dictionary[GameState, PackedScene] = {
	GameState.SPLASH_MENU: preload("res://ui/splash_menu.tscn"),
	GameState.MAIN_MENU: preload("res://ui/main_menu.tscn"),
	GameState.GAME: preload("res://level/level1.tscn"),
	GameState.END_MENU: preload("res://ui/end_menu.tscn")
}

func change_state(new_state: GameState) -> void:
	current_state = new_state
	get_tree().change_scene_to_packed(scenes[new_state])
