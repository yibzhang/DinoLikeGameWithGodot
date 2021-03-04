extends Node2D

var score = 0
var bossList = [
	"Pig",
	"Sheep",
	"Monkey",
	"Rooster", 
	"Mouse", 
	"Rabbit", 
	"Dog",
	"Tiger", 
	"Horse", 
	"Ox",
	"Snake",
	"Dragon"]
var bossCounter = 0
var animals = []
var coinCollected = 1
var enemyVelocityX = -200
var coinVelocityX = -300
var spellpaperVelocityX = -400
var playerPos = Vector2(150, 502)
var playerPowerMode = 0

const CONFIG_FILE = "user://config.json"
var passcode="fwegfuywe7r632r732fdjghfvjhfesedwfcdewqyhfewjf"
var gameData:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	init_animals()
	init_highscore()
	init_bossCounter()
	update_highscore()
	update_unlocked()
	update_bossCounter()
	#animals = ['Dragon']

func clear_game_record():
	var file = File.new()
	gameData["animals"] = ["Ox"]
	gameData["HighScore"] = 0
	gameData["BossCounter"] = 0
	file.open_encrypted_with_pass(CONFIG_FILE, File.WRITE, passcode)
	file.store_var(to_json(gameData), true)
	file.close()
	
func save_game():
	var file = File.new()
	file.open_encrypted_with_pass(CONFIG_FILE, File.WRITE, passcode)
	file.store_var(to_json(gameData), true)
	file.close()

func load_game():
	var file = File.new()
	if file.file_exists(CONFIG_FILE):
		file.open_encrypted_with_pass(CONFIG_FILE, File.READ, passcode)
		var loadParam = parse_json(file.get_var(true));
		file.close()
		if loadParam != null:
			gameData = loadParam;
	# if game saving file not exists, create one
	else:
		save_game()

func init_animals():
	if(!gameData.has("animals")):
		gameData["animals"] = ["Ox"]
		save_game()
	else:
		if(gameData["animals"].size() == 0):
			gameData["animals"] = ["Ox"]
			save_game()
	animals = gameData["animals"]

func init_highscore():
	if(!gameData.has("HighScore")):
		gameData["HighScore"] = 0
		save_game()

func init_bossCounter():
	if(!gameData.has("BossCounter")):
		gameData["BossCounter"] = 0
		save_game()

func update_highscore():
	var highScoreLabel = get_node("UI/Menu/HighScore/score")
	if(score > gameData.HighScore):
		gameData.HighScore = score
		save_game()
		highScoreLabel.text = str(score)
	else:
		highScoreLabel.text = str(gameData["HighScore"])

func update_unlocked():
	var unlockedAnimals = gameData["animals"]
	var unlockedNode = get_node("UI/Menu/Unlocked")
	unlockedNode.update_unlocked(unlockedAnimals)
	#var unlockedNode = get_node("UI/Menu/Unlocked/animals")
	#unlockedNode.text = str(unlockedAnimals)

func update_bossCounter():
	bossCounter = gameData["BossCounter"]

func _on_Start_pressed():
	$HitCoinAudio.play()
	$BackgroundAudio.play()
	$Background.gameOver = false
	var animal = animals[randi()%animals.size()]
	#print(animals)
	start_timer()
	init_player(animal)
	add_coin_collection(animal, 1)
	#boss_time()

func hit_coin_handle(coinName):
	var player = get_tree().get_nodes_in_group("player");
	# if player name is not same as coin name, animal swap
	# else add coin into coin collection
	if(player[0].name != coinName):
		$VanishAudio.play()
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
		$HitCoinAudio.play()
		if(coinCollected < 3):
			coinCollected += 1;
			add_coin_collection(coinName, coinCollected)
		if(coinCollected == 3):
			start_power_mode()

func hit_spellpaper_handle(spellpaperName):
	spawn_fireball(spellpaperName)

func power_mode_hit_handle():
	add_score()
		
func game_over_handle():
	$GameoverAudio.play()
	$BackgroundAudio.stop()
	$Background.gameOver = true
	update_highscore()
	get_node("UI/Menu/Restart").move(Vector2(0, 300))
	stop_timer()
	stop_player_move()
	stop_enemy_move()
	stop_coin_move()
	stop_spellpaper_move()

func _on_BackToStart_pressed():
	$BackgroundAudio.stop()
	$Background.gameOver = true
	update_highscore()
	stop_timer()
	reset_score()
	free_player()
	free_enemy()
	free_coin()
	free_coin_collection()
	free_spellpaper()
	free_boss()
	
func _on_Restart_pressed():
	$BackgroundAudio.play()
	$Background.gameOver = false
	start_timer()
	reset_score()
	reset_player()
	free_enemy()
	free_coin()
	free_coin_collection()
	free_spellpaper()
	free_boss()
	add_coin_collection(get_tree().get_nodes_in_group("player")[0].name, coinCollected)
		
