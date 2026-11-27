extends Control

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/race.tscn")

func _on_settings_pressed():
	GameManager.graphics_quality = (GameManager.graphics_quality + 1) % 3
	var names = ["Low", "Medium", "High"]
	$VBox/SettingsBtn.text = "Graphics: " + names[GameManager.graphics_quality]
	GameManager.save_settings()

func _on_quit_pressed():
	get_tree().quit()
