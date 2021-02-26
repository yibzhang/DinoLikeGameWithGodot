extends KinematicBody2D

var velocity = Vector2(0,0)

func _ready():
	velocity.x = -600;

func _physics_process(_delta):
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
