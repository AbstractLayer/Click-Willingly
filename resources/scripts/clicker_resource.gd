extends Resource
class_name Clicker_Resource

# Clicks = Clicks pelo jogador
# Clicks_modify = Clicks modificado pelo jogo
# Clicks_result = Resultado entre clicks e a modificação
# O resto é adição, subtração, multiplicação e divisão dos clicks
@export var clicks : int
@export var clicks_modify : int
@export var clicks_result: int
@export var clicks_addiction: int
@export var clicks_subtraction: int
@export var clicks_multiply: int
@export var clicks_division: int

func sub_clicks():
	clicks_modify = clicks - clicks_subtraction
	clicks_result = clicks_modify
	return clicks_modify

func multi_clicks():
	clicks *= clicks_multiply
func division_clicks():
	clicks /= clicks_division
