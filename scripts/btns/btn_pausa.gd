extends Button

@export var contador: Label

func _ready():
	pressed.connect(_on_pressed)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_pressed():
	SoundManager.reproducir_click()
	get_viewport().gui_release_focus()
	GameManager.toggle_pause()
	if GameManager.paused:
		contador.pausar()
	else:
		contador.reanudar()
