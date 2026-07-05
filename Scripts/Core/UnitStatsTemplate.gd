@tool
extends Resource
class_name UnitStatsTemplate

enum Type { HP, Strength, Speed, Defense, Technique }

@export_tool_button("Add missing keys")
var add_missing_action: Callable = _fill_missing_keys

@export_tool_button("Reset")
var reset_action: Callable = _reset_walk_rules

@export var walk_rules: Dictionary[CellInfo.Type, bool] = {}

@export var hp : int = 10
@export var strength : int = 6
@export var speed : int = 5
@export var defense : int = 3
@export var technique : int = 5

func get_stats() -> Array[int] :
	var lStats : Array[int] = [hp, strength, speed, defense, technique]
	return lStats

func get_walk_rule() -> Dictionary[CellInfo.Type, bool] :
	return walk_rules.duplicate_deep()
	

func _init() -> void:
	print("Unit stat template created")
	for type_value in CellInfo.Type.values():
		if not walk_rules.has(type_value):
			walk_rules[type_value] = false

func _fill_missing_keys() -> void:
	for type_value in CellInfo.Type.values():
		if not walk_rules.has(type_value):
			walk_rules[type_value] = false
	notify_property_list_changed()

func _reset_walk_rules() -> void:
	walk_rules.clear()
	for type_value in CellInfo.Type.values():
		walk_rules[type_value] = false
	notify_property_list_changed()
