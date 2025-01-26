extends Area2D

var health : int = 5
var CurrentHealth : int = 5

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("Enemy"):
		CurrentHealth -= 1
		body.queue_free()
	if CurrentHealth == 0:
		death()

func death():
	get_tree().change_scene_to_file("res://Scenes/DeathScreen.tscn")
