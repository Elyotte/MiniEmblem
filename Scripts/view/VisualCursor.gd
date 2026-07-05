extends Node2D
class_name VisualCursor

var _cursor: PlayerCursor
var _terrain: GridTerrain


func initialize(cursor: PlayerCursor, terrain: GridTerrain) -> void:
	_cursor = cursor
	_terrain = terrain
	_cursor.on_position_changed.connect(_match_position)
	_match_position(_cursor.coordinate)


func _process(delta: float) -> void:
	_handle_movement_input(delta)
	_cursor.handle_selection_input()


func _handle_movement_input(delta: float) -> void:
	_cursor.move_timer -= delta
	if _cursor.move_timer > 0.0:
		return

	var input_dir := Vector2i.ZERO
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
		_cursor.move_timer = _cursor.move_cooldown


func _match_position(coord: Vector2i) -> void:
	position = _terrain.get_world_pos_from_coord(coord)
