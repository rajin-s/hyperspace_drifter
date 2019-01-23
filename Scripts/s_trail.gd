extends ImmediateGeometry

export var lifetime : float = 1
export var width_curve : CurveTexture
export var color_gradient : GradientTexture

var left_points : Array = []
var right_points : Array = []
var point_lifetimes : Array = []

func _process(delta : float) -> void:
	update_lifetimes(delta)
	update_points()
	draw_trail()

func update_lifetimes(delta : float) -> void:
	for i in len(point_lifetimes):
		point_lifetimes[i] += delta / lifetime

func update_points() -> void:
	# 
	pass

func draw_trail():
	pass