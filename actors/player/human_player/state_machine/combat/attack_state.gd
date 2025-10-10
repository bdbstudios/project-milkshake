class_name AttackState extends PlayerBaseState

var should_replay: bool = false

var input_name: String
var animation_parameter_name: String

func enter() -> void:
	super()
	
	assert(input_name, "No input name was given for the attack")
	assert(animation_parameter_name, "No animation parameter name was given for the attack")

	player.animation_tree.animation_finished.connect(_on_attack_animation_finished)
	player.animation_tree.set(animation_parameter_name, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

	player.disable_motion()
	player.hitbox_collision.disabled = false
	player.animation_tree.set("parameters/MovementTransition/transition_request", "idle")
	player.animation_tree.set("parameters/GroundedTransition/transition_request", "grounded")

func physics_update(delta: float) -> void:
	player.face_camera_direction(delta)

func update(delta: float) -> void:
	super(delta)

	if Input.is_action_pressed(input_name):
		should_replay = true
	else:
		should_replay = false

func finish_attack() -> void:
	var movement_type = player.movement_component.get_movement_type()

	if movement_type == "idle":
		state_machine.change_state("movement/idle")
	elif movement_type == "walk":
		state_machine.change_state("movement/walk")
	elif movement_type == "run":
		state_machine.change_state("movement/run")

# We override the handle_input from PlayerState so that it won't transition to a different attack state
# while holding down the attack button
func handle_input(_event: InputEvent) -> void:
	pass

func exit() -> void:
	player.enable_motion()
	player.hitbox_collision.disabled = true
	player.animation_tree.animation_finished.disconnect(_on_attack_animation_finished)

func _on_attack_animation_finished(_animation: StringName) -> void:
	if should_replay:
		player.animation_tree.set(animation_parameter_name, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		finish_attack()
