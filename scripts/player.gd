extends Area2D

class_name PlayerEntity
@onready var spawner_l := $SpawnerL
@onready var spawner_m := $SpawnerM
@onready var spawner_r := $SpawnerR

@onready var dead_dialog := $DeadPanel
@onready var score := $DeadPanel/Score

@onready var sprite := $Collision/Sprite
@onready var player := $Collision
@onready var camera := $Camera2D
@onready var sound := $Bum
@onready var music := $Music

const NEXT_HAND_TIMEOUT = .2
const HAND_ANIMATION_TIMEOUT = 0.1
const LEFT_RIGHT_MOVMENT_TIMEOUT = 0.15

var hand_lock = false

func _ready():
	Global._register_player(self)
	Global._register_player_camera(camera)
	Global._register_spawners([
		spawner_l,
		spawner_m,
		spawner_r
	])
	Global._register_dead_dialog(dead_dialog)
	music.play()


func _process(delta):
	if Global.Player.current_status == Global.PlayerStatus.ALIVE:
		if Global.Player.current_active_hand == Global.PlayerHands.LEFT:
			sprite.play("left_hand")
		elif Global.Player.current_active_hand == Global.PlayerHands.RIGHT:
			sprite.play("right_hand")
		
		var tween = create_tween()
		tween.tween_property(player, "position:x", Global.Player.current_line, LEFT_RIGHT_MOVMENT_TIMEOUT)
	elif Global.Player.current_status == Global.PlayerStatus.FALLING:
		score.text = str(Global.Score)
		dead_dialog.visible = true
		sprite.play("fall")
		flash_white()
		Global.Player.current_status == Global.PlayerStatus.DIED
		Global.Speed = 0
		var tween = create_tween()
		tween.tween_property(player, "position:y", 1008, 1)
		music.stop()

func _input(event):
	if Global.Player.current_status == Global.PlayerStatus.ALIVE:
		var tween = create_tween()
		var hand_speed = NEXT_HAND_TIMEOUT - (Global.Speed * 0.01)
		if event.is_action_pressed("left_hand") and hand_lock == false:
			if Global.Player.current_active_hand == Global.PlayerHands.LEFT:
				return
			else:
				hand_lock = true
				Global.Player.current_active_hand = Global.PlayerHands.LEFT
				#tween.tween_property(self, "position:y", Global.PlayerY.M, HAND_ANIMATION_TIMEOUT)
				await Global._process_next_to_next_wall_section()
				#tween.tween_property(self, "position:y", Global.PlayerY.B, HAND_ANIMATION_TIMEOUT)
				await get_tree().create_timer(NEXT_HAND_TIMEOUT).timeout
				Global._add_score(Global.BASE_SCORE)
				Global._increment_speed()
				sound.play()
				hand_lock = false
				
		if event.is_action_pressed("right_hand") and hand_lock == false:
			if Global.Player.current_active_hand == Global.PlayerHands.RIGHT:
				return
			else:
				hand_lock = true
				Global.Player.current_active_hand = Global.PlayerHands.RIGHT
				#tween.tween_property(self, "position:y", Global.PlayerY.M, HAND_ANIMATION_TIMEOUT)
				await Global._process_next_to_next_wall_section()
				#tween.tween_property(self, "position:y", Global.PlayerY.B, HAND_ANIMATION_TIMEOUT)
				await get_tree().create_timer(NEXT_HAND_TIMEOUT).timeout
				Global._add_score(Global.BASE_SCORE)
				Global._increment_speed()
				sound.play()
				hand_lock = false
				
		if event.is_action_pressed("left"):
			if Global.Player.current_line == Global.PossibleLines.L:
				return
			elif Global.Player.current_line == Global.PossibleLines.M:
				Global.Player.current_line = Global.PossibleLines.L
			else:
				Global.Player.current_line = Global.PossibleLines.M
		
		if event.is_action_pressed("right"):
			if Global.Player.current_line == Global.PossibleLines.R:
				return
			elif Global.Player.current_line == Global.PossibleLines.M:
				Global.Player.current_line = Global.PossibleLines.R
			else:
				Global.Player.current_line = Global.PossibleLines.M

func flash_white():
	var tween = create_tween()
	await tween.tween_property(sprite, "modulate", Color(0, 0, 0, 1), 0.5)
	

func _on_body_entered(body):
	print(body)
	Global.Player.current_status = Global.PlayerStatus.FALLING
