extends Label

# Onready Variables
@onready var modify_timer: Timer = %ModifyTimer
@onready var add_value_sfx: AudioStreamPlayer = %AddValueSFX

# Tween Variables
var text_animation_tween : Tween

# Função para mostra um texto pequeno de quanto sera modificado o valor do clicks
func _process(_delta: float) -> void:
	change_text_addiction(Global.clicker_data.clicks_addiction)

func change_text_addiction(text_addiction: int) -> void:
	self.text = "+" + str(text_addiction)

func _on_score_label_tween_finished() -> void:
	if text_animation_tween:
		text_animation_tween.kill()
	
	text_animation_tween = create_tween().set_parallel()
	text_animation_tween.tween_method(change_text_addiction,Global.clicker_data.clicks_addiction, 0, 2.0).set_trans(Tween.TRANS_EXPO)
	
	await get_tree().create_timer(0.5).timeout
	add_value_sfx.pitch_scale = Global.rng.randf_range(0.8,1.2)
	add_value_sfx.play()
	
	await text_animation_tween.finished
	Global.clicker_data.clicks_addiction = 0
