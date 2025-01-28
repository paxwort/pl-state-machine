extends Line2D


func _ready():
	var transition = get_parent() as PLStateTransition
	if transition:
		transition.transitioned.connect(flash_transition)
		
func flash_transition():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "default_color", Color.AQUAMARINE, .1)
	tween.tween_property(self, "default_color", Color.WHITE, 1)
