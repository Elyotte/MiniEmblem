extends GridEntity
class_name PlayerCursor

@export var moveCooldown: float = 0.15
var move_timer: float = 0.0

signal on_cell_selected(coords: Vector2i)
signal on_cursor_moved(coords: Vector2i)

var selectedUnit : Unit

func try_move(direction: Vector2i) -> void:
	var target: Vector2i = coordinate + direction
	if not can_enter(target):
		return
	coordinate = target
	snap_to_grid()
	print(coordinate)
	on_cursor_moved.emit(coordinate)

func handle_selection_input() -> void:
	if Input.is_action_just_pressed("selectUnit"):
		print(coordinate)
		if (selectedUnit == null):
			on_cell_selected.emit(coordinate)
			var lCell : CellInfo = m_LevelGrid.get_cell(coordinate)
			if (lCell.is_occupied()):
				print("Unit selected!")
				selectedUnit = lCell.unit
		elif(selectedUnit == m_LevelGrid.get_cell(coordinate).unit):
			selectedUnit = null
		else:
			if(m_LevelGrid.move_unit(selectedUnit, coordinate)):
				print("moved")
				selectedUnit = null

# PlayerCursor doesn't care about occupation — it can hover over units
# (base GridEntity.can_enter is enough, no override needed here)
