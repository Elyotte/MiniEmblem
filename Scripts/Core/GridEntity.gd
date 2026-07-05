extends RefCounted
class_name GridEntity

var m_LevelGrid: LevelGrid
var coordinate: Vector2i = Vector2i(0, 0)

signal on_set_position

func _init(pGrid : LevelGrid):
	m_LevelGrid = pGrid

func snap_to_grid() -> void:
	if m_LevelGrid == null:
		push_error("%s: m_LevelGrid is not assigned in the inspector!")
		return
	on_set_position.emit([coordinate])

# Base rule: must be in bounds and walkable.
# Override this in subclasses to add entity-specific rules
# (e.g. Unit blocks on occupied cells, PlayerCursor doesn't care).
func can_enter(target: Vector2i) -> bool:
	if m_LevelGrid == null or not m_LevelGrid.is_in_bounds(target):
		return false
	var cell: CellInfo = m_LevelGrid.get_cell(target)
	return true
