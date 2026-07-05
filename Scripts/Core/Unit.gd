extends GridEntity
class_name Unit

var _unitName : String

var _maxStats : Array[int]
var _walkRule : Dictionary[CellInfo.Type, bool]
var _currentStats #to create later

func _init(pGrid :LevelGrid, pUnitStatsTemplate : UnitStatsTemplate, pUnitName : String) -> void:
	super._init(pGrid)
	_unitName = pUnitName
	_maxStats = pUnitStatsTemplate.get_stats()
	_currentStats = _maxStats
	_walkRule = pUnitStatsTemplate.get_walk_rule()
	pass

func can_enter(target: Vector2i) -> bool:
	var lCell : CellInfo = m_LevelGrid.get_cell(target)
	return _walkRule.find_key(lCell.type)
