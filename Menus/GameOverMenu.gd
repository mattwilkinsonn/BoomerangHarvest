extends CanvasLayer

signal play_again

@export var GOOD_LINE = "... Fire burn and cauldron bubble!"
@export var GOOD_AMOUNT = 40
@export var AVERAGE_LINE = "Double, double toil and trouble..."
@export var AVERAGE_AMOUNT = 20
@export var BAD_LINE = "No potions tonight..."


var score: int = 0:
	get:
		return score
	set(new_score):
		if new_score < AVERAGE_AMOUNT:
			score_state = ScoreState.BAD
		elif new_score < GOOD_AMOUNT:
			score_state = ScoreState.AVERAGE
		else:
			score_state = ScoreState.GOOD
		score = new_score
enum ScoreState {
	BAD,
	AVERAGE,
	GOOD
}
var score_state: ScoreState

func init(player_score: int):
	score = player_score
	$Score.text = str(score)
	$Macbeth.text = get_line()
	play_fx()

func get_line() -> String:
	match score_state:
		ScoreState.BAD:
			return BAD_LINE
		ScoreState.AVERAGE:
			return AVERAGE_LINE
		ScoreState.GOOD, _:
			return GOOD_LINE
			
func play_fx():
	match score_state:
		ScoreState.BAD:
			$BadPlayer.play()
		ScoreState.AVERAGE:
			$AveragePlayer.play()
		ScoreState.GOOD:
			$GoodPlayer.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_again_pressed():
	emit_signal("play_again")
