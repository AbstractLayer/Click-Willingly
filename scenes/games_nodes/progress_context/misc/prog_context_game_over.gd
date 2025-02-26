extends Panel

@onready var prog_context_start_game: Panel = %ProgContextStartGame
@onready var prog_context_game_it_self: Panel = %ProgContextGameItSelf

func _on_button_pressed() -> void:
	self.hide()
	prog_context_game_it_self.hide()
	prog_context_start_game.show()
