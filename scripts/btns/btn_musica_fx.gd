extends Button

@export var tipo_boton: String = "" 

func _ready():
	pressed.connect(_on_pressed)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_pressed():
	get_viewport().gui_release_focus()
	SoundManager.reproducir_click()

	var muted := false
	match tipo_boton:
		"musica":
			muted = SoundManager.estado_musica
			SoundManager.boton_musica()
		"efectos":
			muted = SoundManager.estado_fx
			SoundManager.boton_efectos()

	if muted:
		modulate.a = 0.4
	else:
		modulate.a = 1
	

	
