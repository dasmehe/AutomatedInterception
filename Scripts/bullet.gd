extends CharacterBody2D

# Attributes of the bullets
var pos : Vector2
var dir : Vector2
var speed : int
var dmg : float
var targetGroup : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sets the position and rotation of the bullet
	global_position = pos
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Moves the bullet
	#velocity = (Vector2(speed, 0) * delta).rotated(dir)
	velocity = (speed * dir) * delta
	#print_debug(" bullet " +  str(dir))
	#                                            _		    _
	# What it does is a mystery, but it works so  \__(")__/
	move_and_slide()