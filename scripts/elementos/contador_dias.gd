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
var _game_over_mostrado := false
@export var segundos_por_dia := 3

var _timer_contador: Timer
var cold_overlay: ColorRect

func _ready() -> void:
	actualizar_label()
	_timer_contador = Timer.new()
	_timer_contador.one_shot = true
	_timer_contador.timeout.connect(_on_dia_pasado)
	add_child(_timer_contador)
	cold_overlay = get_tree().current_scene.get_node("cold_overlay")
	iniciar_contador()


func _process(delta: float) -> void:
	if GameManager.game_over:
		if not GameManager.won and not _game_over_mostrado:
			_game_over_mostrado = true
			perder_juego()
		return

	if cold_overlay:
		cold_overlay.color.a = min(GameManager.cold_level / GameManager.max_cold, 0.35)


func _on_dia_pasado():
	if pausar_contador or dias_restantes <= 0:
		return
	dias_restantes -= 1
	GameManager.day = dias_restantes
	actualizar_label()
	GameManager.accumulate_cold()
	if dias_restantes <= 0:
		ganar_juego()
	elif GameManager.game_over:
		pass
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

func perder_juego() -> void:
	GameManager.game_over = true
	botones.visible = false
	img_fondo_youwin.visible = false
	img_youwin.visible = false
	img_gameover.visible = true
	btn_playagain.visible = true
	if cold_overlay:
		cold_overlay.color = Color(0.016, 0.033, 0.065, 0.95)
	SoundManager.reproducir_pierde()
	pausar()


func ganar_juego() -> void:
	GameManager.won = true
	GameManager.game_over = true
	botones.visible = false
	img_fondo_youwin.visible = true
	img_youwin.visible = true
	img_gameover.visible = false
	btn_playagain.visible = true
	SoundManager.reproducir_gana()
