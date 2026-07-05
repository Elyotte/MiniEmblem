extends RefCounted
class_name GridEntity

## Sentinel meaning "not placed on the grid yet".
const UNPLACED_COORD := Vector2i(-1, -1)

var coordinate: Vector2i = UNPLACED_COORD

signal on_position_changed(coord: Vector2i)


func snap_to_grid() -> void:
	on_position_changed.emit(coordinate)


# Template method: bounds checking ALWAYS happens here and subclasses
# cannot skip it by overriding can_enter directly — they only get to
# extend the walkability rule via _is_walkable.
func can_enter(target: Vector2i) -> bool:
	if not GridManager.is_in_bounds(target):
		return false
	return _is_walkable(GridManager.get_cell(target))


# Override in subclasses to add entity-specific rules.
# Base rule: anything in bounds is walkable (e.g. PlayerCursor doesn't
# care about terrain or occupation).
func _is_walkable(_cell: CellInfo) -> bool:
	return true
