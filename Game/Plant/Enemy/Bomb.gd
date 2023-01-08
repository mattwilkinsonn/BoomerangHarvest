extends StaticBody2D

@export var COLOR: Color = Color.RED
@export var EXPLOSION_COLOR: Color = Color.ORANGE
@export var LIFE_TIME = 3.0

const BombExplosionScene = preload("res://Game/Plant/Enemy/BombExplosion.tscn")

var player

func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, COLOR)

func _ready():
	player = get_node("../Player")
	$LifeTimer.start(LIFE_TIME)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_life_timer_timeout():
	var explosion = BombExplosionScene.instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	queue_free()

func explode_delayed():
	$LifeTimer.start(0.1)
	
