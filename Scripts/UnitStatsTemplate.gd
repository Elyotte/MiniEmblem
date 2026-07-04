extends Resource
class_name UnitStatsTemplate

enum Type { HP, Strength, Speed, Defense, Technique }
@export var walkRule : WalkRules

@export var hp : int = 10
@export var strength : int = 6
@export var speed : int = 5
@export var defense : int = 3
@export var technique : int = 5

func get_stats() -> Array[int] :
	var lStats : Array[int] = [hp, strength, speed, defense, technique]
	return lStats

func get_walk_rule() -> Array[bool] :
	return walkRule.to_array()
	
