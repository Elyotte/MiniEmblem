extends GridEntity
class_name PlayerCursor

@export var moveCooldown: float = 0.15
var move_timer: float = 0.0

signal cell_selected(coords: Vector2i)
signal cursor_moved(coords: Vector2i)

var selectedUnit : Unit

func _ready() -> void:
	if levelGrid == null:
		push_error("PlayerCursor: levelGrid is not assigned in the inspector!")
		return
	snap_to_grid()

func _process(delta: float) -> void:
	if levelGrid == null:
		return
	handle_movement_input(delta)
	handle_selection_input()

func handle_movement_input(delta: float) -> void:
	move_timer -= delta
	if move_timer > 0.0:
		return
	
	var input_dir: Vector2i = Vector2i.ZERO
	if Input.is_action_pressed("right"):
		input_dir.x += 1
	elif Input.is_action_pressed("left"):
		input_dir.x -= 1
	elif Input.is_action_pressed("down"):
		input_dir.y += 1
	elif Input.is_action_pressed("up"):
		input_dir.y -= 1
	
	if input_dir != Vector2i.ZERO:
		try_move(input_dir)
		move_timer = moveCooldown

func try_move(direction: Vector2i) -> void:
	var target: Vector2i = coordinate + direction
	if not can_enter(target):
		return
	coordinate = target
	snap_to_grid()
	cursor_moved.emit(coordinate)

func handle_selection_input() -> void:
	if Input.is_action_just_pressed("selectUnit"):
		if (selectedUnit == null):
			cell_selected.emit(coordinate)
			var lCell : CellInfo = levelGrid.get_cell(coordinate)
			if (lCell.is_occupied()):
				print("Unit selected!")
				selectedUnit = lCell.unit
				selectedUnit.modulate = Color.BISQUE
		elif(selectedUnit == levelGrid.get_cell(coordinate).unit):
			selectedUnit.modulate = Color.WHITE	
			selectedUnit = null
		else:
			if(levelGrid.move_unit(selectedUnit, coordinate)):
				selectedUnit.modulate = Color.WHITE	
				selectedUnit = null

# PlayerCursor doesn't care about occupation — it can hover over units
# (base GridEntity.can_enter is enough, no override needed here)
