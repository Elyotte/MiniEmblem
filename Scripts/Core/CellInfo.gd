class_name CellInfo

enum Type {
	VOID,
	NORMAL,
	WALL,
}

var unit: Unit
var type: Type = Type.VOID


func is_occupied() -> bool:
	return unit != null
