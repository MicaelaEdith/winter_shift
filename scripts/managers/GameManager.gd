#   GameManager
extends Node

var piso_actual :int = 0
var elementos :Array[String] = ["caldera1", "caldera2"]
var descarga = true
var reparando = false
var jugador_en_elemeto = ""
var activo = ""
var reparar = false
var contra_barra = false
var juego_iniciado = false
var juego_pausado = false
var img_pausa: ColorRect
var img_caldera1: TextureRect
var img_caldera2: TextureRect
var game_over := false
var gana = false


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
			
		if descarga:
			romper_caldera()
			
func romper_caldera() -> void:
	if juego_iniciado and not game_over:
		while true:
			await get_tree().create_timer(6.0).timeout
			if reparar:
				continue

			var caldera = randi_range(0, elementos.size() - 1)
			activo = elementos[caldera]
			reparar = true

			SoundManager.reproducir_caldera()

func _on_caldera_se_rompe() -> void:
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
	
func pause_game():
	if not juego_pausado:
		toggle_pause()

func resume_game():
	if juego_pausado:
		toggle_pause()
	


	
	
	
