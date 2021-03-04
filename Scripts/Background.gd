extends Node2D

var speed = 100
var gameOver = true
var viewNum = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	$Background1.play("view" + String(randi()%viewNum))
	$Background2.play("view" + String(randi()%viewNum))
	
func _process(delta):
	if(!gameOver):
		$Background1.position.x -= delta * speed
		$Background2.position.x -= delta * speed
		if $Background1.position.x < -1024:
			$Background1.position.x = 1024
			$Background1.play("view" + String(randi()%viewNum))
		if $Background2.position.x < -1024:
			$Background2.position.x = 1024
			$Background2.play("view" + String(randi()%viewNum))
