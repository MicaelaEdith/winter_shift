extends Button

@export var img_fondo_youwin : ColorRect
@export var img_youwin : TextureRect
@export var img_gameover : TextureRect
@export var btn_playagain : Button
@export var botones : CanvasGroup
@export var contador : Label
@export var personaje : CharacterBody2D
@export var posicion_inicial_personaje : Marker2D
@export var luces : Array[ColorRect]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pressed.connect(_on_pressed)

func _on_pressed():
	GameManager.toggle_pause()
	reiniciar_globales()
	
	
func reiniciar_globales():
	GameManager.piso_actual  = 0
	GameManager.descarga = true
	GameManager.reparando = false
	GameManager.jugador_en_elemeto = ""
	GameManager.activo = ""
	GameManager.reparar = false
	GameManager.contra_barra = false
	GameManager.juego_iniciado = false
	GameManager.game_over = false
	GameManager.gana = false
	
	botones.visible = true
	img_fondo_youwin.visible = false
	img_youwin.visible = false
	img_gameover.visible = false
	btn_playagain.visible = false

	personaje.global_position = posicion_inicial_personaje.global_position
	
	luces[0].visible = true
	luces[1].visible = false
	luces[2].visible = false
	luces[3].visible = false
	luces[4].visible = false
	
	GameManager.toggle_pause()
	
	contador.dias_restantes = contador.dias_totales
	contador.actualizar_label()
	contador.iniciar_contador()
	print ("el juego está: ", GameManager.juego_pausado)
	
