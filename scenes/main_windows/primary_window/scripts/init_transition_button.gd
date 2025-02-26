extends Sprite2D

@onready var anim_init_transition: AnimationPlayer = %AnimationPlayerInitTransition
@onready var intro_sfx: AudioStreamPlayer = %IntroSFX

var is_introsfx_play_onetime: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Left_Button") and event.is_pressed():
		if is_pixel_opaque(get_local_mouse_position()):
			self.frame = 1
			if is_introsfx_play_onetime == false:
				intro_sfx.play()
				is_introsfx_play_onetime = true
			
			await get_tree().create_timer(0.5).timeout
			anim_init_transition.play("Start_Transition")
