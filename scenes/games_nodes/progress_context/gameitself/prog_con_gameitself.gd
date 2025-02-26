extends Panel

# StartGame Node
@onready var prog_context_start_game: Panel = %ProgContextStartGame

# GameOver Node
@onready var progress_gameover: Panel = %ProgContextGameOver

# Label/RichLabel Nodes
@onready var attributes_label: Label = %Attributes_Label
@onready var level_label: Label = %Level_Label
@onready var exp_label: Label = %Exp_Label
@onready var stats_value_label: Label = %Stats_Value_Label
@onready var inventory_rich_label: RichTextLabel = %Inventory_RichLabel
@onready var inv_qty_rich_label: Label = %Inv_Qty_RichLabel
@onready var equipament_rich_label: RichTextLabel = %Equipament_RichLabel
@onready var quest_rich_label: RichTextLabel = %Quest_RichLabel
@onready var skills_rich_label: RichTextLabel = %Skills_RichLabel
@onready var mp_skills_rich_label: RichTextLabel = %MP_Skills_RichLabel
@onready var encum_bar: ProgressBar = %Encum_Bar
@onready var exp_bar: ProgressBar = %Exp_Bar

# Progress GameItSelf Nodes
@onready var progress_center: ProgressBar = %ItSelf_Progress_Center
@onready var text_center: Label = %ItSelf_Progress_Label

# signals
signal state_finished

# State Machine variables
enum progress_states{
	INIT,
	KILL,
	REST,
	BUY,
	SELL,
	LOOK,
	WALK,
	CREATE,
	DESTROY,
	SECRET
}
var current_state := progress_states.INIT
var rotine_states := [progress_states.KILL, progress_states.REST, progress_states.BUY,
					progress_states.SELL, progress_states.LOOK, progress_states.WALK]

var final_kill_variants : Array[String]
var final_cruz_enemies : Array[String]
var final_cruz_places : Array[String]

# tween variables
var text_center_tween: Tween
var progress_center_tween: Tween

# int variables
var rand_result : int
var enemies_in_room : int
var gold_random: int
var encumbrance_max: int = 40

# bool variables
var is_sold_button_pressed : bool = false
var is_load_button_pressed : bool = false
var is_define_randomness : bool = false
var is_progress_animation_finished : bool = false
var is_started_game : bool = false

func _ready() -> void:
	final_cruz_places = Global.progress_data.cruz_places.duplicate()
	final_kill_variants = Global.progress_data.kill_variants.duplicate()
	final_cruz_enemies = Global.progress_data.cruz_enemies.duplicate()

func _process(_delta: float) -> void:
	if is_sold_button_pressed == true or is_load_button_pressed == true:
		attributes_label.text = str("Name: %s \nRace: %s \nClass: %s \nHP: %s     HP Max: %s \nMP: %s     MP Max: %s" %
							[Global.progress_data.name,Global.progress_data.race, Global.progress_data.classes,
							Global.progress_data.character_atributes["Health"], Global.progress_data.character_atributes["Max_Health"],
							Global.progress_data.character_atributes["Mana"],Global.progress_data.character_atributes["Max_Mana"]])
		stats_value_label.text = str("%d\n%d\n%d\n%d\n%d\n%d" %
							[int(Global.progress_data.stats[0]),int(Global.progress_data.stats[1]),int(Global.progress_data.stats[2]),
							int(Global.progress_data.stats[3]), int(Global.progress_data.stats[4]),int(Global.progress_data.stats[5])])
		level_label.text = str("Level: %d" % Global.progress_data.character_atributes["Level"])
		exp_label.text = str("Exp: %d/%d" % [Global.progress_data.character_atributes["Exp"], Global.progress_data.character_atributes["Exp_Max"]])
		inv_qty_rich_label.text = str("%d" % [Global.progress_data.character_atributes["Gold"]])
		encum_bar.value = Global.progress_data.character_atributes["Gold"]
		encum_bar.max_value = encumbrance_max
		exp_bar.value = Global.progress_data.character_atributes["Exp"]
		exp_bar.max_value = Global.progress_data.character_atributes["Exp_Max"]
		#equipament_rich_label.text = str("bracelete doido")
		#quest_rich_label.text = str("[ ]Prologue")
		#skills_rich_label.text = str("none")
		#mp_skills_rich_label.text = str("1")
		
		define_randomness()
		if not is_started_game:
			start_game()
			is_started_game = true
		

