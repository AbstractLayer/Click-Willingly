extends Panel

@onready var progress_friend_button: Button = %ProgressFriendButton
@onready var progress_friend_value: RichTextLabel = %Progress_Friend_Value
@onready var progress_friend_quantity: RichTextLabel = %Progress_Friend_Quantity
@onready var progress_add_value: RichTextLabel = %Progress_Add_Value
@onready var progress_context_button: Button = %ProgressContextButton
@onready var progress_context_quantity: RichTextLabel = %Progress_Context_Quantity
@onready var progress_context_value: RichTextLabel = %Progress_Context_Value
@onready var arbitrary_dino_button: Button = %ArbitraryDinoButton
@onready var arbitrary_dino_quantity: RichTextLabel = %ArbitraryDino_Quantity
@onready var arbitrary_dino_value: RichTextLabel = %ArbitraryDino_Value
@onready var soon: Panel = %Soon

var debit_cache: int

func _ready() -> void:
	Global.store_data.progress_friend_value = 100
	Global.store_data.progress_context_value = 750
	Global.store_data.arbitrary_dino_value = 1000
	progress_context_button.hide()
	arbitrary_dino_button.hide()
	soon.hide()
	
func _process(_delta: float) -> void:
	debit_cache = Global.clicker_data.clicks_result + Global.clicker_data.clicks_subtraction
	
	disable_when_noscore(Global.store_data.progress_friend_value, progress_friend_button)
	disable_when_noscore(Global.store_data.progress_context_value, progress_context_button)
	disable_when_noscore(Global.store_data.arbitrary_dino_value, arbitrary_dino_button)
	
	update_button(progress_friend_value, progress_friend_quantity, progress_add_value,
					Global.store_data.progress_friend_value,
					Global.store_data.progress_friend_quantity,
					Global.store_data.progress_friend_add_value)
	update_button(progress_context_value, progress_context_quantity, null,
					Global.store_data.progress_context_value,
					Global.store_data.progress_context_quantity,
					Global.store_data.progress_context_add_value)
	update_button(arbitrary_dino_value, arbitrary_dino_quantity, null,
					Global.store_data.arbitrary_dino_value, 
					Global.store_data.arbitrary_dino_quantity,
					Global.store_data.arbitrary_dino_add_value)
	
	if Global.store_data.progress_friend_quantity >= 3:
		progress_context_button.show()
	
	### FIXME: tirar quando tiver pronto
	if Global.store_data.progress_context_quantity >= 1:
		arbitrary_dino_button.show()
		%Soon.show()

func disable_when_noscore(value: int, button: Button):
	if debit_cache < value:
		button.disabled = true
	else:
		button.disabled = false

func update_button(label_value: RichTextLabel, label_quantity: RichTextLabel, label_add_value: RichTextLabel,
				   value: int, quantity: int, add_value: int):
	label_value.text = str("[center][color=202020]Value\n[color=600000]%d" %
						[value])
	label_quantity.text = str("[center][color=404040]%d" % [quantity])
	
	if label_add_value != null:
		label_add_value.text = str("[center][color=black]%d" % [add_value])
	else:
		return
