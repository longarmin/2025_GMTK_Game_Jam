class_name Escape extends Area2D

func _ready() -> void:
    body_entered.connect(func(body: Node2D) -> void:
        if body is Player:
            GameManager.change_state(GameManager.GameState.LEVEL_SUCCESS)
    )
