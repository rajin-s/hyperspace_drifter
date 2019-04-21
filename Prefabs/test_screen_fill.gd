extends Sprite

func _ready():
	center()
	get_viewport().connect("size_changed", self, "center")
	
func center():
	self.position = get_viewport().size / 2