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
	elif(animalName == "Rabbit"):
		$AnimatedSprite.play("ice")
	elif(animalName == "Pig"):
		$AnimatedSprite.play("fire2")
	elif(animalName == "Snake"):
		$AnimatedSprite.play("poison")
	elif(animalName == "Rooster"):
		$AnimatedSprite.play("fire")
	elif(animalName == "Monkey"):
		$AnimatedSprite.play("fire")
	elif(animalName == "Sheep"):
		$AnimatedSprite.play("water")
	elif(animalName == "Mouse"):
		$AnimatedSprite.play("poison")
	elif(animalName == "Tiger"):
		$AnimatedSprite.play("thunder")
	elif(animalName == "Dog"):
		$AnimatedSprite.play("fire")
	elif(animalName == "Dragon"):
		$AnimatedSprite.play("fire1")
	else:
		$AnimatedSprite.play("fire")
