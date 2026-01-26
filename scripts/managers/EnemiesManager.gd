extends Node

var gotera_1 : TextureRect
var gotera_2 : TextureRect
var viento_1 : TextureRect
var viento_2 : TextureRect
var desperfecto_electrico_1 : TextureRect
var desperfecto_electrico_2 : TextureRect
var personaje : CharacterBody2D

func _ready() -> void:
	gotera_1 = get_tree().current_scene.get_node("gotera_1")
	gotera_2 = get_tree().current_scene.get_node("gotera_2")
	personaje = get_tree().current_scene.get_node("personaje")
	
func _process(delta: float) -> void:
	if GameManager.dia == 90 or GameManager.dia == 68 or GameManager.dia == 44 or GameManager.dia == 21 or GameManager.dia == 5:
		if not gotera_1 or not gotera_2:
			gotera_1 = get_tree().current_scene.get_node("gotera_1")
			gotera_2 = get_tree().current_scene.get_node("gotera_2")
			
		gotera_2.visible = true
		GameManager.activo = "techo_2"
		if not personaje:
			personaje = get_tree().current_scene.get_node("personaje")
		personaje.puede_reparar = true
		SoundManager.reproducir_gota()
		#gotera_2.visible = true
		
	if GameManager.dia == 88 or GameManager.dia == 79 or GameManager.dia == 51 or GameManager.dia == 36 or GameManager.dia == 11:
		if not gotera_1 or not gotera_2:
			gotera_1 = get_tree().current_scene.get_node("gotera_1")
			gotera_2 = get_tree().current_scene.get_node("gotera_2")
			
		gotera_1.visible = true
		GameManager.activo = "techo_1"
		if not personaje:
			personaje = get_tree().current_scene.get_node("personaje")
		personaje.puede_reparar = true
		SoundManager.reproducir_gota()
		#gotera_2.visible = true
	
	
