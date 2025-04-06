extends Node

@onready var static_hole: PackedScene = preload("res://entities/static_summoning_circle.tscn")

@onready var falling_rock: PackedScene = preload("res://entities/falling_rock.tscn")
@onready var falling_barrel: PackedScene = preload("res://entities/falling_barrel.tscn")
@onready var falling_bible: PackedScene = preload("res://entities/falling_bible.tscn")
@onready var falling_fork: PackedScene = preload("res://entities/falling_fork.tscn")
@onready var falling_anvil: PackedScene = preload("res://entities/falling_anvil.tscn")
@onready var falling_boots: PackedScene = preload("res://entities/falling_boots.tscn")
@onready var falling_skeleton: PackedScene = preload("res://entities/falling_skeleton.tscn")

const NUMBER_OF_OBSTICLES = 7 - 1

@onready var wall_section: PackedScene = preload("res://entities/wall_sections.tscn")

enum PlayerHands {LEFT, RIGHT}
#enum PossibleLines {L = 165, M = 327, R = 487}
enum PossibleLines {L = -180, M = 0, R = 180}
enum PlayerY {B = 1000, M = 950}
enum PlayerStatus {ALIVE, FALLING, DIED}
var PlayerCamera = null
var PlayerObject: PlayerEntity = null
var Player := {
	"current_active_hand": PlayerHands.LEFT,
	"current_line": PossibleLines.M,
	"current_status": PlayerStatus.ALIVE
}
var PlayerDeadDialog = null

const WALL_HEIGHT = 288
var WallGroup: Node2D = null 
var Walls: Array[WallSection] = []
var Spawners = []

enum WallsPositions {FIRST = 1008, SECOND = 720, THIRD = 432, FOURTH = 144, FIFTH = -144, SIXTH = -432}

func _get_obsticle(index: int) -> PackedScene:
	if index == 0:
		return falling_rock
	elif index == 1:
		return falling_barrel
	elif index == 2:
		return falling_bible
	elif index == 3:
		return falling_fork
	elif  index == 4:
		return falling_anvil
	elif  index == 5:
		return falling_boots
	elif  index == 6:
		return falling_skeleton
			
	assert(true, "You triet to get obsticle that dont exist")
	return falling_rock
var WorldNode = null

func _register_world_node(_world_node):
	WorldNode = _world_node

func _register_player_camera(_player_camera):
	PlayerCamera = _player_camera
		
func _register_player(_player):
	PlayerObject = _player	

func _register_walls(_walls: Array[WallSection]):
	Walls = _walls

func _register_spawners(_spawners):
	Spawners = _spawners

func _register_wall_group(_wall_group: Node2D):
	WallGroup = _wall_group
	
func _register_dead_dialog(_dead_dialog: Panel):
	PlayerDeadDialog = _dead_dialog

var next_wall = 3
var next_wall_position = (DisplayServer.window_get_size().y - (WALL_HEIGHT / 2)) - (6 * WALL_HEIGHT) + 1
var current_step := 1

func _process_next_to_next_wall_section():
	var tween = create_tween()
	#ten tween
	tween.tween_property(PlayerObject, "position:y", PlayerObject.position.y - (WALL_HEIGHT*0.75-50), 0.3)
	#WallGroup.position.y = WallGroup.position.y + WALL_HEIGHT
	var new_wall = await wall_section.instantiate()
	new_wall._set_current_section(next_wall) 
	new_wall.position.x = 324
	new_wall.position.y = next_wall_position
	
	# add new wall section
	WallGroup.add_child(new_wall)
	if Score >= 100:
		var new_red: float = (Score/500.0)/75.0;
		new_wall._set_shader_delta(new_red)
	
	#new_wall._add_child_to_spawner(0, static_hole.instantiate())
	next_wall += 1
	next_wall_position -= WALL_HEIGHT
	if next_wall >= 5:
		next_wall = 1
	
	if current_step % 10 == 0:
		WallGroup._remove_last_child()
	
	if Score >= 6000:
		if current_step % 1 == 0:
			print("spawn % 1")
			await _spawn_normal_obsticle()
	elif Score >= 400:
		if current_step % 2 == 0:
			print("spawn % 2")
			await _spawn_normal_obsticle()
	else:
		if current_step % 4 == 0:
			print("spawn % 4")
			await _spawn_normal_obsticle()
		
		
	current_step += 1
	return true
	
func _spawn_normal_obsticle(excluded_spawner: int = -1) -> Array[int]:
	var choosen_obsticle = randi_range(0, NUMBER_OF_OBSTICLES)
	var choosen_spawner = randi_range(0,2)
	var random_obsticle: PackedScene = await _get_obsticle(choosen_obsticle)
	var spawner: Node2D = Spawners.get(choosen_spawner)
	assert(random_obsticle.can_instantiate(),  "Random obsticle is invalid and cant instantiate")
	assert(spawner, "Choosen spawner is null")
	spawner.add_child(random_obsticle.instantiate())
	return [choosen_spawner, choosen_obsticle]
	
func _process(delta):
	#print(delta)
	pass
	
const BASE_SCORE := 1
var Score: int = 0

func _add_score(_score: int):
	Score += _score + Speed
	
var Speed = 0
const MaxSpeed = 20

func _increment_speed():
	var delta = Speed + 1
	if delta <= MaxSpeed:
		Speed = delta

var speed_down_timer: Timer

func _ready():
	speed_down_timer = Timer.new()
	speed_down_timer.wait_time = 0.8
	speed_down_timer.one_shot = false
	speed_down_timer.autostart = true
	add_child(speed_down_timer)

	speed_down_timer.timeout.connect(_on_speed_down_timer_timeout)
	speed_down_timer.start()

func _on_speed_down_timer_timeout():
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_input_time <= 0.3:
		return  # użytkownik kliknął A lub D niedawno – nie zwalniamy

	if Speed > 0:
		Speed -= 1


var last_input_time := 0.0
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("right_hand") or event.is_action_pressed("left_hand"):
			last_input_time = Time.get_ticks_msec() / 1000.0


func _restart_game():
	Player = {
		"current_active_hand": PlayerHands.LEFT,
		"current_line": PossibleLines.M,
		"current_status": PlayerStatus.ALIVE
	}
	PlayerCamera = null
	PlayerObject = null

	Score = 0
	Speed = 0
	current_step = 1
	next_wall = 3
	next_wall_position = (DisplayServer.window_get_size().y - (WALL_HEIGHT / 2)) - (6 * WALL_HEIGHT) + 1

	WallGroup = null
	Walls.clear()
	Spawners.clear()
	WorldNode = null

	# Reset timer: usuń stary jeśli był
	if speed_down_timer:
		speed_down_timer.stop()
		speed_down_timer.queue_free()

	# Stwórz nowy timer
	speed_down_timer = Timer.new()
	speed_down_timer.wait_time = 0.8
	speed_down_timer.one_shot = false
	speed_down_timer.autostart = true
	add_child(speed_down_timer)
	speed_down_timer.timeout.connect(_on_speed_down_timer_timeout)
	speed_down_timer.start()
