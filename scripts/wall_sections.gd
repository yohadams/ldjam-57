extends AnimatedSprite2D

class_name WallSection

@export var current_section = 1
@onready var spawners = [
	$SpawnerL,
	$SpawnerM,
	$SpawnerR
]

func _set_current_section(_section: int):
	current_section = _section


func _add_child_to_spawner(spawner_index: int, child):
	spawners.get(spawner_index).add_child(child)


func _process(delta):
	self.play(str(current_section))


func _set_shader_delta(_delta: float):
	print(_delta)
	self.material.set("shader_parameter/delta", _delta)
