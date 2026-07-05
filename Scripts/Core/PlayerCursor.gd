extends GridEntity
class_name PlayerCursor

@export var move_cooldown: float = 0.15
var move_timer: float = 0.0

signal on_cell_selected(coord: Vector2i)

var selected_unit: Unit


func try_move(direction: Vector2i) -> void:
	var target := coordinate + direction
	if not can_enter(target):
		return
	coordinate = target
	on_position_changed.emit(coordinate)


func handle_selection_input() -> void:
	# NOTE: "selectUnit" kept as-is — it's an Input Map action name (project
	# config), not a code identifier, so it's outside the snake_case
	# convention we applied to scripts. Rename it in the Input Map too if
	# you want full consistency.
	if not Input.is_action_just_pressed("selectUnit"):
		return

	var cell := GridManager.get_cell(coordinate)
	if cell == null:
		return

	if selected_unit == null:
		on_cell_selected.emit(coordinate)
		if cell.is_occupied():
			selected_unit = cell.unit
	elif selected_unit == cell.unit:
		selected_unit = null
	elif GridManager.try_place(selected_unit, coordinate):
		selected_unit = null

# PlayerCursor doesn't care about occupation — it can hover over units.
# Base GridEntity._is_walkable (always true) is enough, no override needed.
