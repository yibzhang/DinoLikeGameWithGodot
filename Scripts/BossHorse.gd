extends KinematicBody2D

var velocity = Vector2()
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$FireballTimer.start()

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func _on_FireballTimer_timeout():
	$AnimatedSprite.play("standup")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("run")

func get_hit():
	print("boss get hit")
