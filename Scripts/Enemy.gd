extends KinematicBody2D

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = -200;

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if "player" in collision.collider.get_groups():
			velocity.x = 0
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func break_free():
	$CollisionShape2D.set_deferred("disabled", true);
	velocity.x = 0
	$AnimatedSprite.play('break')
	yield($AnimatedSprite, "animation_finished")
	queue_free()

func fire_free():
	$CollisionShape2D.set_deferred("disabled", true);
	velocity.x = 0
	$AnimatedSprite.play('fire')
	yield($AnimatedSprite, "animation_finished")
	queue_free()
