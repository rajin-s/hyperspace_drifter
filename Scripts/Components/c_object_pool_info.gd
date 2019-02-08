extends Component

const reset_timer_path : String = "./Timer"

var _pool_available : bool = true
var reset_timer : Timer

signal pool_instantiate

func _ready() -> void:
	reset_timer = get_node(reset_timer_path)
	if reset_timer != null:
		# print("%s has timer" % object.name)
		reset_timer.connect("timeout", self, "set_pool_available")

func is_available() -> bool:
	return _pool_available
	
func set_pool_available() -> void:
	# print("call set_pool_available on %s" % object.name)
	_pool_available = true
	
func set_pool_unavailable() -> void:
	# print("Call set_pool_unavailable on %s" % (object.name if object != null else name))
	_pool_available = false
	if reset_timer != null:
		# print("Start timer on %s" % (object.name if object != null else name))
		reset_timer.start()