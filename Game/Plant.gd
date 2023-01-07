extends CharacterBody2D
class_name Plant

const HarvestableScene = preload("res://Game/Harvestable.tscn")

@export var MOVEMENT_SPEED = 300.0

enum PlantState {
	SAPLING = 0,
	HARVESTABLE = 1,
	ZOMBIE = 2
}

var state: PlantState = PlantState.SAPLING

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
	
	
func _on_grow_timer_timeout():
	state += 1
	queue_redraw()	
	if state != PlantState.ZOMBIE:
		$GrowTimer.start()


func cut():
	if state == PlantState.HARVESTABLE:
		var harvestable = HarvestableScene.instantiate()
		harvestable.global_position = global_position
		get_parent().add_child.call_deferred(harvestable)
		print("drop harvest!")
	
	queue_free()
