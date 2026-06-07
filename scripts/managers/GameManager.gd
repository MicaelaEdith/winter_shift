extends Node

var floor := 0
var day := 92
var game_over := false
var won := false
var paused := false
var cold_level := 0.0
var max_cold := 100.0

var player_zone: String = ""
var broken_boiler: String = ""
var leaking_techo: String = ""
var broken_electrico: String = ""
var broken_viento: String = ""
var drain_active := true

var img_pausa: ColorRect
var img_caldera1: TextureRect
var img_caldera2: TextureRect

var _boiler_break_days: Array[int] = [91, 81, 72, 63, 52, 43, 34, 25, 17, 9]
var _days_with_boiler_break: Array[int] = []


func _ready() -> void:
	if SoundManager.estado_musica:
		SoundManager.reproducir_musica()


func _process(delta: float) -> void:
	if game_over:
		return

	if _boiler_break_days.has(day) and not _days_with_boiler_break.has(day):
		if broken_boiler != "":
			cold_level += 30.0
			_days_with_boiler_break.append(day)
			if cold_level >= max_cold:
				game_over = true
		else:
			_break_boiler()


func _break_boiler() -> void:
	var caldera = randi_range(0, 1)
	broken_boiler = ["caldera1", "caldera2"][caldera]
	_days_with_boiler_break.append(day)
	drain_active = true
	SoundManager.reproducir_caldera()


func accumulate_cold() -> void:
	if game_over:
		return
	var problems := 0
	if leaking_techo != "":
		problems += 1
	if broken_electrico != "":
		problems += 1
	if broken_viento != "":
		problems += 1
	cold_level += problems * 5.0
	if broken_boiler != "":
		if drain_active:
			cold_level += 3.0
		else:
			cold_level += 15.0
	if cold_level >= max_cold:
		game_over = true


func _buscar_img_pausa():
	var escena = get_tree().current_scene
	if not escena:
		return
	if img_pausa == null and escena.has_node("img_pausa"):
		img_pausa = escena.get_node("img_pausa")
	if img_caldera1 == null and escena.has_node("caldera1"):
		img_caldera1 = escena.get_node("caldera1")
	if img_caldera2 == null and escena.has_node("caldera2"):
		img_caldera2 = escena.get_node("caldera2")


func toggle_pause():
	paused = !paused
	get_tree().paused = paused
	if paused:
		SoundManager.player_musica.volume_db = -30
		_buscar_img_pausa()
		if img_pausa:
			img_pausa.visible = true
		if img_caldera1:
			img_caldera1.visible = false
		if img_caldera2:
			img_caldera2.visible = false

	else:
		if img_pausa:
			img_pausa.visible = false
		SoundManager.player_musica.volume_db = -20
		SoundManager.detener_caldera()


func pause_game():
	if not paused:
		toggle_pause()


func resume_game():
	if paused:
		toggle_pause()
