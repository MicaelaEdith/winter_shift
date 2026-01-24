#   GameManager
extends Node

var piso_actual :int = 0
var descarga = false
#@onready var barra := get_node("/root/main/caldera1/barra")

func _ready() -> void:
	if SoundManager.estado_musica:
		SoundManager.reproducir_musica()
#	barra = get_node("/root/main/caldera1/barra")


	
	
