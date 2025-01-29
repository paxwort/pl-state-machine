extends ColorRect

var simon_index = 0
@export var say_color : Color
@export var ordinary_color : Color


func _on_say_color(i :int):
	if (i == simon_index):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "color", say_color, .2)
		tween.tween_property(self, "color", ordinary_color, 1)
