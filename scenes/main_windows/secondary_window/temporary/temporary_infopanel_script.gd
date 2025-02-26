extends GridContainer

@onready var config_panel: Panel = %ConfigPanel
@onready var you_panel: Panel = %YouPanel
@onready var info_panel: Panel = %InfoPanel
@onready var save_sprite: TextureButton = $SaveSprite

var is_timer_generatetext_end: bool = false

func _on_config_sprite_pressed() -> void:
	if not config_panel.visible:
		config_panel.show()
	else:
		config_panel.hide()


func _on_pc_sprite_pressed() -> void:
	if not you_panel.visible:
		you_panel.show()
	else:
		you_panel.hide()


func _on_info_sprite_pressed() -> void:
	if not info_panel.visible:
		info_panel.show()
	else:
		info_panel.hide()

func _on_save_sprite_pressed() -> void:
	### NOTE: Next release, Save Working
	text_temporary_preview(Vector2(175,0),str("not working yet"))

func text_temporary_preview(text_position: Vector2, label_text: String):
	var notworking_text: Label = Label.new()
	notworking_text.text = label_text
	notworking_text.position = text_position
	notworking_text.add_theme_constant_override("outline_size", 10)
	add_sibling(notworking_text)
	var animation_notworking_text: Tween
	animation_notworking_text = create_tween()
	animation_notworking_text.tween_property(notworking_text,"position",Vector2(175,-40),2.5)
	await get_tree().create_timer(1).timeout
	animation_notworking_text = create_tween()
	animation_notworking_text.tween_property(notworking_text,"visible_ratio",0,1)
	await animation_notworking_text.finished
	notworking_text.queue_free()
