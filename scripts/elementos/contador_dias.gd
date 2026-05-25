extends Label

@export var img_fondo_youwin : ColorRect
@export var img_youwin : TextureRect
@export var img_gameover : TextureRect
@export var label_dias : Label
@export var btn_playagain : Button
@export var botones : CanvasGroup

var pausar_contador = false
var dias_totales := 92
var dias_restantes := 92
@export var segundos_por_dia := 3

var _timer_contador: Timer

func _ready() -> void:
	actualizar_label()
	_timer_contador = Timer.new()
	_timer_contador.one_shot = true
	_timer_contador.timeout.connect(_on_dia_pasado)
	add_child(_timer_contador)
	iniciar_contador()
	
func _on_dia_pasado():
	if pausar_contador or dias_restantes <= 0:
		return
	dias_restantes -= 1
	GameManager.day = dias_restantes
	actualizar_label()
	if dias_restantes <= 0:
		ganar_juego()
	else:
		_timer_contador.start(segundos_por_dia)

func iniciar_contador() -> void:
	if dias_restantes > 0:
		_timer_contador.start(segundos_por_dia)

func pausar() -> void:
	pausar_contador = true
	_timer_contador.stop()

func reanudar() -> void:
	pausar_contador = false
	if dias_restantes > 0:
		_timer_contador.start(segundos_por_dia)

func actualizar_label() -> void:
	if label_dias:
		label_dias.text = "Days left: %d" % dias_restantes

func ganar_juego() -> void:
	GameManager.won = true
	GameManager.game_over = true
	botones.visible = false
	img_fondo_youwin.visible = true
	img_youwin.visible = true
	btn_playagain.visible = true
	
	
	
