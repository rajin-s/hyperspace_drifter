extends Spatial

var t : float
func _process(delta):
	t += delta
	self.transform.origin = Vector3(cos(t), 0, 0) * 10