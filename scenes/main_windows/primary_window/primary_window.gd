@icon("res://assets/textures/icon/icon.png")
extends Control

# Signals
signal is_queued_free

# AnimationPlayers
@onready var anim_exitbar: AnimationPlayer = %AnimationPlayerExitBar
@onready var anim_init_transition: AnimationPlayer = %AnimationPlayerInitTransition
@onready var animation_player_misc: AnimationPlayer = %AnimationPlayerMisc

# Init transition
@onready var init_transition_button: Sprite2D = %InitTransitionButton
@onready var init_transition_panel: Panel = %InitTransitionPanel

# ExitBar
@onready var exitbar_node: VBoxContainer = %ExitBarVbox
@onready var exit_text: Label = %ExitbarText

# On/Off secondary window show
@onready var on_window_texture: Texture = load("res://assets/textures/primary_window/on_window.png")
@onready var off_window_texture: Texture = load("res://assets/textures/primary_window/off_window.png")

# SecondaryWindow
@onready var show_secondary_window: TextureButton = %ShowSecondaryWindow
@onready var secondary_viewport: Window = %SecondaryViewPort
@onready var second_window_show_audio: AudioStreamPlayer = %SecondWindowShowAudio

# Move primary window
var mouse_start: Vector2i
var is_window_moving : bool = false

# Bool Variables
var is_show_window: bool = false
var is_secondary_window_show: bool = false
var is_sound_playing_onetime : bool = false

# Int Variables
var treeinfest_completed: int = 50

func _ready() -> void:
	# Show init transition nodes
	init_transition_button.show()
	init_transition_panel.show()

func _process(_delta: float) -> void:
	# ExitBar
	if is_window_moving:
		anim_exitbar.play("RESET")
		var mouse_now : Vector2i = Vector2i(get_viewport().get_mouse_position())
		get_window().position += mouse_now - mouse_start
		
	# TreeInfest
	if Global.clicker_data.clicks == treeinfest_completed and not is_secondary_window_show:
		animation_player_misc.play("transition_show_secondary")
		show_secondary_window.show()
		
		await animation_player_misc.animation_finished
		animation_player_misc.play("flash_show_secondary")
		is_secondary_window_show = true
		show_secondary_window.disabled = false

#region ExitBar
# Signal para quando o mouse chega perto ele toca a animação de descer
# randomizando as frases que aparecem a cada vez que ela toca
func _on_margin_exitbar_mouse_entered() -> void:
	Global.random_text_array(exit_text.exit_texts, exit_text.exit_texts_final)
	exit_text.change_exit_text(exit_text.exit_texts)
	exitbar_node.show()
	anim_exitbar.queue("SlideDown")
	
# Signal para quando o mouse sair toca a animação para cima
func _on_margin_exitbar_mouse_exited() -> void:
	if not is_window_moving:
		anim_exitbar.play("SlideUp")
		await get_tree().create_timer(0.5).timeout
		exitbar_node.hide()

# Signal para detectar quando o mouse esta pressionando a exitbar
func _on_margin_exitbar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if not is_window_moving:
			mouse_start = get_viewport().get_mouse_position()
		is_window_moving = event.is_pressed()
		
#endregion

#region ChangeTextureSecondaryWindowButton
# Signal para quando o botão for pressionado ele aparece a janela do jogo
func _on_texture_change_button_down() -> void:
	animation_player_misc.stop()
	if not is_show_window and animation_player_misc.animation_finished:
		secondary_viewport.show()
		if is_sound_playing_onetime == false:
			second_window_show_audio.play()
			is_sound_playing_onetime = true
		show_secondary_window.texture_normal = on_window_texture
		is_show_window = true
	else:
		secondary_viewport.hide()
		show_secondary_window.texture_normal = off_window_texture
		is_show_window = false

func _on_secondary_view_port_close_requested() -> void:
	secondary_viewport.hide()
	show_secondary_window.texture_normal = off_window_texture
	is_show_window = false
#endregion

#region InitAnimationPlayer
func _on_animation_player_init_transition_finished(anim_name: StringName) -> void:
	if anim_name == "Start_Transition":
		is_queued_free.emit()
		init_transition_button.queue_free()
		init_transition_panel.queue_free()
		anim_init_transition.queue_free()
#endregion

#region MinimizedButton
func _on_minimized_button_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
#endregion
