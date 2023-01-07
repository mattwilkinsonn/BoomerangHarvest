extends Node2D

@export var COLOR: Color = Color.PLUM
@export var POISON_FIELD_COLOR: Color = Color.PURPLE
@export var LIFE_TIME = 10.0

func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, COLOR)
	draw_circle(Vector2.ZERO, $PoisonField/CollisionShape2D.shape.radius * 1.1, POISON_FIELD_COLOR)

var player

func _ready():
	player = get_node("../Player")
	$DeathTimer.start(LIFE_TIME)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
