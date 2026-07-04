class_name UnitInfo

var unitName : String

var _maxStats : Array[int]
var _walkRule : Array[bool]
var _currentStats #to create later

func _init(pUnitStatsTemplate : UnitStatsTemplate) -> void:
	_maxStats = pUnitStatsTemplate.get_stats()
	_currentStats = _maxStats
	_walkRule = pUnitStatsTemplate.get_walk_rule()
	pass

func can_walk(pCellType :CellInfo.Type) -> bool:
	return _walkRule.get(pCellType as int)
