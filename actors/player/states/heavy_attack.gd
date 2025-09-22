extends PlayerState

func enter() -> void:
	super()
	#player.animation_playback.travel("Heavy_Attack")
	
#func physics_update(_delta: float) -> void:
	#if not player.animation_tree.get("parameters/Heavy_Attack/active"):
		#var movement_type = player.movement_component.get_movement_type()
#
		#if not player.is_on_floor():
			#state_machine.change_state("jump")
		#elif movement_type == "idle":
			#state_machine.change_state("idle")
		#elif movement_type == "walk":
			#state_machine.change_state("walk")
		#elif movement_type == "run":
			#state_machine.change_state("run")
