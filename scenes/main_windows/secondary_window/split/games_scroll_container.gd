extends ScrollContainer

@onready var first_split: VSplitContainer = %FirstSplit

var is_progress_context_purchased: bool = false

### FIXME: Ainda em implementação
#func _process(_delta: float) -> void:
	#if is_progress_context_purchased == true:
	#	if first_split.split_offset >= -1194:
	#		self.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_ALWAYS
	#	if first_split.split_offset <= -1194 and self.scroll_vertical == 0:
	#		self.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER


func _on_secondary_window_progress_context_purchased() -> void:
	is_progress_context_purchased = true
