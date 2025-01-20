extends Control

@onready var hud: Control = $CanvasLayer/MarginContainer/HUD
@onready var interactMenu: Control = $CanvasLayer/MarginContainer/InteractMenu
signal cancel_interaction


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactMenu.visible = false
	var interactables = get_tree().get_nodes_in_group("interactable")
	for interactable in interactables:
		interactable.connect("on_object_interacted", _on_object_interacted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_object_interacted() -> void:
	interactMenu.visible = true

func _on_button_button_down() -> void:
	interactMenu.visible = false
	emit_signal("cancel_interaction")
