extends KinematicBody2D

export var velocity = Vector2()
export var gravityGain = 6
export var gravityVelocityRate = 0.67
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * gravityGain

signal game_over
signal hit_coin(coinName)
signal jump
var gameOver

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	velocity.x = 0
	if(gameOver):
		velocity = Vector2(0,0)
		$AnimatedSprite.stop()
	else:
		velocity.y += gravity * delta
		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	if is_on_floor() and Input.is_action_just_pressed("jump") and !gameOver:
		velocity.y = -gravity * gravityVelocityRate
		emit_signal("jump")

func _on_Area2D_body_entered(body):
	if("coin" in body.get_groups()):
		emit_signal("hit_coin", body.get_node("AnimatedSprite").animation)
		body.queue_free()
	if("enemy" in body.get_groups()):
		emit_signal("game_over")
		gameOver = 1

func move(target):
	var move_tween = get_node("move_tween")
	move_tween.interpolate_property(self, "position", position, target, 2, Tween.TRANS_QUINT, Tween.EASE_OUT);
	move_tween.start()

func swap_free():
	$AnimatedSprite.play('disappear')
	yield($AnimatedSprite, "animation_finished")
	queue_free()
	
func _on_Horse_jump():
	$AnimatedSprite.play('jump')
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play('run')

