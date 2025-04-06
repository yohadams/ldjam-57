extends CanvasLayer

@onready var score_label: Label = $Panel/HBoxContainer/Score
@onready var left_label := $Panel/HBoxContainer/Left
@onready var right_label := $Panel/HBoxContainer/Right
@onready var speedbar := $SpeedBar

func _process(delta):
	if Global.Player.current_active_hand == Global.PlayerHands.LEFT:
		right_label.add_theme_color_override("font_color", Color(1, 1, 0))
	else:
		right_label.add_theme_color_override("font_color", Color(1, 1, 1))		
		
	if Global.Player.current_active_hand == Global.PlayerHands.RIGHT:
		left_label.add_theme_color_override("font_color", Color(1, 1, 0))
	else:
		left_label.add_theme_color_override("font_color", Color(1, 1, 1))
	
	score_label.set_text(str(Global.Score))
	speedbar.value = Global.Speed
