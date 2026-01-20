class_name ClimbState extends PlayerBaseState

@export var climb_speed: float = 1.0
@export var acceleration: float = 10.0

var direction: Vector3 = Vector3.ZERO
var target_velocity: Vector3 = Vector3.ZERO

# TODO: make it possible to leave climbing when close to ground and pressing "move_backwards"
# could add another Raycast for this, maybe a climb_check_ground?

# TODO: make it so that when the player reaches the top of a wall that they vault over it instead of just falling

# TODO: if the player presses "jump", the character should either jump towards or away from the wall
# - if pressing "move_backwards", jump away from wall
# - if pressing "move_forward" or "move_left"/"move_right", jump towards that direction relative to the wall

func enter() -> void:
	super()
	player_body.animation_tree.set("parameters/ClimbingTransition/transition_request", "climbing")
	player_body.disable_motion()
	player_body.disable_gravity()

func exit() -> void:
	super()
	player_body.enable_motion()
	player_body.enable_gravity()

func physics_update(delta: float) -> void:
	if not player_body.climb_check_up.is_colliding() or not player_body.climb_check_down.is_colliding():
		state_machine.change_state("movement/fall")
	
	var target_rotation = -(atan2(player_body.climb_check_down.get_collision_normal().z, player_body.climb_check_down.get_collision_normal().x) - PI/2)

	direction = Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward"),
		0
	)

	direction = direction.rotated(Vector3.UP, target_rotation)

	target_velocity = direction.normalized() * climb_speed

	player_body.velocity = player_body.velocity.lerp(target_velocity, acceleration * delta)
	player_body.move_and_slide()

func handle_input(_event: InputEvent) -> void:
	pass
