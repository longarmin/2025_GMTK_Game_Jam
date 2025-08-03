class_name Hud extends Control

@export var player: Player

@onready var energy_bar: ProgressBar = %EnergyProgressBar

func _ready() -> void:
    player.energy_changed.connect(func(energy: float) -> void:
        energy_bar.value = energy
    )
