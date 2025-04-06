extends Node2D
@onready var wall_group := $WallsGroup
@onready var wall_1 := $WallsGroup/Wall1 
@onready var wall_2 := $WallsGroup/Wall2 
@onready var wall_3 := $WallsGroup/Wall3 
@onready var wall_4 := $WallsGroup/Wall4 
@onready var wall_5 := $WallsGroup/Wall5 
@onready var wall_6 := $WallsGroup/Wall6 


func  _ready():
	Global._register_world_node(self)
	Global._register_wall_group(wall_group)
	Global._register_walls([
		wall_1,
		wall_2,
		wall_3,
		wall_4,
		wall_5,
		wall_6,
	])
	
	
func _input(event):
	if Global.Player.current_status != Global.PlayerStatus.ALIVE and Input.is_key_pressed(KEY_R):
		Global._restart_game()
		get_tree().reload_current_scene()
		Global.PlayerDeadDialog.visible = false
	if Global.Player.current_status != Global.PlayerStatus.ALIVE and Input.is_key_pressed(KEY_M):
		Global._restart_game()
		SceneManager.goto_menu()
		Global.PlayerDeadDialog.visible = false
