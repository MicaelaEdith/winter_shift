# BARRA

extends ColorRect

@export var total_time: float = 15.0
@export var velocidad_carga := 2
@export var barra: ColorRect
@export var elemento : String

var time_left: float
var descargando := false
var cargar:= false
var altura_total: float
var y_inicial: float

func _ready() -> void:
	time_left = total_time
	altura_total = size.y
	y_inicial = barra.position.y
	barra.size.y = altura_total

func _process(delta: float) -> void:
	
	# DESCARGA
	if GameManager.descarga and GameManager.caldera_rota == elemento:# and not GameManager.jugador_en_elemeto == elemento:
		
		#print("[BARRA] - La caldera se está descargando")
		time_left -= delta
		time_left = max(time_left, 0)

		var ratio := time_left / total_time
		var nueva_altura := altura_total * ratio

		barra.size.y = nueva_altura
		barra.position.y = y_inicial + (altura_total - nueva_altura)

		if time_left <= 0:
			GameManager.descarga = false

	# CARGA
	elif cargar:
		#print("[BARRA] - La caldera se está cargando")
		if Input.is_action_pressed("ui_accept"):
			print("[BARRA] - Reparando")
			time_left += delta * velocidad_carga
			time_left = min(time_left, total_time)
			

		var ratio := time_left / total_time
		var nueva_altura := altura_total * ratio

		barra.size.y = nueva_altura
		barra.position.y = y_inicial + (altura_total - nueva_altura)

		if time_left >= total_time:
			cargar = false
			GameManager.reparar = false
			if GameManager.activo == "caldera1" or GameManager.activo == "caldera2":
				SoundManager.detener_caldera()
				GameManager.hay_caldera_rota = false # con esto manejo el game over, NO BORRAR!!!
			GameManager.activo = ""
			GameManager.caldera_rota = ""
			GameManager.activos.erase(GameManager.activo)
			
func iniciar_descarga(segundos: float) -> void:
	if elemento == GameManager.activo and not GameManager.jugador_en_elemeto == elemento:		
		total_time = segundos
		time_left = total_time
		descargando = true
		barra.size.y = altura_total
		barra.position.y = y_inicial
		
func iniciar_carga(segundos: float) -> void:
	if elemento == GameManager.caldera_rota and GameManager.jugador_en_elemeto == elemento:
		total_time = segundos
		time_left = 0
		cargar = true
