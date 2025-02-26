extends Label

# Signal Variable
signal label_tween_finished

# Timer
@onready var modify_timer: Timer = %ModifyTimer

# Int Variables
var clicks_result_str: String

# Tween Variables
var label_tween: Tween

# Bool Variables
var is_click_add: bool = false
var is_click_sub: bool = false
var is_tween_run_onetime: bool = false

# Função que faz em tempo real os clicks aparecerem na hora que clickar
func _process(_delta: float) -> void:
	clicks_result_str = str(Global.clicker_data.clicks_result)
	self.text = clicks_result_str
	
# Função para fazer a animação da quantidade que voce tem no jogo
func text_change_animation():
	is_tween_run_onetime = true
	
	if label_tween:
		label_tween.kill()
	
	label_tween = create_tween().set_parallel(true)
	if is_click_sub == true and is_click_add == false:
		Global.clicker_data.clicks_modify += Global.clicker_data.clicks_subtraction
		Global.clicker_data.clicks_subtraction = 0
	
	if is_click_add == true and is_click_sub == false:
		label_tween_finished.emit()
		Global.clicker_data.clicks_modify += Global.clicker_data.clicks_addiction
	
	var clicks_cache: int = Global.clicker_data.clicks_modify + Global.clicker_data.clicks_result
	label_tween.tween_method(text_previous_animation, Global.clicker_data.clicks_result, clicks_cache,2.0).set_trans(Tween.TRANS_EXPO)
	
	is_tween_run_onetime = false
	is_click_sub = false
	is_click_add = false
	
	Global.clicker_data.clicks_result += Global.clicker_data.clicks_modify
	Global.clicker_data.clicks_modify = 0
	Global.store_data.store_debit = 0
	Global.is_adding_value = false
	Global.is_subtract_value = false

# Função para usar no tween_method() do text_change_animation()
# Serve para fazer a mudança dos numeros em tempo real
func text_previous_animation(add_value: float):
	self.text = str(add_value)

# Signal para acaba com o timer que faz a animação tocar
func _on_modify_timer_timeout() -> void:
	if Global.is_adding_value == true and Global.is_subtract_value == false:
		is_click_add = true
		if is_tween_run_onetime == false:
			text_change_animation()
	
	if Global.is_subtract_value == true:
		is_click_sub = true
		if is_tween_run_onetime == false:
			text_change_animation()
