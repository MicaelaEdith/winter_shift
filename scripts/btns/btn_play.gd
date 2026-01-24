extends Button

@export var escena : PackedScene

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		SoundManager.reproducir_click()
		get_tree().change_scene_to_packed(escena)
