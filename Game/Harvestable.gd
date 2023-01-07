extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, Color.DARK_GREEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_despawn_timer_timeout():
	queue_free()
