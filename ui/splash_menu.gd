class_name Splash_Menu extends Control

@onready var animation: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
    animation.play("enter")
    animation.animation_finished.connect(func(_anim_name: String) -> void:
        GameManager.change_state(GameManager.GameState.MAIN_MENU)
    )
