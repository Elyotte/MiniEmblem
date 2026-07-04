class_name CellInfo

enum Type{
	Void,
	Normal,
	Wall,
}

var unit : Unit
var type : Type


func is_occupied() -> bool:
	return unit != null
