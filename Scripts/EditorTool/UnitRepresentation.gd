@tool
extends AnimatedSprite2D
class_name UnitRepresentation

# Editor-only placeholder: place this sprite on the map to mark a starting
# unit position. At runtime it converts itself into a real Unit + VisualUnit
# via EntitySpawner, then removes itself.

@export var terrain: GridTerrain
@export var spawner: EntitySpawner
@export var stats_template: UnitStatsTemplate
@export var unit_name: String = "Unit"

func _init() -> void:
	offset = Vector2(64,64)

func _ready() -> void:
	if terrain == null or spawner == null:
		push_error("UnitRepresentation: terrain or spawner not assigned on '%s'" % name)
		return

	var coord := terrain.get_grid_coord_from_world(global_position)
	spawner.spawn_unit(stats_template, unit_name, coord)
	queue_free()
