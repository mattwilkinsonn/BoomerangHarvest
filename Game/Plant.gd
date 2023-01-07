extends CharacterBody2D
class_name Plant

const HarvestableScene = preload("res://Game/Harvestable.tscn")

@export var MOVEMENT_SPEED = 300.0

enum PlantState { SAPLING = 0, HARVESTABLE = 1, ZOMBIE = 2 }

enum PlantType { ZOMBIE = 0, POISON = 1, STICKY = 2, BOMB = 3, CHAOS = 4 }

var PlantTypeToColor = {
	PlantType.ZOMBIE: Color.BLACK,
	PlantType.POSION: Color.PURPLE,
	PlantType.STICKY: Color.ORANGE,
	PlantType.BOMB: Color.RED,
	PlantType.Chaos: Color.PINK
}

var state: PlantState = PlantState.SAPLING
var type: PlantType

var player


func _ready():
	player = get_node("../Player")


func _physics_process(_delta):
	if state != PlantState.ZOMBIE:
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
		PlantState.ZOMBIE:
			color = Color.BLACK
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, color)


func _on_lifecycle_timer_timeout():
	if state != PlantState.ZOMBIE:
		state = (state + 1) as PlantState
		queue_redraw()
		$GrowTimer.start()
		return


func cut():
	if state == PlantState.HARVESTABLE:
		var harvestable = HarvestableScene.instantiate()
		harvestable.global_position = global_position
		get_parent().add_child.call_deferred(harvestable)
		print("drop harvest!")

	queue_free()
