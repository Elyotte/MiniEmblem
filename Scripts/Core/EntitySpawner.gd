extends Node
class_name EntitySpawner

@export var terrain: GridTerrain
@export var unit_view_scene: PackedScene
@export var cursor_view_scene: PackedScene
@export var initial_cursor_coord: Vector2i = Vector2i.ZERO


func _ready() -> void:
	spawn_cursor(initial_cursor_coord)


func spawn_cursor(at: Vector2i) -> PlayerCursor:
	var cursor := PlayerCursor.new()
	cursor.coordinate = at

	var view := cursor_view_scene.instantiate() as VisualCursor
	add_child(view)
	view.initialize(cursor, terrain)

	return cursor


func spawn_unit(stats: UnitStatsTemplate, unit_name: String, at: Vector2i) -> Unit:
	var unit := Unit.new(stats, unit_name)
	if not GridManager.try_place(unit, at):
		push_warning("EntitySpawner: could not place unit '%s' at %s" % [unit_name, at])
		return null

	var view := unit_view_scene.instantiate() as VisualUnit
	add_child(view)
	view.initialize(unit, terrain)

	return unit