func start_game() -> void:
	while(Global.progress_data.character_atributes["Health"] > 0):
		match current_state:
			progress_states.INIT:
				_init_progress()
			progress_states.KILL:
				_kill_progress()
			progress_states.REST:
				_rest_progress()
			progress_states.BUY:
				_buy_progress()
			progress_states.SELL:
				_sell_progress()
			progress_states.LOOK:
				_look_progress()
			progress_states.WALK:
				_walk_progress()
		
		await state_finished
		if Global.progress_data.character_atributes["Exp"] >= Global.progress_data.character_atributes["Exp_Max"]:
			Global.progress_data.character_atributes["Exp"] = 0
			Global.progress_data.character_atributes["Level"] += 1
			Global.progress_data.character_atributes["Exp_Max"] += 250
			Global.progress_data.character_atributes["Max_Health"] += Global.rng.randi_range(4,8)
			Global.progress_data.character_atributes["Health"] = Global.progress_data.character_atributes["Max_Health"]
		if Global.progress_data.character_atributes["Health"] <= 6 and enemies_in_room != 0:
			current_state = progress_states.REST
		if Global.progress_data.character_atributes["Gold"] >= encumbrance_max and not current_state == progress_states.KILL:
			current_state = progress_states.BUY
	progress_gameover.show()

func define_randomness() -> void:
	if not is_define_randomness:
		for names in Global.progress_data.name.length():
			rand_result += 1
		for races in Global.progress_data.race.length():
			rand_result += 2
		for classes in Global.progress_data.classes.length():
			rand_result += 3
		
		for value in Global.progress_data.stats:
			match int(value):
				3,4:
					rand_result -= 2
				5,6:
					rand_result += 1
				7,8,9:
					rand_result += 2
				10:
					rand_result += 3
		
		Global.progress_data.character_atributes["Max_Health"] = Global.rng.randi_range(-40, 0) + rand_result
		Global.progress_data.character_atributes["Max_Mana"] = Global.rng.randi_range(-60, -20) + rand_result
		if Global.progress_data.character_atributes["Max_Health"] <= 6:
			Global.progress_data.character_atributes["Max_Health"] = 10
		if Global.progress_data.character_atributes["Max_Mana"] <= 6:
			Global.progress_data.character_atributes["Max_Mana"] = 10
		Global.progress_data.character_atributes["Health"] = Global.progress_data.character_atributes["Max_Health"]
		Global.progress_data.character_atributes["Mana"] = Global.progress_data.character_atributes["Max_Mana"]
		is_define_randomness = true

func main_animation_progress(main_text: String) -> void:
	if progress_center_tween:
		progress_center_tween.kill()
	if text_center_tween:
		text_center_tween.kill()
		
	progress_center_tween = create_tween()
	text_center_tween = create_tween()
	
	text_center_change(main_text)
	progress_center_animation()
	
func text_center_change(text: String) -> void:
	text_center.visible_ratio = 0
	text_center_animation()
	text_center.text = str(text)
	
func text_center_animation() -> void:
	text_center_tween.play()
	text_center_tween.tween_property(text_center,"visible_ratio",1,1)
	
func progress_center_animation() -> void:
	progress_center.value = 0
	progress_center_tween.play()
	progress_center_tween.tween_property(progress_center,"value",100,5)
	

#region Progress_States
func _init_progress() -> void:
	for init_text in Global.dialogs_data.progress_context_intro_cruz_dialogs.size():
		main_animation_progress(Global.dialogs_data.progress_context_intro_cruz_dialogs[init_text])
		await progress_center_tween.finished
	current_state = progress_states.WALK
	state_finished.emit()
	
