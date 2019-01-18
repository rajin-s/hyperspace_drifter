tool
extends Particles

export var do_x : bool = true
export var do_y : bool = true
export var do_z : bool = true

func _process(delta) -> void:
	self.rotate_object_local(Vector3.UP, rand_range(0, 360))