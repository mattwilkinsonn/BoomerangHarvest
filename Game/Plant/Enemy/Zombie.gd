extends CharacterBody2D

@export var TIME_ALIVE = 5.0
@export var MOVEMENT_SPEED = 150.0
@export var COLOR: Color = Color.BLACK
@export var DELAYED_DEATH_TIME = 0.001

var player


func _ready():
	player = get_node("../Player")
	
func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, COLOR)


func _physics_process(delta):
	look_at(player.global_position)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * MOVEMENT_SPEED

	move_and_slide()

func delayed_death():
	queue_free()
	# $DeathTimer.start(DELAYED_DEATH_TIME)

func _on_death_timer_timeout():
	queue_free()
