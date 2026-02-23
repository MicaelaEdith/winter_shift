#   GameManager
extends Node

var piso_actual :int = 0
var elementos : Array[String] = ["caldera1", "caldera2"]
var dias_array : Array[int] = [91,81,72,63,52,43,34,25,17,9]
var activos : Array[String]
var descarga = true
var reparando = false
var jugador_en_elemeto = ""
var activo = ""
var reparar = false
var contra_barra = false
var juego_iniciado = true
var juego_pausado = false
var img_pausa: ColorRect
var img_caldera1: TextureRect
var img_caldera2: TextureRect
var game_over := false
var gana = false
var dia = 92
var personaje_puede_reparar = false
var hay_caldera_rota = false
var caldera_rota = ""


func _ready() -> void:
	if SoundManager.estado_musica:
		SoundManager.reproducir_musica()
		
	img_pausa = get_tree().current_scene.get_node("img_pausa")
	img_caldera1 = get_tree().current_scene.get_node("caldera1")
	img_caldera2 = get_tree().current_scene.get_node("caldera2")
		
func _process(delta: float) -> void:
	if not game_over:
		if reparando:
			elementos.find(jugador_en_elemeto)
			
		if dias_array.has(dia):
			if hay_caldera_rota:
				game_over = true
			romper_caldera()
	
	else:
		game_over_()
		
func romper_caldera() -> void:
	if juego_iniciado and not game_over:
		personaje_puede_reparar = true
		while true:
			await get_tree().create_timer(5.0).timeout
			if reparar:
				continue
				
			var caldera = randi_range(0, 1)
			caldera_rota = elementos[caldera]
			activos.append(activo)
			reparar = true
			hay_caldera_rota = true

			SoundManager.reproducir_caldera()

func _on_caldera_se_rompe():
	reparar = true
	
func toggle_pause():
	juego_pausado = !juego_pausado
	get_tree().paused = juego_pausado
	if juego_pausado:
		SoundManager.player_musica.volume_db = -30
		if img_pausa == null:
			img_pausa = get_tree().current_scene.get_node("img_pausa")
		img_pausa.visible = true
		if img_caldera1 == null:
			img_caldera1 = get_tree().current_scene.get_node("caldera1")
			img_caldera1.visible = false
		if img_caldera2 == null:
			img_caldera2 = get_tree().current_scene.get_node("caldera2")
			img_caldera2.visible = false
			
	else:
		img_pausa.visible = false
		SoundManager.player_musica.volume_db = -20
		SoundManager.detener_caldera()
	
func pause_game():
	if not juego_pausado:
		toggle_pause()

func resume_game():
	if juego_pausado:
		toggle_pause()
	
func game_over_():
	print("perdió")

	
	
	
