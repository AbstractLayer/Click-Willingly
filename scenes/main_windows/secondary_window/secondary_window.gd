extends Control

signal progress_context_purchased

# Onready Variables
@onready var main_progress_panel: Panel = %MainProgressPanel
@onready var progress_text: RichTextLabel = %ProgressText
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var progress_context_panel: Control = %ProgressContextPanel
@onready var arbitrary_dino_sub_view_port: SubViewportContainer = %ArbitraryDinoSubViewPort
@onready var arbitrary_dino: Node2D = %ArbitraryDino
@onready var first_split: VSplitContainer = %FirstSplit
@onready var first_separator: HSeparator = %FirstSeparator
@onready var second_separator: HSeparator = %SecondSeparator
@onready var third_separator: HSeparator = %ThirdSeparator

# Tweens Variables
var text_tween: Tween
var progress_tween: Tween
var store_tween: Tween

# Bool Variables
var run_intro_dialog: bool = false

# Função em tempo real para tocar as animações primarias do jogo, cada um
# com um dialogo diferente
func _process(_delta: float) -> void:
	if Global.store_data.progress_friend_quantity >= 1 and run_intro_dialog == false:
		run_intro_dialog = true
		main_progress_panel.show()
		
		for intro_dialogs in Global.dialogs_data.progress_friend_intro_dialogs.size():
			progress_friend_animation(Global.dialogs_data.progress_friend_intro_dialogs[intro_dialogs])
			await progress_tween.finished
			Global.clicker_data.clicks_addiction += Global.store_data.progress_friend_add_value
		
		while Global.store_data.progress_context_quantity < 1:
			for idle_dialogs in Global.dialogs_data.progress_friend_idle_dialogs.size() - 1:
				progress_friend_animation(Global.dialogs_data.progress_friend_idle_dialogs[idle_dialogs])
				await progress_tween.finished
				Global.clicker_data.clicks_addiction += Global.store_data.progress_friend_add_value
				if Global.store_data.progress_context_quantity >= 1:
					break
			if not Global.store_data.progress_context_quantity >= 1:
				progress_friend_animation(Global.dialogs_data.progress_friend_idle_dialogs[5])
				await progress_tween.finished
				Global.clicker_data.clicks_addiction += Global.store_data.progress_friend_add_value
			else:
				break
		
		for context_dialogs in Global.dialogs_data.progress_friend_context_purchased_dialogs.size():
			progress_friend_animation(Global.dialogs_data.progress_friend_context_purchased_dialogs[context_dialogs])
			await progress_tween.finished
			Global.clicker_data.clicks_addiction += Global.store_data.progress_friend_add_value
		
		while Global.store_data.arbitrary_dino_quantity < 1:
			for idle_dialogs in Global.dialogs_data.progress_friend_idle_dialogs.size() - 1:
				progress_friend_animation(Global.dialogs_data.progress_friend_idle_dialogs[idle_dialogs])
				await progress_tween.finished
				Global.clicker_data.clicks_addiction += Global.store_data.progress_friend_add_value
				if Global.store_data.arbitrary_dino_quantity >= 1:
					break
			if not Global.store_data.arbitrary_dino_quantity >= 1:
				progress_friend_animation(Global.dialogs_data.progress_friend_idle_dialogs[5])
				await progress_tween.finished
				Global.clicker_data.clicks_addiction += Global.store_data.progress_friend_add_value
			else:
				break
		
		for arbitrary_dino_dialogs in Global.dialogs_data.progress_friend_dino_purchased_dialogs.size():
			progress_friend_animation(Global.dialogs_data.progress_friend_dino_purchased_dialogs[arbitrary_dino_dialogs])
			await progress_tween.finished
			Global.clicker_data.clicks_addiction += Global.store_data.progress_friend_add_value
			
		while Global.store_data.soon_item <= 1:
			for idle_dialogs in Global.dialogs_data.progress_friend_idle_dialogs.size() - 1:
				progress_friend_animation(Global.dialogs_data.progress_friend_idle_dialogs[idle_dialogs])
				await progress_tween.finished
				Global.clicker_data.clicks_addiction += Global.store_data.progress_friend_add_value
			progress_friend_animation(Global.dialogs_data.progress_friend_idle_dialogs[5])
			await progress_tween.finished
			Global.clicker_data.clicks_addiction += Global.store_data.progress_friend_add_value
		
#region MainAnimationProgressFriend
# Função main para todas as animações tocarem de forma sicronizada
func progress_friend_animation(main_text: String):
	# Condicionais para quando um tween acaba ele poder iniciar outro sem erros
	if text_tween:
		text_tween.kill()
	
	if progress_tween:
		progress_tween.kill()
	
	# Criação dos Tweens
	text_tween = create_tween().set_parallel()
	progress_tween = create_tween().set_parallel()
	# Text_change = Dialogo, Progress_bar = barra de carregamento
	text_change(main_text)
	progress_bar_animation()
#endregion

#region ProgressFriendTweenMethods
# Função que faz o texto sumir e aparecer como se ele fosse escrito
func text_change(text: String):
	progress_text.visible_ratio = 0
	text_change_animation()
	progress_text.text = str(text)

# Função para o texto tocar a animação de forma fluida para o text_change
func text_change_animation() -> void:
	text_tween.play()
	text_tween.tween_property(progress_text,"visible_ratio",1,2)

# Função para a barra de carregamento ir de forma fluida
func progress_bar_animation():
	progress_bar.value = 0
	progress_tween.play()
	progress_tween.tween_property(progress_bar,"value",100,7)
	Global.is_adding_value = true

#endregion

#region StorePurchased

func _on_progress_friend_button_pressed() -> void:
	main_progress_panel.show()
	first_separator.show()
	Global.is_subtract_value = true
	Global.store_data.store_purchased_quantity += 1
	Global.store_data.store_debit -= Global.store_data.progress_friend_value
	Global.clicker_data.clicks_subtraction = Global.store_data.store_debit
	Global.store_data.progress_friend_value += 100
	Global.store_data.progress_friend_quantity += 1
	Global.store_data.progress_friend_add_value += 15

func _on_progress_context_button_pressed() -> void:
	progress_context_panel.show()
	second_separator.show()
	progress_context_purchased.emit()
	first_split.split_offset = -675
	Global.is_subtract_value = true
	Global.store_data.store_purchased_quantity += 1
	Global.store_data.store_debit -= Global.store_data.progress_context_value
	Global.clicker_data.clicks_subtraction = Global.store_data.store_debit
	Global.store_data.progress_context_value += 1000
	Global.store_data.progress_context_quantity += 1
	Global.store_data.progress_context_add_value += 30

func _on_arbitrary_dino_button_pressed() -> void:
	arbitrary_dino_sub_view_port.show()
	arbitrary_dino.show()
	third_separator.show()
	Global.is_dino_purchased = true
	Global.is_subtract_value = true
	Global.store_data.store_purchased_quantity += 1
	Global.store_data.store_debit -= Global.store_data.arbitrary_dino_value
	Global.clicker_data.clicks_subtraction = Global.store_data.store_debit
	Global.store_data.arbitrary_dino_value += 2000
	Global.store_data.arbitrary_dino_quantity += 1
	Global.store_data.arbitrary_dino_add_value += 100
#endregion
