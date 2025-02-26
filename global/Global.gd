extends Node

var clicker_data: Clicker_Resource = Clicker_Resource.new()
var progress_data: Progress_Resource = Progress_Resource.new()
var dialogs_data: Dialogs_Resource = Dialogs_Resource.new()
var store_data: Store_Resource = Store_Resource.new()

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var is_main_click_button_clicked = false
var is_adding_value: bool = false
var is_subtract_value: bool = false
var is_shaffled: bool = false
var is_dino_purchased: bool = false
var is_demo_finished: bool = false

func random_text_array(initial: Array[String], final: Array[String]) -> void:
	if not is_shaffled:
		initial.shuffle()
		is_shaffled = true
	
	if initial.size() == 1:
		initial.clear()
		initial.append_array(final)
		initial.shuffle()
		
	initial.pop_front()
	
