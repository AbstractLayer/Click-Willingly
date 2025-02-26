extends Node2D

@onready var lake_loop: PackedScene = preload("res://scenes/games_nodes/arbitrary_dino/objects/lake_loop.tscn")

@onready var first_path: StaticBody2D = %FirstPath
@onready var second_path: StaticBody2D = %SecondPath
@onready var dino_character: CharacterBody2D = %Dino_Character
@onready var dino_score: Label = %DinoScore
@onready var difficult_timer: Timer = %DifficultTimer
@onready var dino_game_over: Panel = %DinoGameOver
@onready var points_reward_label: Label = %PointsRewardLabel

signal is_physics_return
signal speedup_character

var resolution: int = 980
var lake_position: int = 965
var lake_limit_position: int = 1960

var is_dino_reach_path: bool = false
var is_first_path_changed_position: bool = false
var is_second_path_changed_position: bool = true

var score: int = 0
var score_difficult: int = 150
var min_lake: int = 200
var max_lake: int = 300

var is_demo_finished_button_pressed: bool = false

func _ready() -> void:
	set_physics_process(false)

func _physics_process(_delta: float) -> void:
	is_physics_return.emit()
	if dino_character.global_position.x >= resolution + 73 and is_dino_reach_path == false:
		is_dino_reach_path = true
	
	if is_dino_reach_path == true:
		if is_first_path_changed_position == false:
			first_path.global_position.x = resolution + 980
			is_first_path_changed_position = true
			is_second_path_changed_position = false
		if is_second_path_changed_position == false:
			second_path.global_position.x = resolution
			is_second_path_changed_position = true
			is_first_path_changed_position = false
		resolution += 980
		lake_limit_position += 980
		is_dino_reach_path = false
	
	if lake_position <= lake_limit_position:
		var instance_lake = lake_loop.instantiate()
		instance_lake.add_to_group("lakes")
		instance_lake.global_position = Vector2(lake_position, 219)
		instance_lake.connect("body_entered", _on_dino_entered)
		instance_lake.add_score.connect("body_entered", _on_dino_addscore)
		add_child(instance_lake)
		lake_position += Global.rng.randi_range(min_lake,max_lake)

func _on_dino_entered(body: Node2D):
	if body == dino_character:
		dino_character.set_physics_process(false)
		self.set_physics_process(false)
		dino_game_over.show()
		var reward: int = score + Global.store_data.arbitrary_dino_add_value
		points_reward_label.text = str("Reward: %d Score = %d Points" % [score, reward])
		await get_tree().create_timer(2).timeout
		Global.clicker_data.clicks_addiction += reward
		Global.is_adding_value = true
		
func _on_dino_addscore(body: Node2D):
	if body == dino_character:
		score += 50
	if score >= score_difficult:
		score_difficult += 300
		difficult_timer.start()
	dino_score.text = str("Score: %d" % [score])

func _on_difficult_timer_timeout() -> void:
	if not min_lake <= 100:
		for progressive_difficult in range(25):
			min_lake -= 1
	else:
		speedup_character.emit()
	difficult_timer.stop()

func _on_main_control_node_reset_game() -> void:
	dino_character.global_position = Vector2(73,204.8)
	var lakes_instances = get_tree().get_nodes_in_group("lakes")
	for lakes in lakes_instances:
		lakes.queue_free()
	first_path.global_position = Vector2.ZERO
	second_path.global_position = Vector2(981,0)
	score = 0
	dino_score.text = str("Score: %d" % [score])
	score_difficult = 150
	resolution = 980
	lake_position = 965
	lake_limit_position = 1960
	min_lake = 200
	max_lake = 300
	### FIXME: DEMO DEBUG
	if not is_demo_finished_button_pressed:
		is_demo_finished_button_pressed = true
		Global.is_demo_finished = true
