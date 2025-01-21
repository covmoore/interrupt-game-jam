@tool
class_name LockButton extends Interactable

signal lock_button_pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_selected(cam: Camera3D, player: Player):
	emit_signal("lock_button_pressed", name)
