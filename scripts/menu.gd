extends Control

func _process(delta):
	$VBoxContainer/Depths.material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
	$VBoxContainer/HBoxContainer/HELL.material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)


func _on_play_button_pressed():
	SceneManager.goto_game()


func _on_config_pressed():
	SceneManager.goto_settings()


func _on_how_pressed():
	SceneManager.goto_how_to()
