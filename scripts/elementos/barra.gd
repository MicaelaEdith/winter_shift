extends ColorRect

@export var total_time: float = 10.0
@export var barra: ColorRect

var time_left: float
var descargando := false
var altura_total: float
var y_inicial: float

func _ready() -> void:
	time_left = total_time
	altura_total = size.y
	y_inicial = barra.position.y
	barra.size.y = altura_total

func iniciar_descarga(segundos: float) -> void:
	total_time = segundos
	time_left = total_time
	descargando = true
	barra.size.y = altura_total
	barra.position.y = y_inicial

func _process(delta: float) -> void:
	if not GameManager.descarga:
		descargando = false
		return

	if not descargando:
		descargando = true

	time_left -= delta
	time_left = max(time_left, 0)

	var ratio := time_left / total_time
	var nueva_altura := altura_total * ratio

	barra.size.y = nueva_altura
	barra.position.y = y_inicial + (altura_total - nueva_altura)

	if time_left <= 0:
		descargando = false
		GameManager.descarga = false
