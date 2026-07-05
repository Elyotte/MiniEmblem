extends GridEntity
class_name Unit

var unit_name: String
var max_stats: Dictionary[UnitStat.Type, int]
var current_stats: Dictionary[UnitStat.Type, int]
var _walk_rule: Dictionary[CellInfo.Type, bool]


func _init(stats_template: UnitStatsTemplate, p_unit_name: String) -> void:
	unit_name = p_unit_name
	max_stats = stats_template.get_stats()
	current_stats = max_stats.duplicate()  # Dictionaries are references too —
	# without duplicate(), current_stats and max_stats would be the SAME
	# dictionary and mutating one would silently mutate the other.
	_walk_rule = stats_template.get_walk_rule()


func _is_walkable(cell: CellInfo) -> bool:
	return _walk_rule.get(cell.type, false)
