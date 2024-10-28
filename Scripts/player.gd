extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -250.0

@onready var anim_tree = $AnimationTree

@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum {IDLE,WALK,ATTACK,DEAD}
var baseAnim

func _physics_process(delta):
	
	handle_animations()
	
	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
		# Flip the Sprite
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Call animations
	if is_on_floor():
		if direction == 0:
			baseAnim = IDLE
		else:
			baseAnim = WALK
		# Handle jump
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
	else:
		# Add the gravity
		velocity.y += gravity * delta
		isJumping()

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
