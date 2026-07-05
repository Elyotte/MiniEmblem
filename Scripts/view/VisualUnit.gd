extends Node2D
class_name VisualUnit

var _unit: Unit
var _terrain: GridTerrain


func initialize(unit: Unit, terrain: GridTerrain) -> void:
	_unit = unit
	_terrain = terrain
	_unit.on_position_changed.connect(_match_position)
	_match_position(_unit.coordinate)


func _match_position(coord: Vector2i) -> void:
	position = _terrain.get_world_pos_from_coord(coord)
