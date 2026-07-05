extends GridEntity
class_name Unit

var _unitName : String

var _maxStats : Array[int]
var _walkRule : Dictionary[CellInfo.Type, bool]
var _currentStats #to create later

func _init(pUnitStatsTemplate : UnitStatsTemplate, pUnitName : String) -> void:
	_unitName = pUnitName
	_maxStats = pUnitStatsTemplate.get_stats()
	_currentStats = _maxStats
	_walkRule = pUnitStatsTemplate.get_walk_rule()
	pass

func can_walk(pCellType :CellInfo.Type) -> bool:
	print(_walkRule.find_key(pCellType) as bool)
	return _walkRule.find_key(pCellType) as bool
