extends StaticBody2D


func hit(bullet:KinematicBody2D = null):
	get_parent().hit(bullet)