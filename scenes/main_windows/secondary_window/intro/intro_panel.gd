extends Panel

@onready var intro_rich_button: RichTextLabel = %IntroRichButton
@onready var intro_start_button: Button = %IntroStartButton
@onready var boos_infestation_sprite: Sprite2D = %BoostInfestationSprite

var total_pass: int = 50
var clicks_count: int = 51

func _ready() -> void:
	self.show()

func _process(_delta: float) -> void:
	intro_rich_button.text = str("[shake rate=20.0 level=10 connected=1][center][color=c49e45]Remain [color=red]%d" % [total_pass])
	if Global.clicker_data.clicks >= clicks_count:
		if Global.is_main_click_button_clicked == true:
			Global.is_main_click_button_clicked = false
			total_pass -= 1
			if not boos_infestation_sprite.frame == 44:
				boos_infestation_sprite.frame += 1
	if total_pass <= 0:
		total_pass = 0
		intro_start_button.disabled = false
		
func _on_intro_start_button_pressed() -> void:
	self.queue_free()
