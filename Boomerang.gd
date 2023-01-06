extends RigidBody2D
class_name Boomerang


enum BoomerangState {
	ON_PLAYER,
	FLYING,
	RETURNING
}

var player

var state: BoomerangState = BoomerangState.ON_PLAYER

@export var THROW_FORCE = 600.0
@export var THROW_TORQUE = 20.0
@export var MIN_RETURNING_FORCE = 200.0
@export var MAX_RETURNING_FORCE = 10000.0
@export var RETURN_TORQUE = 10.0
@export var RETURNING_FORCE_DISTANCE_SCALING_LIMIT = 1000
@export var MAX_VELOCITY = 500.0

var slope = (MAX_RETURNING_FORCE - MIN_RETURNING_FORCE) / (0 - RETURNING_FORCE_DISTANCE_SCALING_LIMIT)
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")

func set_on_player():
	freeze = true
	rotation = 0
	angular_velocity = 0.0
	linear_velocity = Vector2.ZERO
	state = BoomerangState.ON_PLAYER

func _physics_process(delta):
	if state == BoomerangState.ON_PLAYER:
		global_position = player.global_position + Vector2(10, -10)
		
	if state == BoomerangState.RETURNING:
		apply_returning_force()

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if state.linear_velocity.length() > MAX_VELOCITY:
		state.linear_velocity = state.linear_velocity.normalized() * MAX_VELOCITY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func apply_returning_force():
	var direction = global_position.direction_to(player.global_position)
	
	var distance = global_position.distance_to(player.global_position)
	
	var force = MIN_RETURNING_FORCE
	if distance < RETURNING_FORCE_DISTANCE_SCALING_LIMIT:
		force = (slope * distance) + MAX_RETURNING_FORCE
	apply_force(direction * force)

func start_returning():
	state = BoomerangState.RETURNING
	apply_torque_impulse(RETURN_TORQUE)

func throw():
	state = BoomerangState.FLYING
	freeze = false
	var mouse_position = get_global_mouse_position()
	var aim_direction = global_position.direction_to(mouse_position)
	
	look_at(aim_direction)
	apply_central_impulse(aim_direction * THROW_FORCE)
	apply_torque_impulse(THROW_TORQUE)

func _on_area_2d_body_entered(body):
	if body == player:
		set_on_player()
