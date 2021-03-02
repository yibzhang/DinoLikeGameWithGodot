extends KinematicBody2D

export var maxEnergy = 5

var velocity = Vector2()
var fireballName = "fire2"
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 10

var energy = maxEnergy

# Called when the node enters the scene tree for the first time.
func _ready():
	$FireballTimer.start()
	$Energybar.max_value = maxEnergy
	$Energybar.value = maxEnergy
	
func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func _on_FireballTimer_timeout():
	$AnimatedSprite.play("standup")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("run")
	spawn_fireball()

func get_hit():
	#print("boss get hit")
	if(energy > 0):
		energy -= 1
		update_energybar(energy)
	else:
		get_parent().get_node("Game").boss_killed()
	
func spawn_fireball():
	#var rng = RandomNumberGenerator.new()
	#var scaleRatio = rng.randf_range(1.0, 2.0)
	#print(scaleRatio)
	var fireball = load("res://Scenes/BossFireball.tscn").instance()
	fireball.position.x = self.position.x
	fireball.position.y = self.position.y + 80
	fireball.scale = Vector2(1,1)
	fireball.get_node("AnimatedSprite").play(fireballName)
	fireball.get_node(fireballName).set_deferred("disabled", false);
	get_parent().get_node("Game").add_child(fireball)

func update_energybar(energyValue):
	$Energybar.value = energyValue
