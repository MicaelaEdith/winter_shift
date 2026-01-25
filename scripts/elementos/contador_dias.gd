extends Label

@export var label_dias: Label

var dias_totales := 92
var dias_restantes := 92
@export var segundos_por_dia := 4.6

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
	label_dias.text = "You survived the winter!"
	
