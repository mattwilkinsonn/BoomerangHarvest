extends CharacterBody2D
class_name Plant

const HarvestableScene = preload("res://Game/Harvestable.tscn")

@export var MOVEMENT_SPEED = 300.0

enum PlantState { SAPLING = 0, HARVESTABLE = 1, ENEMY = 2 }

enum PlantType { ZOMBIE = 0, POISON = 1, STICKY = 2, BOMB = 3, CHAOS = 4 }

enum MovementType { STATIONARY = 0, CHASE = 1 }

var PlantTypeConfig = {
	PlantType.ZOMBIE:
	{
		"lifecycle":
		{PlantState.SAPLING: 5, PlantState.HARVESTABLE: 5, PlantState.ENEMY: 5},
		"movement": MovementType.CHASE,
		"color": Color.BLACK
	},
	PlantType.POISON:
	{
		"lifecycle":
		{PlantState.SAPLING: 5, PlantState.HARVESTABLE: 5, PlantState.ENEMY: 5},
		"movement": MovementType.STATIONARY,
		"color": Color.PURPLE
	},
	PlantType.BOMB:
	{
		"lifecycle":
		{PlantState.SAPLING: 5, PlantState.HARVESTABLE: 5, PlantState.ENEMY: 5},
		"movement": MovementType.STATIONARY,
		"color": Color.RED
	},
}

var state: PlantState = PlantState.SAPLING
var type_config: Dictionary
var type: PlantType = PlantType.ZOMBIE:
	get:
		return type
	set(value):
		type = value
		type_config = PlantTypeConfig[type]

var player


func init(plant_type: PlantType):
	type = plant_type
	state = PlantState.SAPLING


func _ready():
	player = get_node("../Player")


func _physics_process(_delta):
	if (
		type_config["movement"] != MovementType.CHASE
		or state != PlantState.ENEMY
	):
		return

	look_at(player.global_position)
	var direction = global_position.direction_to(player.global_position)
	set_movement(direction)

	move_and_slide()


func set_movement(direction: Vector2):
	velocity = direction * MOVEMENT_SPEED


func _draw():
	var color
	match state:
		PlantState.SAPLING:
			color = Color.YELLOW
		PlantState.HARVESTABLE:
			color = Color.GREEN
		PlantState.ENEMY:
			color = type_config["color"]
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, color)


func _on_lifecycle_timer_timeout():
	if state != PlantState.ENEMY:
		state = (state + 1) as PlantState
		$LifecycleTimer.start(type_config["lifecycle"][state])
		queue_redraw()
		return

	queue_free()


func cut():
	if state == PlantState.HARVESTABLE:
		var harvestable = HarvestableScene.instantiate()
		harvestable.global_position = global_position
		get_parent().add_child.call_deferred(harvestable)

	queue_free()
