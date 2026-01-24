extends Node

var click : AudioStream = preload("res://assets/audio/click.mp3")
var ding : AudioStream = preload("res://assets/audio/ding.mp3")
var musica : AudioStream = preload("res://assets/audio/musica.mp3")

var player_musica : AudioStreamPlayer
var player_efectos : AudioStreamPlayer

var estado_musica = true
var estado_fx = true

func _ready() -> void:
	player_musica = AudioStreamPlayer.new()
	player_musica.autoplay = false
	add_child(player_musica)
	
	player_efectos = AudioStreamPlayer.new()
	player_efectos.autoplay = false
	add_child(player_efectos)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func reproducir_musica() -> void:
	player_musica.stream = musica
	player_musica.volume_db = -20

	if player_musica.stream.has_method("set_loop"):
		player_musica.stream.set_loop(true)
	elif "loop" in player_musica.stream:
		player_musica.stream.loop = true

	#3player_musica.play()


func detener_musica() -> void:
	if player_musica.playing:
		player_musica.stop()

func reproducir_click() -> void:
	if estado_fx:
		player_efectos.stream = click
		player_efectos.play()
		
func reproducir_ding() -> void:
	if estado_fx:
		player_efectos.stream = ding
		player_efectos.play()
		
func boton_musica():
	if estado_musica:
		estado_musica = false
		detener_musica()
	else:
		reproducir_musica()
		estado_musica = true
		
func boton_efectos():
	if estado_fx:
		estado_fx = false
	else:
		estado_fx= true
