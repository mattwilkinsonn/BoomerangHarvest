extends StaticBody2D

@export var POISON_FIELD_COLOR: Color = Color.GREEN
@export var LIFE_TIME = 10.0

const PlantDeathScene = preload("res://Game/Plant/PlantDeath.tscn")

func _draw():
	draw_circle(Vector2.ZERO, $PoisonField/CollisionShape2D.shape.radius * 1.1, POISON_FIELD_COLOR)

var player

func _ready():
	player = get_node("../Player")
	$DeathTimer.start(LIFE_TIME)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func death():
	var plant_death = PlantDeathScene.instantiate()
	plant_death.global_position = global_position
	get_parent().add_child.call_deferred(plant_death)
	queue_free()

func _on_death_timer_timeout():
	death()
