extends Button

# botão para teste logo irei remove-lo
# @experimental
func _on_button_down() -> void:
	Global.clicker_data.clicks_addiction += 100
	print(Global.clicker_data.clicks_addiction)
