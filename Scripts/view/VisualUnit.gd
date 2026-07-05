extends Node2D
class_name VisualUnit

var _animatedSprite : AnimatedSprite2D
var _grid : LevelGrid

var _Unit : Unit

func initialize(pUnit : Unit, pinGrid : LevelGrid):
	_Unit = pUnit
	_grid = pinGrid
	_Unit.on_set_position.connect(_match_position)

func _match_position(pPos : Vector2i ) -> void:
	if(_grid == null):
		push_error("NO GRID SET")
		return
	position = _grid.get_world_pos_from_coords(pPos.x, pPos.y)
	pass
