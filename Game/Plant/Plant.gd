extends CharacterBody2D
class_name Plant

@export var SAPLING_TIME = 2.5
@export var HARVESTABLE_TIME = 2.5

const HarvestableScene = preload("res://Game/Harvestable.tscn")
const ZombieScene = preload("res://Game/Plant/Enemy/Zombie.tscn")
const PoisonScene = preload("res://Game/Plant/Enemy/Poison.tscn")
const BombScene = preload("res://Game/Plant/Enemy/Zombie.tscn")

enum PlantState { SAPLING = 0, HARVESTABLE = 1 }

enum PlantType { ZOMBIE = 0, POISON = 1, BOMB = 2 }

var state: PlantState = PlantState.SAPLING
var type: PlantType = PlantType.ZOMBIE

var scene_for_type = {
	PlantType.ZOMBIE: ZombieScene,
	PlantType.POISON: PoisonScene,
	PlantType.BOMB: BombScene
}


func init(plant_type: PlantType):
	type = plant_type
	state = PlantState.SAPLING


func _ready():
	$LifecycleTimer.start(SAPLING_TIME)

func _draw():
	var color
	match state:
		PlantState.SAPLING:
			color = Color.YELLOW
		PlantState.HARVESTABLE:
			color = Color.GREEN
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, color)


func _on_lifecycle_timer_timeout():
	match state:
		PlantState.SAPLING:
			state = PlantState.HARVESTABLE
			$LifecycleTimer.start(HARVESTABLE_TIME)
			queue_redraw()
		PlantState.HARVESTABLE:
			var enemy = scene_for_type[type].instantiate()
			enemy.global_position = global_position
			get_parent().add_child(enemy)
			queue_free()
		


func cut():
	if state == PlantState.HARVESTABLE:
		var harvestable = HarvestableScene.instantiate()
		harvestable.global_position = global_position
		get_parent().add_child.call_deferred(harvestable)

	queue_free()
