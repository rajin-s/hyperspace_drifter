extends Component

export var max_speed_x : float = 4
export var min_speed_y : float = 1
export var max_speed_y : float = 8

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
	
	# Set internal velocity of player movement component
	c_movement.internal_velocity.x = max_speed_x * mouse_input.x
	c_movement.internal_velocity.y = lerp(min_speed_y, max_speed_y, mouse_input.y)