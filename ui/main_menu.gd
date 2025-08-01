class_name MainMenu extends Control

@onready var start_button: Button = %StartButton
@onready var controls_button: Button = %ControlsButton
@onready var controls_exit_button: Button = %ControlsExitButtonButton
@onready var controls_container: MarginContainer = %ControlsContainer

func _ready() -> void:
	controls_container.hide()

	start_button.pressed.connect(func() -> void:
		GameManager.change_state(GameManager.GameState.GAME)
	)
	controls_button.pressed.connect(func() -> void:
		controls_container.show()
	)
	controls_exit_button.pressed.connect(func() -> void:
		controls_container.hide()
	)
