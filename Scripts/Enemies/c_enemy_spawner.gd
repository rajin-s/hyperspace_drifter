extends Component

export var spawn_height_offset : float = 18

export var max_time : float = 60 * 3
export var difficulty_over_time : Curve
export var min_count : int = 3
export var max_count : int = 10
export var count_over_difficulty : Curve

export(Array, PackedScene) var enemy_prefabs = []
export(Array, Curve) var enemy_spawn_chances = []
var enemy_pools : Array = []

onready var spawn_timer : Timer = $"Spawn Timer"
onready var wave_timer : Timer = $"Wave Timer"
onready var difficulty_timer : Timer = $"Difficulty Timer"

#var difficulty : float = 0
#var time : float = 0
var left_in_wave : int = 0

func disable() -> void:
	spawn_timer.stop()

func _ready() -> void:
	for enemy in enemy_prefabs:
		enemy_pools.append(m_globals.try_add_pool(enemy))
	
	wave_timer.connect("timeout", self, "start_wave")
	spawn_timer.connect("timeout", self, "try_spawn")
	difficulty_timer.connect("timeout", self, "increase_difficulty")
	
	m_globals.connect("game_over", self, "disable")

func _process(delta : float) -> void:
	m_globals.spawning.time += delta

func start_wave() -> void:
	var wave_count : int = ceil(lerp(min_count, max_count, count_over_difficulty.interpolate(m_globals.spawning.difficulty)))
	left_in_wave = wave_count

func spawn_one() -> void:
	var spawn_position := Vector3(m_globals.player.enemy_target.x, m_globals.player.enemy_target.y + spawn_height_offset, 0)
	
	# Spawn something based on chances (fall through from last to first=100%)
	for i in len(enemy_prefabs):
		var index : int = len(enemy_prefabs) - 1 - i
		var spawn_chance : float = enemy_spawn_chances[index].interpolate(m_globals.spawning.difficulty)
		
		if rand_range(0.0, 1.0) <= spawn_chance:
			enemy_pools[index].get_instance_as_child_at(object, spawn_position)
			break

func try_spawn() -> void:
	if left_in_wave > 0:
		spawn_one()
		left_in_wave -= 1

func increase_difficulty() -> void:
	m_globals.spawning.difficulty = difficulty_over_time.interpolate(clamp(m_globals.spawning.time / max_time, 0, 1))