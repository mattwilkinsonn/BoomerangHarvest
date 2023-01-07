extends CharacterBody2D

@export var MOVEMENT_SPEED = 300.0

enum PlantState {
	SAPLING = 1,
	HARVESTABLE = 2,
	ZOMBIE = 3
}

var state: PlantState = PlantState.SAPLING

var player

func _ready():
	player = get_node("../Player")

func _physics_process(delta):
	if state != PlantState.ZOMBIE:
		return
		
	look_at(player.global_position)
	var direction = global_position.direction_to(player.global_position)
	set_movement(direction)
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		var colliding_body = collision.get_collider()
		if colliding_body == player:
			player.take_damage(10)
			queue_free()
			

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
