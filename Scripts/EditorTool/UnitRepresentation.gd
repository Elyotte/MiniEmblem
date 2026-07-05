extends AnimatedSprite2D
class_name Unit_Representation

@export var grid: LevelGrid
@export var template : UnitStatsTemplate
@export var unitName : String = "Unit"

func _try_snap() -> bool:
	if grid == null:
		push_error("Invalid grid export field", self)
		return false
	var lCoords : Vector2i = grid.get_grid_coord_from_world(position)
	position = grid.get_world_pos_from_coords(lCoords.x , lCoords.y)
	return true

func _ready() -> void:
	if(_try_snap()):
		var lCoordinate : Vector2i = grid.get_grid_coord_from_world(position)
		var lUnit : Unit = Unit.new(grid, template, unitName)
		grid.place_unit(lUnit, lCoordinate)
		queue_free()
