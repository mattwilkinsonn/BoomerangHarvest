extends RigidBody2D
class_name Boomerang

const Plant = preload("res://Game/Plant/Plant.gd")
const Zombie = preload("res://Game/Plant/Enemy/Zombie.gd")
const Bomb = preload("res://Game/Plant/Enemy/Bomb.gd")

enum BoomerangState { ON_PLAYER, FLYING, RETURNING }

var player

var state: BoomerangState = BoomerangState.ON_PLAYER:
	get:
		return state
	set(new_state):
		if state == new_state:
			return
			
		if new_state == BoomerangState.ON_PLAYER:
			$CatchPlayer.play()
		var should_monitor_cutting = new_state != BoomerangState.ON_PLAYER
		$CuttingArea.set_deferred("monitorable", should_monitor_cutting)
		$CuttingArea.set_deferred("monitoring", should_monitor_cutting)
		
		if new_state == BoomerangState.RETURNING:
			$ThrowReturnTimer.stop()
			apply_torque_impulse(RETURN_TORQUE)
			$ReturnPlayer.play()
		
		state = new_state

@export var THROW_FORCE = 600.0
@export var THROW_TORQUE = 20.0
@export var MIN_RETURNING_FORCE = 2000.0
@export var MAX_RETURNING_FORCE = 5000.0
@export var RETURN_TORQUE = 10.0
@export var RETURNING_FORCE_DISTANCE_SCALING_LIMIT = 1000
@export var MAX_VELOCITY = 500.0
@export var RETURN_PREDICTION_MODIFIER = 0.8
@export var MAX_DISTANCE_FROM_PLAYER = 500.0
@export var THROW_AUTORETURN_TIME = 2.0

var slope = (
	(MAX_RETURNING_FORCE - MIN_RETURNING_FORCE) / (0 - RETURNING_FORCE_DISTANCE_SCALING_LIMIT)
)


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")


func _physics_process(_delta):
	if state == BoomerangState.ON_PLAYER:
		if not freeze:
			freeze = true
			rotation = 0
			angular_velocity = 0.0
			linear_velocity = Vector2.ZERO
			
		global_position = player.global_position + Vector2(20, -10)

	if state == BoomerangState.RETURNING:
		apply_returning_force()


func _integrate_forces(physics_state: PhysicsDirectBodyState2D):
	if physics_state.linear_velocity.length() > MAX_VELOCITY:
		physics_state.linear_velocity = physics_state.linear_velocity.normalized() * MAX_VELOCITY


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (
		global_position.distance_to(player.global_position) > MAX_DISTANCE_FROM_PLAYER
		and state == BoomerangState.FLYING
	):
		state = BoomerangState.RETURNING
		
	if state != BoomerangState.ON_PLAYER and $ThrowReturnTimer.is_stopped():
		for area in $PickupArea.get_overlapping_areas():
			if area.get_parent() == player:
				state = BoomerangState.ON_PLAYER
				break


func apply_returning_force():
	var seconds_to_player = global_position.distance_to(player.global_position) / MAX_VELOCITY

	var player_position = (
		player.global_position
		+ (player.velocity * (seconds_to_player * RETURN_PREDICTION_MODIFIER))
	)

	var direction = global_position.direction_to(player_position)

	var distance = global_position.distance_to(player_position)

	var force = MIN_RETURNING_FORCE
	if distance < RETURNING_FORCE_DISTANCE_SCALING_LIMIT:
		force = (slope * distance) + MAX_RETURNING_FORCE
	apply_force(direction * force)
	


func throw():
	state = BoomerangState.FLYING
	var mouse_position = get_global_mouse_position()
	var aim_direction = player.global_position.direction_to(mouse_position)
	global_position = player.global_position
	freeze = false
	look_at(aim_direction)
	apply_central_impulse(aim_direction * THROW_FORCE)
	apply_torque_impulse(THROW_TORQUE)
	$ThrowReturnTimer.start(THROW_AUTORETURN_TIME)
	$ThrowPlayer.play()


func _on_cutting_area_body_entered(body):
	if body is Plant:
		body.cut()
	
	if body is Zombie:
		body.delayed_death()
		state = BoomerangState.RETURNING
		
	
	if body is Bomb:
		body.explode_delayed()
		state = BoomerangState.RETURNING
		


func _on_body_entered(body):
	$RicochetPlayer.play()


func _on_return_timer_timeout():
	state = BoomerangState.RETURNING
