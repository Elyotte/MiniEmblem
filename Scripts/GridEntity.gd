extends Node2D
class_name GridEntity

@export var levelGrid: LevelGrid
var coordinate: Vector2i = Vector2i(0, 0)

func snap_to_grid() -> void:
	if levelGrid == null:
		push_error("%s: levelGrid is not assigned in the inspector!" % name)
		return
	global_position = levelGrid.get_pos_on_grid(coordinate.x, coordinate.y)

# Base rule: must be in bounds and walkable.
# Override this in subclasses to add entity-specific rules
# (e.g. Unit blocks on occupied cells, PlayerCursor doesn't care).
func can_enter(target: Vector2i) -> bool:
	if levelGrid == null or not levelGrid.is_in_bounds(target):
		return false
	var cell: CellInfo = levelGrid.get_cell(target)
	return true
