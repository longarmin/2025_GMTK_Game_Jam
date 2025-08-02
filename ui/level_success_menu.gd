class_name LevelSuccessMenu extends Control

@onready var continue_button: Button = %ContinueButton
@onready var exit_game_button: Button = %ExitGameButton

func _ready() -> void:
    continue_button.pressed.connect(func() -> void:
        GameManager.change_level()
    )
    exit_game_button.pressed.connect(func() -> void:
        get_tree().quit()
    )
