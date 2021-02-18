extends KinematicBody2D

var velocity = Vector2()
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 6

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = -400

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
			
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func set_spellpaper_type(animalName):
	if(animalName == "Horse"):
		$AnimatedSprite.play("wind")
	elif(animalName == "Ox"):
		$AnimatedSprite.play("fire")
	else:
		$AnimatedSprite.play("fire")
