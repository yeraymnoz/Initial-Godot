extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -275.0

@onready var anim_tree = $AnimationTree

@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var spittleScene = preload("res://Scenes/spittle.tscn")
var spittleDirection = Vector2.RIGHT

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
			spittleDirection = Vector2.RIGHT
		elif direction < 0:
			animated_sprite.flip_h = true
			spittleDirection = Vector2.LEFT
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
	
	if Input.is_action_just_pressed("Spittle"):
		spittle()

	move_and_slide()

#region FUNCIONES ANIMACIONES
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
#endregion

#Instantiate & Shoot spittle
func spittle():
	var projectile = spittleScene.instantiate()
	get_tree().current_scene.add_child(projectile)

	projectile.position = position
	projectile.direction = spittleDirection
	
	if spittleDirection.x < 0:
		projectile.get_node("AnimatedSprite2D").flip_h = true
	else:
		projectile.get_node("AnimatedSprite2D").flip_h = false
