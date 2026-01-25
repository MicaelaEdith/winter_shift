extends Label

@export var img_fondo_youwin : ColorRect
@export var img_youwin : TextureRect
@export var img_gameover : TextureRect
@export var label_dias : Label
@export var btn_playagain : Button
@export var botones : CanvasGroup

var dias_totales := 3
var dias_restantes := 3 
@export var segundos_por_dia := 3

func _ready() -> void:
	actualizar_label()
	iniciar_contador()

func iniciar_contador() -> void:
	while dias_restantes > 0 and not GameManager.juego_pausado:
		await get_tree().create_timer(segundos_por_dia).timeout
		dias_restantes -= 1
		actualizar_label()

	if dias_restantes == 0 and not GameManager.juego_pausado:
		ganar_juego()

func actualizar_label() -> void:
	if label_dias:
		label_dias.text = "Days left: %d" % dias_restantes

func ganar_juego() -> void:
	GameManager.gana = true
	GameManager.game_over = true
	botones.visible = false
	img_fondo_youwin.visible = true
	img_youwin.visible = true
	btn_playagain.visible = true
	
	
