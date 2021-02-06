extends Node2D

var score = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
	get_node("Player").move(Vector2(200, 502))
	$EnemyTimer.start()

func _on_BackToStart_pressed():
	$EnemyTimer.stop()
	var player = get_node("Player")
	player.move(Vector2(-100, 502))
	player.velocity = Vector2(0,0)
	player.gameOver = 0
	for child in get_children():
		if "enemy" in child.get_groups():
			child.queue_free()

func _on_EnemyTimer_timeout():
	var enemy = load("res://Scenes/Enemy.tscn").instance()
	add_child(enemy)
	enemy.position = $EnemySpawnPos.position

func _on_Player_game_over():
	get_node("UI/Menu/Restart").move(Vector2(0, 300))
	$EnemyTimer.stop()
	for child in get_children():
		if "enemy" in child.get_groups():
			child.velocity.x = 0

func _on_Restart_pressed():
	var player = get_node("Player")
	player.move(Vector2(200, 502))
	player.gameOver = 0
	score = 0
	update_score()
	for child in get_children():
		if "enemy" in child.get_groups():
			child.queue_free()
	$EnemyTimer.start()

func _on_Scoreboard_body_entered(body):
	if("enemy" in body.get_groups()):
		score += 1;
		update_score()

func update_score():
	get_node("UI/Menu/Score/Label").text = str(score)	
