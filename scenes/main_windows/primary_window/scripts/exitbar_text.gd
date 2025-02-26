extends Label

# Variavel para armazena frases aleatorias que vão aparecer no exitbar
var exit_texts: Array[String] = ["GoodBye!", "See ya!", "See you next time!", "Tchau!"]
var exit_texts_final: Array[String] = ["GoodBye!", "See ya!", "See you next time!", "Tchau!"]

# Função para mostra o texto com a frase aleatoria
func change_exit_text(rand_exit_texts: Array[String]):
	self.text = str(rand_exit_texts[0])