func _on_EnemyTimer_timeout():
	# before spawn enemy reset player positon
	reset_player_position()
	spawn_enemy()
	if(!playerPowerMode):
		$EnemyTimer.wait_time = 2 + randi()%4

func _on_CoinTimer_timeout():
	spawn_coin()
	$CoinTimer.wait_time = 5 + randi()%6

func _on_SpellpaperTimer_timeout():
	spawn_spellpaper()
	$SpellpaperTimer.wait_time = 5 + randi()%6

func _on_Scoreboard_body_entered(body):
	# if enemy hits scoreboard, add a score
	if("enemy" in body.get_groups()):
		add_score()

func add_score():
	score += 1;
	update_score()
	if((score%50 == 0) and (score>0)):
		boss_time()

func reset_score():
	score = 0
	update_score()
	
func update_score():
	get_node("UI/Menu/Score/Label").text = str(score)

func add_coin_collection(coinType, num):
	var collection = load("res://Scenes/Collection.tscn").instance()
	add_child(collection)
	collection.position = Vector2(60 + (num - 1) * 120, 120)
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
	if(player.position.x != playerPos.x):
		player.position.x = playerPos.x

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
	spellpaper.position = $EnemySpawnPos.position
	spellpaper.set_spellpaper_type(animals[randi()%animals.size()])
	add_child(spellpaper)

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
	fireball.get_node(spellpaperName).set_deferred("disabled", false);
	get_parent().call_deferred("add_child", fireball)

func start_timer():
	$EnemyTimer.start()
	$CoinTimer.start()
	$SpellpaperTimer.start()
	
func stop_timer():
	$EnemyTimer.stop()
	$CoinTimer.stop()
	$SpellpaperTimer.stop()
	
func _on_Quit_pressed():
	get_tree().quit()
	
func start_power_mode():
	var player = get_tree().get_nodes_in_group("player")
	# can't go back to start during power mode
	get_node("UI/Menu/BackToStart").hide()
	free_coin()
	stop_timer()

	# make enemy move faster
	enemyVelocityX = -1000
	continue_enemy_move()
	$EnemyTimer.wait_time = 0.2
	$EnemyTimer.start()
	
	# set player power mode
	playerPowerMode = 1
	player[0].powerMode = playerPowerMode
	$PowerModeTimer.start()

func stop_power_mode():
	var player = get_tree().get_nodes_in_group("player");
	# recover backtostart button
	get_node("UI/Menu/BackToStart").show()
	free_enemy()
	stop_timer()
	
	# recover enemy speed
	enemyVelocityX = -200
	$EnemyTimer.wait_time = 3
	start_timer()

	# recover coin collection
	free_coin_collection()
	add_coin_collection(player[0].name, coinCollected)

	# unset player power mode
	playerPowerMode = 0
	player[0].powerMode = playerPowerMode
	$PowerModeTimer.stop()

func _on_PowerModeTimer_timeout():
	stop_power_mode()

func boss_time():
	add_notification("Boss Time")
	var player = get_tree().get_nodes_in_group("player")
	# if it's in power mode then stop power mode
	if(player[0].powerMode):
		stop_power_mode()
	# boss time
	#print("boss time")
	free_enemy()
	free_coin()
	free_spellpaper()
	stop_timer()
	# stop all timer expect spell paper
	$SpellpaperTimer.start()
	spawn_boss()

func spawn_boss():
	# spawn the boss
	var boss = load("res://Scenes/Boss" + bossList[bossCounter] + ".tscn").instance()
	get_parent().call_deferred("add_child", boss)
	boss.position = $BossSpawnPos.position
	
func free_boss():
	for boss in get_tree().get_nodes_in_group("boss"):
		boss.queue_free()

func boss_killed():
	add_notification("Boss Killed")
	var boss = get_tree().get_nodes_in_group("boss")
	var newAnimal = boss[0].name.substr(4, -1)
	# add killed boss into animal list
	if(!animals.has(newAnimal)):
		animals.append(newAnimal)
		gameData["animals"] = animals
		save_game()
	# free boss
	boss[0].queue_free()
	# recover game
	start_timer()
	# update unlocked
	update_unlocked()
	add_bossCounter()

func add_bossCounter():
	if(bossCounter < bossList.size() - 1):
		bossCounter += 1
	else:
		bossCounter = 0
	gameData["BossCounter"] = bossCounter
	save_game()

# clear game record
func _on_Yes_pressed():
	clear_game_record()
	update_highscore()
	update_unlocked()
	animals = gameData["animals"]
	bossCounter = gameData["BossCounter"]

func add_notification(text):
	var alarm = get_node("UI/Menu/Notification")
	alarm.get_node("Label").text = text
	alarm.reset()
	alarm.start_timer()
	alarm.move_in()
