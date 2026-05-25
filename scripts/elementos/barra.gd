extends ColorRect

@export var total_time: float = 15.0
@export var velocidad_carga := 2
@export var barra: ColorRect
@export var elemento : String

var time_left: float
var cargar:= false
var altura_total: float
var y_inicial: float
var _ultimo_broken_boiler := ""


func _ready() -> void:
	time_left = total_time
	altura_total = size.y
	y_inicial = barra.position.y
	barra.size.y = altura_total


func _process(delta: float) -> void:
	if GameManager.broken_boiler != _ultimo_broken_boiler:
		_ultimo_broken_boiler = GameManager.broken_boiler
		if GameManager.broken_boiler == elemento:
			time_left = total_time

	if GameManager.drain_active and GameManager.broken_boiler == elemento and not cargar:
		time_left -= delta
		time_left = max(time_left, 0)

		var ratio := time_left / total_time
		var nueva_altura := altura_total * ratio

		barra.size.y = nueva_altura
		barra.position.y = y_inicial + (altura_total - nueva_altura)

		if time_left <= 0:
			GameManager.drain_active = false

	if cargar:
		if Input.is_action_pressed("ui_accept"):
			time_left += delta * velocidad_carga
			time_left = min(time_left, total_time)

		var ratio := time_left / total_time
		var nueva_altura := altura_total * ratio

		barra.size.y = nueva_altura
		barra.position.y = y_inicial + (altura_total - nueva_altura)

		if time_left >= total_time:
			cargar = false
			SoundManager.detener_caldera()
			GameManager.broken_boiler = ""
			GameManager.drain_active = false
