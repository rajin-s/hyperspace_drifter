extends Component

export var max_speed_x : float = 4
export var min_speed_y : float = 1
export var max_speed_y : float = 8

var slow_time_active : bool = false
export var slow_time_scale : float = 0.25
export var slow_time_speed_scale : float = 2.0
onready var slow_time_active_timer : Timer = get_node("./Slow Time Active Timer")

onready var c_movement := get_component("movement_base")

func _process(delta) -> void:
	var viewport : Viewport = get_viewport()
	var viewport_size : Vector2 = viewport.get_visible_rect().size
	
	# Get raw mouse position (top left is origin)
	var mouse_input : Vector2 = viewport.get_mouse_position()
	
	# Convert pixel coordinates to normalized with -1 < x < 1, 0 < y < 1
	# (bottom center is origin)
	mouse_input = mouse_input / viewport_size
	mouse_input.x = clamp(mouse_input.x * 2 - 1, -1, 1)
	mouse_input.y = clamp(1 - mouse_input.y, 0, 1)
	
	# Get speed scale
	var speed_scale : float = 1.0
	if slow_time_active:
		speed_scale = 1.0 / Engine.time_scale / slow_time_speed_scale
	
	# Set internal velocity of player movement component
	c_movement.internal_velocity.x = max_speed_x * mouse_input.x * speed_scale
	c_movement.internal_velocity.y = lerp(min_speed_y, max_speed_y, mouse_input.y)
	
	if Input.is_action_pressed("player_slow_time"):
		m_globals.time_scale = slow_time_scale
		slow_time_active = true
		if slow_time_active_timer.is_stopped():
			slow_time_active_timer.start()
	else:
		if not slow_time_active_timer.is_stopped():
			slow_time_active_timer.stop()
		m_globals.time_scale = 1.0
		slow_time_active = false
		
# TODO: Move this somewhere else
func test_on_death():
	m_globals.restart()
func test_on_damage():
	print("Player damaged %d" % get_component_on($"../Model/Hitbox", "health").current_health)