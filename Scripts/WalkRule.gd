extends Resource
class_name WalkRules

@export var Void : bool
@export var Normal : bool
@export var Wall : bool

func to_array() -> Array[bool]:
	return [Void, Normal, Wall]
