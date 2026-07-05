extends Node
 
# Autoload (Project Settings > Autoload > name it "GridManager").
# Owns the grid data. No visuals, no scene-tree singleton hacks.
#
# class_name is declared here on purpose even though this is also the
# autoload name: without it, GDScript's static type checker can't see this
# script's API on the global singleton identifier and infers plain `Node`,
# which is exactly the error you hit.
 
var _bounds: Rect2i = Rect2i()
var _cells: Dictionary = {}  # Vector2i -> CellInfo
var _hasSetup : bool = false
 
 
# Called once by GridTerrain._ready() with the tilemap's used rect.
# A Dictionary keyed by Vector2i replaces the old flat-array + index math:
# no more coord_to_index, and negative used_rect origins just work.
func setup(bounds: Rect2i) -> void:
	if(_hasSetup):
		push_warning("Has already been setup")
		return
	_bounds = bounds
	_cells.clear()
	for x in range(bounds.position.x, bounds.position.x + bounds.size.x):
		for y in range(bounds.position.y, bounds.position.y + bounds.size.y):
			_cells[Vector2i(x, y)] = CellInfo.new()
 
 
func set_cell_type(coord: Vector2i, type: CellInfo.Type) -> void:
	var cell := get_cell(coord)
	if cell != null:
		cell.type = type
 
 
func is_in_bounds(coord: Vector2i) -> bool:
	return _bounds.has_point(coord)
 
 
func get_cell(coord: Vector2i) -> CellInfo:
	return _cells.get(coord)
 
 
func is_occupied(coord: Vector2i) -> bool:
	var cell := get_cell(coord)
	return cell != null and cell.is_occupied()
 
 
# The ONLY function allowed to place or move a unit on the grid.
# Handles both "first placement" and "move" the same way, which is what
# removes the place_unit/move_unit duplication (and the precedence bug)
# from the old version.
func try_place(unit: Unit, target: Vector2i) -> bool:
	if not unit.can_enter(target):
		return false
 
	var target_cell := get_cell(target)
	if target_cell == null or target_cell.is_occupied():
		return false
 
	var previous_cell := get_cell(unit.coordinate)
	if previous_cell != null and previous_cell.unit == unit:
		previous_cell.unit = null
 
	target_cell.unit = unit
	unit.coordinate = target
	unit.on_position_changed.emit(target)
	return true
