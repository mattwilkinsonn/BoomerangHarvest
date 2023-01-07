extends StaticBody2D


func _draw():
	var collision_shape = $CollisionShape2D.shape.size
	draw_rect(Rect2(-1 * collision_shape / 2, collision_shape), Color.GRAY)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
