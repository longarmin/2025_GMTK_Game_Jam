class_name EndMenu extends Control

@onready var main_menu_button: Button = %MainMenuButton
@onready var exit_game_button: Button = %ExitGameButton

func _ready() -> void:
	main_menu_button.pressed.connect(func() -> void:
		GameManager.change_state(GameManager.GameState.MAIN_MENU)
	)
	exit_game_button.pressed.connect(func() -> void:
		get_tree().quit()
	)
