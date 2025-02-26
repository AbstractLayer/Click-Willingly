extends Button

# Função para quando aperta o botão de sair do exitbar, sair do jogo
func _on_button_down() -> void:
	get_tree().quit()
