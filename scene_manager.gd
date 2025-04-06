extends Node


const GAME = "res://world.tscn"
const MENU = "res://menu/menu.tscn"
const SETTINGS = "res://menu/settings_menu.tscn"
const HOWTO =  "res://menu/how_to.tscn"

func goto_menu():
	get_tree().change_scene_to_file(MENU)

func goto_game():
	get_tree().change_scene_to_file(GAME)
	
func goto_settings():
	get_tree().change_scene_to_file(SETTINGS)

func goto_how_to():
	get_tree().change_scene_to_file(HOWTO)
