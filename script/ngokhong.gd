extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 2
var combo_count = 0
var hetdelay = true

@onready var combotime: Timer = $combotime
@export var mouse_sens = 0.1
@onready var head: Node3D = $head
@onready var hitting: Timer = $hitting


var list_hit = ["hit","hit2","hit3"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(25))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("use") and hetdelay and not $AnimationPlayer.is_playing():
		
		$gaynhuy.hitting = true
		combo()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("walking")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func combo():
	combotime.start(0.5)
	combo_count += 1
	var hit = "hit"+str(combo_count)
	print(hit)
	$AnimationPlayer.play(hit)
	if combo_count == 3:
		$delay.start(1)
		hetdelay = false
	

func _on_combotime_timeout() -> void:
	combo_count = 0


func _on_delay_timeout() -> void:
	hetdelay = true
