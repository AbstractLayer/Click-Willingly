extends VSlider

var SFX = AudioServer.get_bus_index("Master")

func _ready() -> void:
	self.value = db_to_linear(SFX)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX,linear_to_db(value))
