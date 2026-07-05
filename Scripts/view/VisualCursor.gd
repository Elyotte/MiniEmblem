extends Node2D
class_name VisualCursor

var _cursor : PlayerCursor
var _grid : LevelGrid

func initialize(p_cursor: PlayerCursor) ->void:
	_cursor = p_cursor
	_cursor.on_cursor_moved.connect(match_pos)
	_grid = _cursor.m_LevelGrid
	match_pos(_cursor.coordinate)

func _ready() -> void:
	#if _cursor.m_LevelGrid == null:
		#push_error("Player_cursor: m_LevelGrid is not assigned in the inspector!")
		#return
	#_cursor.snap_to_grid()
	pass

func _process(delta: float) -> void:
	if _cursor.m_LevelGrid == null:
		return
	handle_movement_input(delta)
	_cursor.handle_selection_input()

func handle_movement_input(delta: float) -> void:
	_cursor.move_timer -= delta
	if _cursor.move_timer > 0.0:
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
		_cursor.try_move(input_dir)
		_cursor.move_timer = _cursor.moveCooldown

func match_pos(pCoord : Vector2i ) ->void:
	position = _grid.get_world_pos_from_coords(pCoord.x, pCoord.y)
