extends Node

var gotera_1 : TextureRect
var gotera_2 : TextureRect
var viento_1 : TextureRect
var viento_2 : TextureRect
var desperfecto_electrico_1 : TextureRect
var desperfecto_electrico_2 : TextureRect

var _goteras_activadas := []


func _buscar_nodos():
	if not gotera_1:
		var escena = get_tree().current_scene
		if escena and escena.has_node("gotera_1"):
			gotera_1 = escena.get_node("gotera_1")
			gotera_2 = escena.get_node("gotera_2")


func _process(delta: float) -> void:
	_buscar_nodos()
	if not gotera_1:
		return

	if GameManager.day in [90, 68, 44, 21, 5]:
		if not _goteras_activadas.has(GameManager.day):
			_goteras_activadas.append(GameManager.day)
			gotera_2.visible = true
			GameManager.leaking_techo = "techo_2"
			SoundManager.reproducir_gota()

	if GameManager.day in [88, 79, 51, 36, 11]:
		if not _goteras_activadas.has(GameManager.day):
			_goteras_activadas.append(GameManager.day)
			gotera_1.visible = true
			GameManager.leaking_techo = "techo_1"
			SoundManager.reproducir_gota()
