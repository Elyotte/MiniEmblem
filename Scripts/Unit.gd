extends GridEntity
class_name Unit

@export var unitTemplate: UnitStatsTemplate
@export var startingCoordinate: Vector2i
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var infos: UnitInfo

func _ready() -> void:
	if unitTemplate != null:
		infos = UnitInfo.new(unitTemplate)
	
	if levelGrid == null:
		push_error("Unit '%s': levelGrid is not assigned in the inspector!" % name)
		return
	
	levelGrid.place_unit(self, startingCoordinate)

# A Unit also can't enter a cell occupied by another unit
func can_enter(target: Vector2i) -> bool:
	var lCell := levelGrid.get_cell(target)
	var lCanWalk := infos.can_walk(lCell.type)
	return !levelGrid.is_occupied(target) && lCanWalk
