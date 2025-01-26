extends CharacterBody2D


const SPEED = 40000
const HEALTH = 5

var CurrentHealth = 5

var Target
var HackingRadius : Area2D

var IFrames

@onready var IFtimer : Timer = $IFrames

func Move(delta : float):
	# Move funtion
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED * delta

# Sets Target
func SetTarget(val : Node2D):
	Target = val.get_parent()
	HackingRadius = val




func _physics_process(delta):
	# If there is a target you want to hack
	if Target:
		# Checks if your in the hackingradius of the target
		var bodies : Array[Node2D] = HackingRadius.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("player"):
				# Adds the time it takes to the progress
				Target.HackingProgress += delta

	# Make the character move
	Move(delta)

	# Mystery fuction
	move_and_slide()

func screenShake(time : float, strength : float):
	# Self exlainatory
	%Camera2D.shake(time, strength)
	
func _on_damage_box_body_entered(body:Node2D) -> void:
	# If an enemy hits you and you dont have iframes
	if body.is_in_group("Enemy") && !IFrames:
		# Cant take damage for set time
		IFrames = true
		IFtimer.start()
		# Takes damage
		CurrentHealth -= body.DMG
		screenShake(0.2, 3.0)

		if CurrentHealth <= 0:
			# If you die changes the scene to deathscreen
			get_tree().change_scene_to_file("res://Scenes/DeathScreen.tscn")

	if body.is_in_group("bullet") && body.targetGroup == "player":
		if !IFrames:
			# Cant take damage for set time
			IFrames = true
			IFtimer.start()
			# Takes damage
			CurrentHealth -= body.dmg
			screenShake(0.2, 3.0)

			body.queue_free()

			if CurrentHealth <= 0:
				# If you die changes the scene to deathscreen
				get_tree().change_scene_to_file("res://Scenes/DeathScreen.tscn")
		body.queue_free()

func _on_iframes_timeout() -> void:
	# Can take damage again
	IFrames = false
		
	
