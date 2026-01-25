extends Node2D

@onready var imagen := $imagen
@onready var fade_rect := ColorRect.new()

var transiciones_imagenes := [
	[
		preload("res://assets/menu_transiciones/transicion_1.png"),
		preload("res://assets/menu_transiciones/transicion_2.png"),
		preload("res://assets/menu_transiciones/transicion_3.png")
	],
]

var escenas_destino := [
	"res://escenas/main.tscn"
]

var indice_imagen := 0
var actual_lista := []
var escena_destino := ""


func _ready():
	fade_rect.color = Color.BLACK
	fade_rect.size = get_viewport_rect().size
	fade_rect.visible = false
	fade_rect.modulate.a = 0.0
	add_child(fade_rect)


	var indice_transicion = clamp(0, 0, transiciones_imagenes.size() - 1)
	actual_lista = transiciones_imagenes[indice_transicion]
	escena_destino = escenas_destino[indice_transicion]

	if actual_lista.is_empty():
		_cargar_siguiente_escena()
		return
	imagen.texture = actual_lista[0]


func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		SoundManager.reproducir_click()
		_mostrar_siguiente()


func _mostrar_siguiente():
	indice_imagen += 1
	if indice_imagen < actual_lista.size():
		imagen.texture = actual_lista[indice_imagen]
	else:
		_iniciar_fade_out()

func _iniciar_fade_out():
	fade_rect.set_size(Vector2(8000, 4500))
	fade_rect.visible = true
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5)
	tween.finished.connect(_cargar_siguiente_escena)


func _cargar_siguiente_escena():
	GameManager.juego_iniciado = true
	get_tree().change_scene_to_file(escena_destino)
