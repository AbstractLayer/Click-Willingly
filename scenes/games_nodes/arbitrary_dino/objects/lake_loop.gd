extends Area2D

@export var add_score: Area2D 

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("queuefreelakes"):
		self.queue_free()
