extends Panel

signal sold_button_pressed
#signal load_button_pressed

@onready var progress_gameitself: Panel = %ProgContextGameItSelf

@onready var race_checkbox: CheckBox = %Human
@onready var class_checkbox: CheckBox = %Warrior
@onready var sold_button: Button = %Sold_Button
@onready var unroll_button: Button = %Unroll_Button
@onready var name_edit: LineEdit = %Name_Edit
@onready var context_tab: TabContainer = %Context_Tab

@onready var stats_labels : Array = get_tree().get_nodes_in_group("Stats_Value")

var random_names_full : Array[String] = []

var old_stats: Array = []
var actually_stats: Array = []
var stats_count: int = 0

var is_roll_button_pressed = false
var is_name_empty = true

func _ready() -> void:
	stats_randomize()
	random_names_full = Global.progress_data.random_names.duplicate()
	Global.random_text_array(Global.progress_data.random_names, random_names_full)
	name_edit.text = str(Global.progress_data.random_names[0])
	
func _on_sold_button_pressed() -> void:
	var race_names = race_checkbox.button_group.get_pressed_button().name
	var class_names = class_checkbox.button_group.get_pressed_button().name
	
	Global.progress_data.name = name_edit.text
	Global.progress_data.race = race_names
	Global.progress_data.classes = class_names
	Global.progress_data.stats.append_array(actually_stats)
	Global.progress_data.context = context_tab.current_tab
	
	self.hide()
	sold_button_pressed.emit()
	progress_gameitself.show()

func _on_random_name_pressed() -> void:
	Global.random_text_array(Global.progress_data.random_names, random_names_full)
	name_edit.text = str(Global.progress_data.random_names[0])

func _on_roll_button_pressed() -> void:
	is_roll_button_pressed = true
	stats_randomize()

func _on_unroll_button_pressed() -> void:
	unroll_button.disabled = true
	if old_stats.size() == 6:
		for stats in stats_labels:
			stats.text = str(old_stats[stats_count])
			stats_count += 1
		stats_count = 0

func stats_randomize() -> void:
	if is_roll_button_pressed == true:
		old_stats = []
		old_stats.append_array(actually_stats)
		actually_stats = []
		is_roll_button_pressed = false
		unroll_button.disabled = false
	for stats in stats_labels:
		stats.text = str(Global.rng.randi_range(3,10))
		actually_stats.append(stats.get_text())

### WARNING: NOT IMPLEMENTED YET
#func _on_load_button_pressed() -> void:
	#load_progress_data(Save_Load_Resource.SAVE_PATH + Save_Load_Resource.SAVE_FILE_PATH)
	#self.hide()
	#load_button_pressed.emit()
	#progress_gameitself.show()

### WARNING: NOT IMPLEMENTED YET
#func load_progress_data(path: String):
#	if FileAccess.file_exists(path):
#		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, Save_Load_Resource.SECURITY_KEY)
#		if file == null:
#			print(FileAccess.get_open_error())
#			return
#		
#		var content = file.get_as_text()
#		file.close()
#		
#		var data = JSON.parse_string(content)
#		if data == null:
#			printerr("error parse")
#			return
#		
#		Global.progress_data.name = data.progress_data.name
#		Global.progress_data.race = data.progress_data.race
#		Global.progress_data.classes = data.progress_data.classes
#		Global.progress_data.stats.append_array(data.progress_data.stats)
#		Global.progress_data.character_atributes["Health"] = data.progress_data.Health
#		Global.progress_data.character_atributes["Max_Health"] = data.progress_data.Max_Health
#		Global.progress_data.character_atributes["Mana"] = data.progress_data.Mana
#		Global.progress_data.character_atributes["Max_Mana"] = data.progress_data.Max_Mana
#		Global.progress_data.character_atributes["Exp"] = data.progress_data.Exp
#		Global.progress_data.character_atributes["Exp_Max"] = data.progress_data.Exp_Max
#		Global.progress_data.character_atributes["Level"] = data.progress_data.Level
#		Global.progress_data.character_atributes["Gold"] = data.progress_data.Gold
#		
#	else:
#		printerr("imposibilitado de abrir um arquivo nao-existente em %s" % [path])
#	
