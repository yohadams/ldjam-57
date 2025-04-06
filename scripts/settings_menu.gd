extends Control

@onready var music_slider := $Panel/HBoxContainer2/HBoxContainer/Music/HBoxContainer/HSlider
@onready var music_disable := $Panel/HBoxContainer2/HBoxContainer/Music/CheckBox

@onready var sfx_slider := $Panel/HBoxContainer2/HBoxContainer/SFX/HBoxContainer/HSlider
@onready var sfx_disable := $Panel/HBoxContainer2/HBoxContainer/SFX/CheckBox

@onready var remap_hand_left := $Panel/HBoxContainer2/VBoxContainer/remap_left
@onready var remap_hand_right := $Panel/HBoxContainer2/VBoxContainer/remap_right
@onready var remap_hop_left := $Panel/HBoxContainer2/VBoxContainer/remap_hop_left
@onready var remap_hop_right := $Panel/HBoxContainer2/VBoxContainer/remap_hop_right

@onready var go_back := $"Go back"

var is_remap_active = false
var is_mapping_left_hand = false
var is_mapping_right_hand = false
var is_mapping_left_hop = false 
var is_mapping_right_hop = false


func _ready():
	music_slider.value = db_to_percent(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	sfx_slider.value = db_to_percent(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	update_buttons_texts()

func _on_music_slider_drag_ended(value):
	print(value)
	var db = percent_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)


func _on_sfx_slider_drag_ended(value):
	var db = percent_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)


func _on_sfx_toggle_disabled(toggled_on):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), toggled_on)
	sfx_slider.editable = !toggled_on

func _on_music_disabled_toggle(toggled_on):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)
	music_slider.editable = !toggled_on
		
	
func db_to_percent(db):
	return clampf((db + 80.0) / 80.0 * 100.0, 0, 100)

func percent_to_db(p):
	return clampf((p / 100.0) * 80.0 - 80.0, -80, 0)


func _on_remap_left_pressed():
	if is_remap_active == false and is_mapping_left_hand == false:
		is_mapping_left_hand = true
		is_remap_active = true
		$Dialog.visible = true
	elif is_remap_active == true and is_mapping_left_hand == true:	
		is_mapping_left_hand = false
		is_remap_active = false


func _on_remap_right_pressed():
	if is_remap_active == false and is_mapping_right_hand == false:
		is_mapping_right_hand = true
		is_remap_active = true
		$Dialog.visible = true
	elif is_remap_active == true and is_mapping_right_hand == true:	
		is_mapping_right_hand = false
		is_remap_active = false


func _on_remap_hop_right_pressed():
	if is_remap_active == false and is_mapping_right_hop == false:
		is_mapping_right_hop = true
		is_remap_active = true
		$Dialog.visible = true
	elif is_remap_active == true and is_mapping_right_hop == true:	
		is_mapping_right_hop = false
		is_remap_active = false


func _on_remap_hop_left_pressed():
	if is_remap_active == false and is_mapping_left_hop == false:
		is_mapping_left_hop = true
		is_remap_active = true
		$Dialog.visible = true
	elif is_remap_active == true and is_mapping_left_hop == true:	
		is_mapping_left_hop = false
		is_remap_active = false

func return_active_input_mapping_key() -> String:
	if is_mapping_right_hop == true:
		return "right"
	elif is_mapping_left_hop == true:
		return "left"
	elif is_mapping_left_hand == true:
		return "left_hand"
	elif is_mapping_right_hand == true:
		return "right_hand"
	return ""

func deactivate_all_mappers():
	is_mapping_left_hand = false
	is_mapping_right_hand = false
	is_mapping_left_hop = false
	is_mapping_right_hop = false
	is_remap_active = false

func update_buttons_texts():
	remap_hand_left.text = "Remap left hand button current:  " + InputMap.action_get_events("left_hand")[0].as_text()
	remap_hand_right.text = "Remap right hand button current:  " + InputMap.action_get_events("right_hand")[0].as_text()
	remap_hop_left.text = "Remap hop right button current:  " + InputMap.action_get_events("left")[0].as_text()
	remap_hop_right.text = "Remap hop right button current:  " + InputMap.action_get_events("right")[0].as_text()
	
func _input(event):
	if is_remap_active and event is InputEventKey and event.pressed:
		var action = await return_active_input_mapping_key()
		print(action)
		print(is_mapping_left_hand,is_mapping_left_hop, is_mapping_right_hand, is_mapping_right_hop)
		assert(action != "", "Action should be never an empty string, something went wrong.")
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		deactivate_all_mappers()
		update_buttons_texts()
		$Dialog.visible = false


func _on_go_back_pressed():
	SceneManager.goto_menu()
