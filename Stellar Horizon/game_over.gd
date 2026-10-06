extends Control

@export var level_scene: PackedScene

func _ready():
	# Show the current run's score on the screen
	$CenterContainer/VBoxContainer/Label2.text = "SCORE: " + str(Global.score)

	# Save and fetch leaderboard
	Database.save_score(Global.score)
	var top_scores = Database.get_leaderboard()

	# Build the leaderboard text string
	var leaderboard_text = "\n--- TOP 5 SCORES ---\n"
	var rank = 1
	for row in top_scores:
		leaderboard_text += str(rank) + ". " + str(row["score"]) + "\n"
		rank += 1
	
	# Assigbn the leaderboard text to the Label node
	$CenterContainer/VBoxContainer/Label3.text = leaderboard_text

	# 3. Print them in the Godot Output console
	print("--- TOP 5 SCORES ---")
	for row in top_scores:
		print("Score: ", row["score"])

func _input(event):
	if event.is_action_pressed("Shoot"):
		get_tree().change_scene_to_packed(level_scene)