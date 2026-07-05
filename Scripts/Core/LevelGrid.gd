extends TileMapLayer
class_name LevelGrid

var level_width: int
var level_height: int

var allCells : Array[CellInfo]

@export var _unitPrefab : PackedScene
@export var _cursor : PackedScene

static  var instance : LevelGrid
func _enter_tree() -> void:
	if instance != null:
		push_warning("Multiple LevelManager instances detected, overwriting singleton reference.")
	instance = self

func _exit_tree() -> void:
	if instance == self:
		instance = null

func clear_singleton() -> void:
	if(instance != self):
		queue_free()

func _ready() -> void:
	call_deferred("clear_singleton")
	if(instance != self):
		return
	
	var used_rect: Rect2i = get_used_rect()
	
	# Size in tiles
	level_width = used_rect.size.x
	level_height = used_rect.size.y
	
	print("Level size (tiles): ", level_width, "x", level_height)
	
	allCells.clear()
	var length : int = level_width * level_height
	for i :int in length:
		# Convert flat index to grid coordinates, offset by the used_rect origin
		var x: int = used_rect.position.x + (i % level_width)
		var y: int = used_rect.position.y + (i / level_width)
		var coords: Vector2i = Vector2i(x, y)
		
		var lCell = CellInfo.new()
		
		var tile_data: TileData = get_cell_tile_data(coords)
		if tile_data != null:
			lCell.type = tile_data.get_custom_data("TerrainType")
		else:
			lCell.type = 0
		
		allCells.insert(i, lCell)
	
	# cursor instantiation
	var lCursor : PlayerCursor = PlayerCursor.new(self)
	var lNode : VisualCursor = _cursor.instantiate() as VisualCursor
	add_child(lNode)
	lNode.initialize(lCursor)
	
	# Centralize the index math in one place instead of duplicating it everywhere
func coord_to_index(coords: Vector2i) -> int:
	return coords.y * level_width + coords.x

func is_in_bounds(coords: Vector2i) -> bool:
	return coords.x >= 0 and coords.x < level_width and coords.y >= 0 and coords.y < level_height

func get_cell(coords: Vector2i) -> CellInfo:
	if not is_in_bounds(coords):
		return null
	return allCells[coord_to_index(coords)]

func is_occupied(coords: Vector2i) -> bool:
	var cell := get_cell(coords)
	return cell != null and cell.is_occupied()

# The ONLY function allowed to move a unit on the grid.
# Keeps CellInfo.unit and Unit.coordinate always in sync.
func move_unit(unit: Unit, to: Vector2i) -> bool:
	if not is_in_bounds(to):
		return false
	
	var target_cell := get_cell(to)
	if target_cell.is_occupied() or !unit.can_enter(to):
		return false
	
	# Clear the old cell
	var old_cell := get_cell(unit.coordinate)
	if old_cell != null:
		old_cell.unit = null
	
	# Occupy the new cell
	target_cell.unit = unit
	unit.coordinate = to
	unit.on_set_position.emit(to)
	return true

func _instantiateUnit(pUnit : Unit) -> void:
	var lUnits : VisualUnit = _unitPrefab.instantiate() as VisualUnit
	if(lUnits == null):
		return
	add_child(lUnits)
	lUnits.initialize(pUnit, self)
	pUnit.on_set_position.emit(pUnit.coordinate)
	pass

# used when a new unit is created and you want to add it on the grid data
func place_unit(unit: Unit, at: Vector2i) -> bool:
	var cell := get_cell(at)
	if cell == null or cell.is_occupied() and unit.can_enter(at):
		return false
	
	cell.unit = unit
	unit.coordinate = at
	
	_instantiateUnit(unit)
	return true

func get_grid_coord_from_world(world_pos: Vector2) -> Vector2i:
	var local_pos: Vector2 = to_local(world_pos)
	return local_to_map(local_pos)

func get_world_pos_from_coords(x: int, y: int) -> Vector2:
	var tile_coords: Vector2i = Vector2i(x, y)
	var local_pos: Vector2 = map_to_local(tile_coords)
	return to_global(local_pos)
