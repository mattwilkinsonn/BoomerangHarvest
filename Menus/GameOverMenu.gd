extends CanvasLayer

signal play_again

var score: int = 0

func init(player_score: int):
	score = player_score
	$VBoxContainer/Score.text = 'Score: ' + str(score)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_again_pressed():
	emit_signal("play_again")
