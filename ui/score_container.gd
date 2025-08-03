class_name Score extends Control

@onready var energy_score_label: Label = %ScoreEnergyLabel
@onready var complete_score_label: Label = %ScoreCompleteLabel
@onready var life_score_label: Label = %ScoreLifeLabel
@onready var sum_score_label: Label = %ScoreSumLabel

@export var animation_duration := 3.0

var energy_score := 0.0
var comple_score := 0.0
var life_score := 0.0
var sum_score := 0.0

func set_score_label(label: Label, text: String, points: float) -> void:
    label.text = text + str(points * 10).pad_decimals(0) + " points"

func set_energy_score_label(points: float) -> void:
    energy_score_label.text = "Energy: " + str(points).pad_decimals(0) + " points"

func set_complete_score_label(points: float) -> void:
    complete_score_label.text = "Level complete: " + str(points).pad_decimals(0) + " points"

func set_life_score_label(points: float) -> void:
    life_score_label.text = "Remaining lifes: " + str(points).pad_decimals(0) + " points"

func set_sum_score_label(points: float) -> void:
    sum_score_label.text = "Score: " + str(points).pad_decimals(0) + " points"

func show_score_on_level_end(energy_bar: ProgressBar) -> void:
    var tween := create_tween()
    tween.tween_callback(func() -> void: energy_score_label.show())
    tween.tween_callback(func() -> void: sum_score_label.show())
    tween.tween_property(energy_bar, "value", 0.0, 3.0)
    tween.parallel().tween_method(set_energy_score_label, 0.0, energy_bar.value * 10, animation_duration)
    tween.parallel().tween_method(set_sum_score_label, 0.0, energy_bar.value * 10, animation_duration)
    sum_score = energy_bar.value * 10
    tween.tween_callback(func() -> void: complete_score_label.show())
    tween.tween_method(set_complete_score_label, 0.0, 300.0, animation_duration)
    tween.parallel().tween_method(set_sum_score_label, sum_score, sum_score + 300.0, animation_duration)
    sum_score += 300.0
    tween.tween_callback(func() -> void: life_score_label.show())
    tween.tween_method(set_life_score_label, 0.0, GameManager.lives * 200.0, animation_duration)
    tween.parallel().tween_method(set_sum_score_label, sum_score, sum_score + GameManager.lives * 200.0, animation_duration)
    sum_score += GameManager.lives * 200.0
