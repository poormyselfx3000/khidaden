extends CharacterBody3D

var health = 100


func _physics_process(delta):
	if health <= 0:
		queue_free()
