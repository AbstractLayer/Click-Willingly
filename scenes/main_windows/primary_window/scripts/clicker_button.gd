extends Sprite2D

# Onready Variables
@onready var tree_infest: Sprite2D = %TreeInfest
@onready var show_secondary_window: TextureButton = %ShowSecondaryWindow
@onready var animation_player_misc: AnimationPlayer = %AnimationPlayerMisc
@onready var click_audio: AudioStreamPlayer = %ClickAudio

# Bools Variables
var is_clicked_button: bool = false
var is_init_button_pressed: bool = false
var is_treeinfest_visible: bool = false

# Int Variables
var treeinfest_completed = 50

# Função para quando o botão for pressionado na imagem, aumenta 1 no click
# a diferença entre clicks e clicks_result é que o click sera para contabilizar
# somente os clicks e o result e os clicks junto com o click de modificação
func _input(event: InputEvent) -> void:
	if is_init_button_pressed == true:
		if event.is_action_pressed("Left_Button") and event.is_pressed():
			if is_pixel_opaque(get_local_mouse_position()):
				click_audio.pitch_scale = Global.rng.randf_range(0.6,1.4)
				click_audio.play()
				
				Global.is_main_click_button_clicked = true
				
				if not is_treeinfest_visible:
					tree_infest.show()
					is_treeinfest_visible = true
				
				if is_treeinfest_visible == true and Global.clicker_data.clicks <= treeinfest_completed:
					tree_infest.frame += 1
				
				self.frame = 1
				Global.clicker_data.clicks += 1
				Global.clicker_data.clicks_result += 1
		
		if event.is_action_released("Left_Button"):
			self.frame = 0

# Função para não bugar os clicks, ja que quando transiona mesmo assim o click
# Contabiliza
func _on_init_transition_is_queued_free() -> void:
	is_init_button_pressed = true
