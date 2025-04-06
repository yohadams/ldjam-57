extends RigidBody2D

class_name FallingObsticle

func _physics_process(delta):
	if self.position.y >= 5000:
		self.queue_free()
