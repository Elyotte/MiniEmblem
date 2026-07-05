extends TileMapLayer
class_name GridTerrain

# Purely visual + world<->grid conversion. Owns no game data, no singleton
# logic, no unit spawning — see GridManager (data) and EntitySpawner
# (instantiation) for that.


func _ready() -> void:
	var used_rect := get_used_rect()
	GridManager.setup(used_rect)

	for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var coord := Vector2i(x, y)
			var tile_data := get_cell_tile_data(coord)
			var type: CellInfo.Type = (
				tile_data.get_custom_data("terrain_type")
				if tile_data != null
				else CellInfo.Type.VOID
			)
			GridManager.set_cell_type(coord, type)


func get_grid_coord_from_world(world_pos: Vector2) -> Vector2i:
	return local_to_map(to_local(world_pos))


func get_world_pos_from_coord(coord: Vector2i) -> Vector2:
	return to_global(map_to_local(coord))
