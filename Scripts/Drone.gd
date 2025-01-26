extends CharacterBody2D

var canShoot : bool = true

var SPEED : float = 0.015
var DMG : float = 1.0
var HEALTH : float = 1.5

const RANGE : Vector2 = Vector2(1, 1)

var bulletpath = preload("res://Scenes/SubScenes/bullet.tscn")

var hacked : bool = false

var MouseInObj : bool

var HackingProgress : float = 0

var Target : Node
var TargetPos : Vector2

var player : Node


func _ready() -> void:
	$range/Range.scale = RANGE
	player = get_tree().get_nodes_in_group("player")[0]
	input_pickable = true
	mouse_entered.connect(onMouseEntered)
	mouse_exited.connect(onMouseLeft)
	SetTarget()
	
func onMouseLeft():
	MouseInObj = false

func onMouseEntered():
	MouseInObj = true

func SetTarget():
	if !hacked:
		Target = player
	else:
		var all_enemys : Array[Node] = get_tree().get_nodes_in_group("Enemy")
		var closest_enemy = null
		print_debug(get_groups())

		if all_enemys.is_empty():
			print_debug("Fuck, there are no enemys to kill")
			pass
		if (all_enemys.size() > 0):
			closest_enemy = all_enemys[0]
			for enemy in all_enemys:
				var distance_to_this_enemy = global_position.distance_squared_to(enemy.global_position)
				var distance_to_closest_enemy = global_position.distance_squared_to(closest_enemy.global_position)
				if (distance_to_this_enemy < distance_to_closest_enemy):
					closest_enemy = enemy


		Target = closest_enemy

func on_hack():
	remove_from_group("Enemy")
	add_to_group("hacked")
	SetTarget()

func shoot(dmg : float, speed : int, dir : Vector2, swnpnt : Vector2, targetGroup : String) -> void:

	# Starts the cooldown
	$Cooldown.start()
	canShoot = false

	# Makes a bullet
	var bullet = bulletpath.instantiate()

	# Sets the variobles
	bullet.pos = swnpnt
	bullet.dmg = dmg
	bullet.speed = speed
	bullet.dir = dir
	bullet.targetGroup = targetGroup
	
	# Adds the made bullet to the scene
	get_parent().get_parent().add_child(bullet)

func _process(delta):
	if Target:
		$hinge.look_at(Target.global_position)

	$HackingProgressBar.value = HackingProgress

	if Input.is_action_just_pressed("hack"):
		if MouseInObj:
			print_debug(str(is_inside_tree()))
			player.SetTarget($HackingRadius)

	# Makes the enemy hacked
	if $HackingProgressBar.max_value == $HackingProgressBar.value:
		hacked = true
		on_hack()
	
	# Only moves if not hacked
	if !hacked:
		# moves according to path
		get_parent().progress_ratio += SPEED * delta

		# Shoots
	if canShoot && Target:
		SetTarget()
		
		var spwpnt = $hinge/bulletSpawnpoint.global_position
		#var dir =  rad_to_deg(spwpnt.angle_to(Target.global_position))
		var dir = (Target.global_position - spwpnt).normalized();
		#print_debug(str(spwpnt)  + " to " + str(Target.global_position) + " angle " +  str(dir))
		var speed = 30000
		var dmg = 0.5
		var targetGroup = Target.get_groups()[0]
		
		shoot(dmg, speed, dir, spwpnt, targetGroup)

func _on_cooldown_timeout() -> void:
	canShoot = true

func _on_range_body_exited(body:Node2D) -> void:
	if body.is_in_group('bullet'):
		body.queue_free()


func _on_dmg_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		if body.targetGroup == "enemy" && hacked:
			HEALTH -= body.dmg
