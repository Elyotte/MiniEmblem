@tool
extends Resource
class_name UnitStatsTemplate

@export_tool_button("Add missing keys")
var add_missing_action: Callable = _fill_missing_keys

@export_tool_button("Reset")
var reset_action: Callable = _reset_template

@export var walk_rules: Dictionary[CellInfo.Type, bool] = {}
@export var stats: Dictionary[UnitStat.Type, int] = {}


func _init() -> void:
	_fill_missing_keys()


# Returns a copy — callers must not be able to mutate the template's own
# data through the reference they get back.
func get_stats() -> Dictionary[UnitStat.Type, int]:
	return stats.duplicate()


func get_walk_rule() -> Dictionary[CellInfo.Type, bool]:
	return walk_rules.duplicate_deep()


func _fill_missing_keys() -> void:
	for type_value in CellInfo.Type.values():
		if not walk_rules.has(type_value):
			walk_rules[type_value] = false

	for stat_type in UnitStat.Type.values():
		if not stats.has(stat_type):
			stats[stat_type] = 5

	notify_property_list_changed()


func _reset_template() -> void:
	walk_rules.clear()
	stats.clear()
	_fill_missing_keys()
