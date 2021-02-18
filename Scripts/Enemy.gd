extends KinematicBody2D

var velocity = Vector2()
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 6

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = -200

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func break_free():
	$CollisionShape2D.set_deferred("disabled", true);
	$CollisionShape2D2.set_deferred("disabled", true);
	$CollisionShape2D3.set_deferred("disabled", true);
	velocity.x = 0
	$AnimatedSprite.play('break')
	yield($AnimatedSprite, "animation_finished")
	queue_free()

func hit_free(fireballName):
	$CollisionShape2D.set_deferred("disabled", true);
	$CollisionShape2D2.set_deferred("disabled", true);
	$CollisionShape2D3.set_deferred("disabled", true);
	velocity.x = 0
	$AnimatedSprite.play(fireballName)
	yield($AnimatedSprite, "animation_finished")
	queue_free()
