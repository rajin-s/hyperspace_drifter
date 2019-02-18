extends Spatial

export var radius : float = 3
export var speed : float = 1
export var lerp_speed : float = 3
export var destroy_delay : float = 0.1

var time : float = 0
var delay_timer : Timer

func _process(delta):
	time += delta
	var child_count : int = get_child_count()
	for i in child_count:
		var child : Spatial = get_child(i) as Spatial
		var target_angle : float = (float(i) / float(child_count) * PI * 2) + (time * speed * (PI / 180))
		var target_local_position : Vector3 = Vector3(cos(target_angle) * radius, 0, sin(target_angle) * radius)
		child.transform.origin = child.transform.origin.linear_interpolate(target_local_position, delta * lerp_speed)

func fire_all() -> void:
	for i in get_child_count():
		get_child(i).get_node("Combat").shoot()

func destory_all() -> void:
	delay_timer = Timer.new()
	get_parent().add_child(delay_timer)
	delay_timer.wait_time = destroy_delay
	delay_timer.connect("timeout", self, "destroy_one")
	delay_timer.start()

func destroy_one() -> void:
	if get_child_count() > 0:
		get_child(0).get_node("Hitbox/Health").damage(999)
	else:
		delay_timer.queue_free()