func _walk_progress() -> void:
	Global.random_text_array(Global.progress_data.cruz_places, final_cruz_places)
	main_animation_progress(str("Walking into the %s") % [Global.progress_data.cruz_places[0]])
	await progress_center_tween.finished
	enemies_in_room = Global.rng.randi_range(2,4);
	main_animation_progress(str("You come across %d enemies") % [enemies_in_room])
	await progress_center_tween.finished
	current_state = progress_states.KILL
	state_finished.emit()

func _kill_progress() -> void:
	Global.random_text_array(Global.progress_data.kill_variants, final_kill_variants)
	Global.random_text_array(Global.progress_data.cruz_enemies, final_cruz_enemies)
	main_animation_progress(str("%s %s" % 
							[Global.progress_data.kill_variants[0], Global.progress_data.cruz_enemies[0]]))
	await progress_center_tween.finished
	enemies_in_room -= 1
	Global.progress_data.character_atributes["Health"] -= Global.rng.randi_range(1,10)
	Global.progress_data.character_atributes["Exp"] += Global.rng.randi_range(25,50)
	Global.progress_data.character_atributes["Gold"] += Global.rng.randi_range(1,3)
	if enemies_in_room == 0:
		current_state = progress_states.LOOK
	state_finished.emit()

func _rest_progress() -> void:
	main_animation_progress(str("You get some rest before the battle..."))
	await progress_center_tween.finished
	Global.progress_data.character_atributes["Health"] += Global.progress_data.character_atributes["Max_Health"] / 2
	if Global.progress_data.character_atributes["Health"] >= Global.progress_data.character_atributes["Max_Health"]:
		Global.progress_data.character_atributes["Health"] = Global.progress_data.character_atributes["Max_Health"]
	current_state = progress_states.KILL
	state_finished.emit()
	
func _buy_progress() -> void:
	### TODO: melhorar buy
	main_animation_progress(str("You find a place to keep your money..."))
	await progress_center_tween.finished
	var gold_multiply_add_value: int = Global.progress_data.character_atributes["Gold"] * Global.store_data.progress_context_add_value
	main_animation_progress(str("Depositing Gold... [%d Gold = %d Points]") % [Global.progress_data.character_atributes["Gold"], gold_multiply_add_value])
	Global.clicker_data.clicks_addiction += gold_multiply_add_value
	Global.progress_data.character_atributes["Gold"] = 0
	Global.is_adding_value = true
	await progress_center_tween.finished
	current_state = progress_states.WALK
	state_finished.emit()
	
func _sell_progress() -> void:
	### NOTE: Not Implemented Yet
	pass
	
func _look_progress() -> void:
	gold_random = Global.rng.randi_range(4,8)
	main_animation_progress(str("You look around the room and find %d gold") % [gold_random])
	await progress_center_tween.finished
	Global.progress_data.character_atributes["Gold"] += gold_random
	current_state = progress_states.WALK
	state_finished.emit()
	
#endregion

func _on_sold_button_pressed() -> void:
	is_sold_button_pressed = true

func _on_load_button_pressed() -> void:
	is_load_button_pressed = true

func _on_game_over_button_pressed() -> void:
	is_started_game = false
	is_sold_button_pressed = false
	is_define_randomness = false
	reset_game()
	self.hide()
	progress_gameover.hide()
	prog_context_start_game.show()

func reset_game() -> void:
	Global.progress_data.character_atributes["Health"] = 0
	Global.progress_data.character_atributes["Max_Health"] = 0
	Global.progress_data.character_atributes["Mana"] = 0
	Global.progress_data.character_atributes["Max_Mana"] = 0
	Global.progress_data.character_atributes["Level"] = 1
	Global.progress_data.character_atributes["Gold"] = 0
	Global.progress_data.character_atributes["Exp"] = 0
	Global.progress_data.character_atributes["Exp_Max"] = 250
	rand_result = 0
	encumbrance_max = 40
	
