extends HSplitContainer

func _on_dragged(offset: int) -> void:
	if offset < -300:
		self.split_offset = -300
	if offset > 330:
		self.split_offset = 330
