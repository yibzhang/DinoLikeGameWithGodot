extends Node2D

var score = 0
var animals = ["Horse", "Ox"]
#var animals = ["Horse"]
var coinCollected = 1
var enemyVelocityX = -200
var coinVelocityX = -300
var spellpaperVelocityX = -400
var playerPos = Vector2(200, 502)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
	var animal = animals[randi()%animals.size()]
	start_timer()
	init_player(animal)
	add_coin_collection(animal, 1)

func hit_coin_handle(coinName):
	var player = get_tree().get_nodes_in_group("player");
	# if player name is not same as coin name, animal swap
	# else add coin into coin collection
	if(player[0].name != coinName):
		free_coin_collection()
		add_coin_collection(coinName, coinCollected)
		player[0].swap_free()
		stop_timer()
		stop_enemy_move()
		stop_coin_move()
		free_enemy_before_position(300)
		yield(get_tree().create_timer(1.0), "timeout")
		init_player(coinName)
		yield(get_tree().create_timer(2.0), "timeout")
		start_timer()
		continue_enemy_move()
		continue_coin_move()
	else:
		if(coinCollected < 3):
			coinCollected += 1;
			add_coin_collection(coinName, coinCollected)
		if(coinCollected == 3):
			# super power mode
			# set timer faster
			free_coin()
			#free_enemy()
			stop_timer()
			$EnemyTimer.wait_time = 0.2
			enemyVelocityX = -1000
			continue_enemy_move()
			get_tree().get_nodes_in_group("player")[0].powerMode = 1
			$EnemyTimer.start()
			yield(get_tree().create_timer(4.0), "timeout")
			stop_timer()
			free_enemy()
			yield(get_tree().create_timer(1.0), "timeout")
			$EnemyTimer.wait_time = 3
			start_timer()
			enemyVelocityX = -200
			get_tree().get_nodes_in_group("player")[0].powerMode = 0
			free_coin_collection()
			add_coin_collection(coinName, coinCollected)

func hit_spellpaper_handle(spellpaperName):
	print(spellpaperName)
	spawn_fireball(spellpaperName)

func power_mode_hit_handle():
	add_score()
		
func game_over_handle():
	get_node("UI/Menu/Restart").move(Vector2(0, 300))
	stop_timer()
	stop_player_move()
	stop_enemy_move()
	stop_coin_move()
	stop_spellpaper_move()

func _on_BackToStart_pressed():
	stop_timer()
	reset_score()
	free_player()
	free_enemy()
	free_coin()
	free_coin_collection()
	free_spellpaper()
	
func _on_Restart_pressed():
	start_timer()
	reset_score()
	reset_player()
	free_enemy()
	free_coin()
	free_coin_collection()
	free_spellpaper()
	add_coin_collection(get_tree().get_nodes_in_group("player")[0].name, coinCollected)
		
func _on_EnemyTimer_timeout():
	# before spawn enemy reset player positon
	reset_player_position()
	spawn_enemy()
	#$EnemyTimer.wait_time = randi()%3 + 2

func _on_CoinTimer_timeout():
	spawn_coin()
	$CoinTimer.wait_time = randi()%5 + 5

func _on_SpellpaperTimer_timeout():
	spawn_spellpaper()

func _on_Scoreboard_body_entered(body):
	# if enemy hits scoreboard, add a score
	if("enemy" in body.get_groups()):
		add_score()

func add_score():
	score += 1;
	update_score()

func reset_score():
	score = 0
	update_score()
	
func update_score():
	get_node("UI/Menu/Score/Label").text = str(score)

func add_coin_collection(coinType, num):
	var collection = load("res://Scenes/Collection.tscn").instance()
	add_child(collection)
	collection.position = Vector2(60 + (num - 1) * 120, 60)
	collection.get_node("AnimatedSprite").play(coinType)

func free_coin_collection():
	coinCollected = 1
	for collection in get_tree().get_nodes_in_group("collection"):
		collection.free()
		
func init_player(name):
	# add a new player
	var player = load("res://Scenes/" + name + ".tscn").instance()
	add_child(player)
	# player game_over signal connection
	player.connect("game_over", self, "game_over_handle")
	player.connect("hit_coin", self, "hit_coin_handle")
	player.connect("hit_spellpaper", self, "hit_spellpaper_handle")
	player.connect("power_mode_hit", self, "power_mode_hit_handle")
	player.move(playerPos)
	player.gameOver = 0
	if(player.has_method("reset_energy")):
		player.reset_energy()
		
func free_player():
	for player in get_tree().get_nodes_in_group("player"):
		player.queue_free()

func reset_player():
	for player in get_tree().get_nodes_in_group("player"):
		player.move(playerPos)
		player.gameOver = 0
		player.get_node("AnimatedSprite").play("run")
		if(player.has_method("reset_energy")):
			player.reset_energy()
			
func stop_player_move():
	for player in get_tree().get_nodes_in_group("player"):
		player.velocity = Vector2(0, 0)

func reset_player_position():
	var player = get_tree().get_nodes_in_group("player")[0]
	if(player.position.x != 200):
		player.position.x = 200

func spawn_enemy():
	var enemy = load("res://Scenes/Enemy.tscn").instance()
	add_child(enemy)
	enemy.position = $EnemySpawnPos.position
	enemy.velocity.x = enemyVelocityX

func free_enemy():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()

func free_enemy_before_position(x):
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if(enemy.position.x < x):
			enemy.queue_free()

func stop_enemy_move():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.velocity = Vector2(0, 0)

func continue_enemy_move():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.velocity = Vector2(enemyVelocityX, 0)

func spawn_coin():
	var coin = load("res://Scenes/Coin.tscn").instance()
	add_child(coin)
	coin.position = $EnemySpawnPos.position
	#coin.set_coin_type("Ox")
	coin.set_coin_type(animals[randi()%animals.size()])

func free_coin():
	for coin in get_tree().get_nodes_in_group("coin"):
		coin.queue_free()

func stop_coin_move():
	for coin in get_tree().get_nodes_in_group("coin"):
		coin.velocity = Vector2(0, 0)

func continue_coin_move():
	for coin in get_tree().get_nodes_in_group("coin"):
		coin.velocity = Vector2(coinVelocityX, 0)

func spawn_spellpaper():
	var spellpaper = load("res://Scenes/Spellpaper.tscn").instance()
	add_child(spellpaper)
	spellpaper.position = $EnemySpawnPos.position

func free_spellpaper():
	for spellpaper in get_tree().get_nodes_in_group("spellpaper"):
		spellpaper.queue_free()

func stop_spellpaper_move():
	for spellpaper in get_tree().get_nodes_in_group("spellpaper"):
		spellpaper.velocity = Vector2(0, 0)

func continue_spellpaper_move():
	for spellpaper in get_tree().get_nodes_in_group("spellpaper"):
		spellpaper.velocity = Vector2(spellpaperVelocityX, 0)
		
func spawn_fireball(spellpaperName):
	var fireball = load("res://Scenes/Fireball.tscn").instance()
	fireball.position = playerPos
	fireball.get_node("AnimatedSprite").play(spellpaperName)
	get_parent().call_deferred("add_child", fireball)

func start_timer():
	$EnemyTimer.start()
	$CoinTimer.start()
	$SpellpaperTimer.start()
	
func stop_timer():
	$EnemyTimer.stop()
	$CoinTimer.stop()
	$SpellpaperTimer.stop()
	


