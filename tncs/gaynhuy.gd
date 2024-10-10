extends Area3D


@onready var timer: Timer = $Timer
@onready var hitsound: AudioStreamPlayer3D = $AudioStreamPlayer3D


var damage = 10
var countdown = true
var hitting = false

func _on_body_entered(body: Node3D) -> void:
		var target = body
		if target.is_in_group("enemy") and canhit():
			target.health -= damage
			hitsound.play()
			countdown = false
			timer.start(0.2)
			
			

func canhit():
	if countdown and hitting:
		return true
	else :
		return false
	
func _on_timer_timeout() -> void:
	countdown = true
	hitting = false
