extends Panel

func _process(delta: float) -> void:
	if Global.is_demo_finished == true:
		self.show()

func _on_button_pressed() -> void:
	Global.is_demo_finished = false
	self.hide()
