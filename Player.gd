extends CharacterBody3D

var direction : Vector3
var input_dir : Vector2
const SPEED = 8.0
const SPRINT_SPEED = 12.0
const JUMP_VELOCITY = 4.5

@onready var camPiv = $CamPivot
@onready var model = $Character
@onready var grabPoint: Node3D = $CamPivot/GrabPoint

var camForward : Vector3

var dt : float
var targetRot = 0
@export var health = 10

var isSprinting = false

var isGrabbing = false

@onready var blocks: Node3D = $"../Blocks"

func flatten(vector: Vector3) -> Vector3:
	return Vector3( vector.x, 0, vector.z)

func move() -> void:
	model.rotation.y = lerp_angle(model.rotation.y, targetRot, .5)
	#$CollisionShape3D.rotation.y = model.rotation.y
	
	
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, .15 * 2)
		velocity.z = lerp(velocity.z, direction.z * SPEED, .15 * 2)
		targetRot = atan2(-velocity.x, -velocity.z)
		#model.rotation.y = lerp_angle(model.rotation.y, atan2(-velocity.x, -velocity.z), .2)
	else:
		velocity.x = move_toward(velocity.x, 0, 5)
		velocity.z = move_toward(velocity.z, 0, 5)
	
	
func _physics_process(delta: float) -> void:
	dt = delta
	camForward = camPiv.basis.z.normalized()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	direction = flatten($CamPivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	move()
	
	move_and_slide()
	
	if Input.is_action_just_pressed("GrabBlock"):
		if isGrabbing:
			isGrabbing = false
		else:
			grabBlock()
	
	if Input.is_action_just_pressed("ThrowBlock"):
		if isGrabbing:
			throwBlock()
	
	if isGrabbing:
		holdBlock()




#Block grabing:
	#Decide on which block (then set block var to the block)
	#get a dir (target pos - block pos)
	#block vel is in the dir * move speed

@onready var block: RigidBody3D = $"../Block"

func grabBlock() -> void:
	var newBlock = selectBlock()
	if newBlock != null:
		isGrabbing = true
		block = newBlock

func holdBlock() -> void:
	
	var targetPos = grabPoint.global_position
	var dir = (targetPos - block.position)
	block.linear_velocity = dir * 6
	#block.position = targetPos

func throwBlock() -> void:
	isGrabbing = false
	var dir = -camForward.normalized()
	block.linear_velocity = dir * 50


#Block choosing
	#for loop on block folder
		#Pick block with dot product closest to cam Forw

func selectBlock() -> RigidBody3D:
	var choice : RigidBody3D
	var choiceDot := 0.0
	for block : RigidBody3D in blocks.get_children():
		var dirTo = (global_position - block.position).normalized()
		var dot = dirTo.dot(camForward)
		print(dot)
		
		if dot >= .4:
			if dot > choiceDot:
				choice = block
				choiceDot = dot 
	
	if blocks.get_children().size() > 0:
		return choice
	else:
		return null
