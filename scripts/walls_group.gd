extends Node2D

func _remove_last_child():
	var children = self.get_children()
	self.remove_child(children.pop_front())
