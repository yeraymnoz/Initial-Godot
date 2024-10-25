extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -250.0

@onready var anim_tree = $AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum {IDLE,WALK,ATTACK,DEAD}
var baseAnim = IDLE

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		isJumping()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		handle_animations()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func handle_animations():
	match baseAnim:
		IDLE:
			anim_tree.set("parameters/Movement/transition_request","Idle")
		WALK:
			anim_tree.set("parameters/Movement/transition_request","Walk")
		ATTACK:
			anim_tree.set("parameters/Movement/transition_request","Attack")
		DEAD:
			anim_tree.set("parameters/Movement/transition_request","Dead")

func isJumping():
	anim_tree.set("parameters/isJumping/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
