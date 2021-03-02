extends KinematicBody2D

export var velocity = Vector2()
export var gravityGain = 6
export var gravityVelocityRate = 0.67
export var maxEnergy = 3
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * gravityGain

signal game_over
signal hit_coin(coinName)
signal hit_spellpaper(spellpaperName)
signal jump
signal power_mode_hit

var gameOver
var powerMode
var energy = maxEnergy

# Called when the node enters the scene tree for the first time.
func _ready():
	$Energybar.max_value = maxEnergy
	$Energybar.value = maxEnergy

func _input(event):
	if (event is InputEventScreenTouch) or (event is InputEventMouseButton and event.pressed):
		if is_on_floor() and !gameOver and !powerMode:
			velocity.y = -gravity * gravityVelocityRate
			emit_signal("jump")
			
func _physics_process(delta):
	velocity.x = 0
	if(gameOver):
		velocity = Vector2(0,0)
		$AnimatedSprite.stop()
	else:
		velocity.y += gravity * delta
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func _on_Area2D_body_entered(body):
	if("coin" in body.get_groups()):
		emit_signal("hit_coin", body.get_node("AnimatedSprite").animation)
		body.queue_free()
	if("spellpaper" in body.get_groups()):
		emit_signal("hit_spellpaper", body.get_node("AnimatedSprite").animation)
		body.queue_free()
	if("enemy" in body.get_groups()):
		if(powerMode):
			body.break_free()
			emit_signal("power_mode_hit")
		else:
			if(energy > 0):
				energy -= 1
				update_energybar(energy)
				body.break_free();
			else:
				emit_signal("game_over")
				gameOver = 1
	if("bossfireball" in body.get_groups()):
		body.queue_free()
		if(energy > 0):
			energy -= 1
			update_energybar(energy)
		else:
			emit_signal("game_over")
			gameOver = 1

func move(target):
	var move_tween = get_node("move_tween")
	move_tween.interpolate_property(self, "position", position, target, 2, Tween.TRANS_QUINT, Tween.EASE_OUT);
	move_tween.start()

func reset_energy():
	energy = maxEnergy
	update_energybar(energy)

func update_energybar(energyValue):
	$Energybar.value = energyValue

func swap_free():
	$AnimatedSprite.play('disappear')
	yield($AnimatedSprite, "animation_finished")
	queue_free()

func _on_Pig_jump():
	$AnimatedSprite.play('jump')
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play('run')
