extends Node

var click : AudioStream = preload("res://assets/audio/click.mp3")
var ding : AudioStream = preload("res://assets/audio/ding.mp3")
var musica : AudioStream = preload("res://assets/audio/musica.mp3")
var caldera : AudioStream = preload("res://assets/audio/caldera.mp3")
var gota : AudioStream = preload("res://assets/audio/gota.mp3")

var player_musica : AudioStreamPlayer

var players_fx: Array[AudioStreamPlayer] = []
const FX_PLAYERS := 5

var volumen_normal = 0

var estado_musica = true
var estado_fx = true


func _ready() -> void:
	player_musica = AudioStreamPlayer.new()
	player_musica.autoplay = false
	add_child(player_musica)

	for i in FX_PLAYERS:
		var p := AudioStreamPlayer.new()
		p.autoplay = false
		p.volume_db = volumen_normal
		add_child(p)
		players_fx.append(p)

	process_mode = Node.PROCESS_MODE_ALWAYS



func reproducir_musica() -> void:
	player_musica.stream = musica
	player_musica.volume_db = -20

	if player_musica.stream.has_method("set_loop"):
		player_musica.stream.set_loop(true)
	elif "loop" in player_musica.stream:
		player_musica.stream.loop = true

	player_musica.play()

func detener_musica() -> void:
	if player_musica.playing:
		player_musica.stop()

func _play_fx(stream: AudioStream, volume := 0) -> void:
	if not estado_fx:
		return

	for p in players_fx:
		if not p.playing:
			p.volume_db = volume
			p.stream = stream
			p.play()
			return

func reproducir_click() -> void:
	_play_fx(click, volumen_normal)

func reproducir_caldera() -> void:
	if caldera.has_method("set_loop"):
		caldera.set_loop(true)
	_play_fx(caldera, -15)

func detener_caldera() -> void:
	for p in players_fx:
		if p.stream == caldera and p.playing:
			p.stop()
			
func reproducir_gota() -> void:
	if gota.has_method("set_loop"):
		gota.set_loop(true)
	_play_fx(gota, 0)

func detener_gota() -> void:
	for p in players_fx:
		if p.stream == gota and p.playing:
			p.stop()



func reproducir_ding() -> void:
	_play_fx(ding, volumen_normal)

func boton_musica():
	if estado_musica:
		estado_musica = false
		detener_musica()
	else:
		reproducir_musica()
		estado_musica = true

func boton_efectos():
	estado_fx = not estado_fx
	if not estado_fx:
		for p in players_fx:
			if p.playing:
				p.stop()
