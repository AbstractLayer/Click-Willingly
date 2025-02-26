extends Control

signal reset_game

@onready var dino: TextureRect = %Dino
@onready var bandeira: TextureRect = %Bandeira
@onready var dino_game_itself: Node2D = %DinoGameItself
@onready var dino_menu: Panel = %DinoMenu
@onready var start_remove_points: Label = %StartRemovePoints
@onready var dino_game_over: Panel = %DinoGameOver

var cost_to_play: int

var dino_tween: Tween
var bandeira_tween: Tween

var is_dino_run_onetime: bool = false
var is_start_button_pressed: bool = false

func _process(_delta: float) -> void:
	if Global.is_dino_purchased == true:
		if not is_dino_run_onetime:
			is_dino_run_onetime = true
			dino_animation()
		
		### FIXME: Não implementado
		#cost_to_play = int(Global.store_data.arbitrary_dino_value / 15)
		#start_remove_points.text = str("Cost: %d Points" % [cost_to_play])
		
func _on_button_pressed() -> void:
	is_start_button_pressed = true
	if dino_tween:
		dino_tween.kill()
	if bandeira_tween:
		dino_tween.kill()
	dino_menu.visible = false
	dino_game_itself.set_physics_process(true)
	
func dino_animation() -> void:
	dino_tween = create_tween().set_loops()
	bandeira_tween = create_tween().set_loops()
	dino_tween.tween_property(dino,"rotation_degrees",25.5,0.5)
	dino_tween.tween_property(dino,"rotation_degrees",-25.5,0.5)
	bandeira_tween.tween_property(bandeira,"global_position",Vector2(570,30),0.5)
	bandeira_tween.tween_property(bandeira,"global_position",Vector2(570,59),0.5)

func _on_return_menu_button_pressed() -> void:
	dino_menu.show()
	dino_game_over.hide()
	reset_game.emit()
