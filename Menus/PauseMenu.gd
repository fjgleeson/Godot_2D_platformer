extends Control


var is_paused = false setget set_is_paused

func _ready():
	$CenterContainer/VBoxContainer/Resume.grab_focus()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused
		
		

func set_is_paused(value):
	$CenterContainer/VBoxContainer/Resume.grab_focus()
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused


func _on_Resume_pressed():
	self.is_paused = false
	


func _on_Exit_pressed():
	self.is_paused = false
	get_tree().change_scene("res://Menus/Menu.tscn")
