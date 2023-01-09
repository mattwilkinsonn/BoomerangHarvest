extends CharacterBody2D
class_name Plant

@export var SAPLING_TIME = 2.5
@export var HARVESTABLE_TIME = 2.5

const HarvestableScene = preload("res://Game/Harvestable.tscn")
const ZombieScene = preload("res://Game/Plant/Enemy/Zombie.tscn")
const PoisonScene = preload("res://Game/Plant/Enemy/Poison.tscn")
const BombScene = preload("res://Game/Plant/Enemy/Bomb.tscn")
const PlantDeathScene = preload("res://Game/Plant/PlantDeath.tscn")

enum PlantState { SAPLING = 0, HARVESTABLE = 1 }

enum PlantType { ZOMBIE = 0, POISON = 1, BOMB = 2 }

var sapling_time: float
var harvestable_time: float

var state: PlantState = PlantState.SAPLING:
	get:
		return state
	set(new_state):
		if new_state == PlantState.SAPLING:
			$AnimatedSprite2D.position = Vector2.ZERO
			$AnimatedSprite2D.play("sapling")
		
		if new_state == PlantState.HARVESTABLE:
			$AnimatedSprite2D.position = Vector2(5, -19)
			$AnimatedSprite2D.play("harvestable")
			set_collision_layer_value(10, true)
			
		state = new_state
var type: PlantType = PlantType.ZOMBIE

var scene_for_type = {
	PlantType.ZOMBIE: ZombieScene,
	PlantType.POISON: PoisonScene,
	PlantType.BOMB: BombScene
}


func init(plant_type: PlantType, sapling: float, harvestable: float):
	type = plant_type
	state = PlantState.SAPLING
	sapling_time = sapling
	harvestable_time = harvestable

func _ready():
	$LifecycleTimer.start(SAPLING_TIME)


func _on_lifecycle_timer_timeout():
	match state:
		PlantState.SAPLING:
			state = PlantState.HARVESTABLE
			$LifecycleTimer.start(HARVESTABLE_TIME)
			$GrowPlayer.play()
			queue_redraw()
		PlantState.HARVESTABLE:
			spawn_enemy()
			queue_free()
func spawn_enemy():
	if type == PlantType.ZOMBIE:
		var zombie = ZombieScene.instantiate()
		zombie.global_position = global_position
		get_parent().add_child(zombie)
		return
	var enemy = scene_for_type[type].instantiate()
	enemy.global_position = global_position
	get_parent().add_child(enemy)
	


func death():
	var plant_death = PlantDeathScene.instantiate()
	plant_death.global_position = global_position
	get_parent().add_child.call_deferred(plant_death)
	queue_free()
	


func cut():
	if state == PlantState.HARVESTABLE:
		var harvestable = HarvestableScene.instantiate()
		harvestable.global_position = global_position
		get_parent().add_child.call_deferred(harvestable)
		
	death()
	
