extends KinematicBody2D

export (int) var speed = 115

enum Direction { NORTH, NORTH_WEST, WEST, SOUTH_WEST, SOUTH, SOUTH_EAST, EAST, NORTH_EAST }

var velocity = Vector2()
var prev_velocity = Vector2()
var direction = Direction.SOUTH

func vector_to_direction(vector: Vector2):
	if vector.length() == 0:
		return direction
		
	match (round(fposmod(rad2deg(vector.angle()), 360)) as int):
		0:
			direction = Direction.EAST
		27:
			direction = Direction.SOUTH_EAST
		90:
			direction = Direction.SOUTH
		153:
			direction = Direction.SOUTH_WEST
		180:
			direction = Direction.WEST
		207:
			direction = Direction.NORTH_WEST
		270:
			direction = Direction.NORTH
		333:
			direction = Direction.NORTH_EAST


func _process(_delta):
	var anim = ""
	var anim_suffix = ""
	
	match (direction):
		Direction.NORTH:
			anim_suffix = "n"
		Direction.SOUTH:
			anim_suffix = "s"
		Direction.EAST:
			anim_suffix = "e"
		Direction.WEST:
			anim_suffix = "w"
		Direction.NORTH_EAST:
			anim_suffix = "ne"
		Direction.NORTH_WEST:
			anim_suffix = "nw"
		Direction.SOUTH_EAST:
			anim_suffix = "se"
		Direction.SOUTH_WEST:
			anim_suffix = "sw"

	if velocity.length() == 0:
		anim = "stand"
	else:
		anim = "run"

	if prev_velocity != velocity:
		$AnimatedSprite.play(anim + "-" + anim_suffix)
		prev_velocity = velocity

func get_input():
	if Input.is_action_pressed("start") and Input.is_action_pressed("select"):
		get_tree().quit()
	
	velocity = Vector2()
	if Input.is_action_pressed("move-up") or Input.is_action_pressed("analog-move-up"):
		velocity.y -= 0.5
	if Input.is_action_pressed("move-left") or Input.is_action_pressed("analog-move-left"):
		velocity.x -= 1
	if Input.is_action_pressed("move-right") or Input.is_action_pressed("analog-move-right"):
		velocity.x += 1
	if Input.is_action_pressed("move-down") or Input.is_action_pressed("analog-move-down"):
		velocity.y += 0.5
		
	velocity = velocity.normalized() * speed

	vector_to_direction(velocity)


func _physics_process(delta):
	get_input()
	# This fix brought to you by: https://github.com/godotengine/godot/issues/18433
	# The comment at the bottom by manglemix works and is used below.
	#
	# Small modification made to if statement to check for non-zero velocity vector
	# else the call to normalized() will fail
	var collision_info = move_and_collide(velocity * delta)
	if (collision_info && velocity):
		global_transform.origin -= collision_info.travel.slide(velocity.normalized())
