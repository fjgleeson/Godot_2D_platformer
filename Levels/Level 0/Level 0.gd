extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if "Player" in body.name:
		body.damage(1)


