extends MeshInstance

export var gradient : Gradient

func _ready():
	self.material_override = SpatialMaterial.new()
	self.material_override.albedo_color = gradient.interpolate(rand_range(0.0, 1.0))