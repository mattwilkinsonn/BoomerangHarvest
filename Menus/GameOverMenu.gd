extends CanvasLayer

signal play_again

var score: int = 0

@export var GOOD_LINE = "Walpurgis will reward you..."
@export var GOOD_AMOUNT = 25
@export var AVERAGE_LINE = "Walpurgis is satisfied"
@export var AVERAGE_AMOUNT = 10
@export var BAD_LINE = "Walpurgis is not happy"

func init(player_score: int):
	score = player_score
	$VBoxContainer/VBoxContainer/Score.text = 'Harvested: ' + str(score)
	$VBoxContainer/VBoxContainer/Walpurgis.text = get_line(score)

func get_line(score: int):
	if score < AVERAGE_AMOUNT:
		return BAD_LINE
	if score < GOOD_AMOUNT:
		return AVERAGE_LINE
	
	return GOOD_LINE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_again_pressed():
	emit_signal("play_again")
