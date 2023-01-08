extends Area2D

@export var EXPLOSION_TIME = 0.1
@export var COLOR = Color.ORANGE

var player

func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, COLOR)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	$LifeTimer.start(EXPLOSION_TIME)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_life_timer_timeout():
	for area in get_overlapping_areas():
		if area.get_parent() == player:
			player.bump(global_position.direction_to(player.global_position), Player.BumpType.EXPLOSION)
	queue_free()
