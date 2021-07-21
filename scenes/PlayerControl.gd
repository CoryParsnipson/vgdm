extends KinematicBody2D

export (int) var speed = 100

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move-up"):
		velocity.y -= 0.5
	if Input.is_action_pressed("move-left"):
		velocity.x -= 1
	if Input.is_action_pressed("move-right"):
		velocity.x += 1
	if Input.is_action_pressed("move-down"):
		velocity.y += 0.5
	
	velocity = velocity.normalized() * speed


func _physics_process(delta):
	get_input()
	var pos = transform.origin
	var collision_info = move_and_collide(velocity * delta)
	if (collision_info):
		global_transform.origin -= collision_info.travel.slide(velocity.normalized())
