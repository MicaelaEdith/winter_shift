extends Node

var gotera_1 : TextureRect
var gotera_2 : TextureRect
var viento_1 : TextureRect
var viento_2 : TextureRect
var desperfecto_electrico_1 : TextureRect
var desperfecto_electrico_2 : TextureRect

var _dias_activados := []


func _buscar_nodos():
	var escena = get_tree().current_scene
	if not escena:
		return
	if not gotera_1:
		if escena.has_node("gotera_1"):
			gotera_1 = escena.get_node("gotera_1")
			gotera_2 = escena.get_node("gotera_2")
			viento_1 = escena.get_node("viento_1")
			viento_2 = escena.get_node("viento_2")
			desperfecto_electrico_1 = escena.get_node("desperfecto_electrico1")
			desperfecto_electrico_2 = escena.get_node("desperfecto_electrico2")


func _process(delta: float) -> void:
	_buscar_nodos()
	if not gotera_1:
		return

	var dia = GameManager.day
	if _dias_activados.has(dia):
		return
	_dias_activados.append(dia)

	_activar_goteras(dia)
	_activar_electrico(dia)
	_activar_viento(dia)


func _activar_goteras(dia: int) -> void:
	if dia in [90, 68, 44, 21, 5]:
		gotera_2.visible = true
		GameManager.leaking_techo = "techo_2"
		SoundManager.reproducir_gota()
	elif dia in [88, 79, 51, 36, 11]:
		gotera_1.visible = true
		GameManager.leaking_techo = "techo_1"
		SoundManager.reproducir_gota()


func _activar_electrico(dia: int) -> void:
	if dia in [86, 66, 46, 26, 6]:
		desperfecto_electrico_2.visible = true
		GameManager.broken_electrico = "desperfecto_electrico2"
		SoundManager.reproducir_gota()
	elif dia in [76, 56, 38, 19, 2]:
		desperfecto_electrico_1.visible = true
		GameManager.broken_electrico = "desperfecto_electrico1"
		SoundManager.reproducir_gota()


func _activar_viento(dia: int) -> void:
	if dia in [83, 62, 42, 22, 10]:
		viento_2.visible = true
		GameManager.broken_viento = "viento_2"
		SoundManager.reproducir_gota()
	elif dia in [73, 53, 33, 14]:
		viento_1.visible = true
		GameManager.broken_viento = "viento_1"
		SoundManager.reproducir_gota()
