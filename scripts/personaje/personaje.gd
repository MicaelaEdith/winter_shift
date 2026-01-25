# Personaje
extends CharacterBody2D

@export var velocidad := 200.0
@export var gravedad := 1200.0
@export var marca_pb: Marker2D
@export var marca_p1: Marker2D
@export var marca_p2: Marker2D
@export var marca_p3: Marker2D
@export var marca_p4: Marker2D
@export var luz_pb: ColorRect
@export var luz_p1: ColorRect
@export var luz_p2: ColorRect
@export var luz_p3: ColorRect
@export var luz_p4: ColorRect

var esta_en_ascensor := false
var sumando := false

func _ready() -> void:
	actualizar_luz()

	
func _physics_process(delta):
	var direccion := 0
	
	if Input.is_action_pressed("ui_left"):
		direccion -= 1
	if Input.is_action_pressed("ui_right"):
		direccion += 1
	
	velocity.x = direccion * velocidad
	
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = 0
	move_and_slide()
	
	if esta_en_ascensor:		
		if Input.is_action_just_pressed("ui_up"):
			subir()
		elif Input.is_action_just_released("ui_up"):
			sumando = false
			posicionar_personaje()
		if Input.is_action_just_pressed("ui_down"):
			bajar()
		elif Input.is_action_just_released("ui_down"):
			sumando = false
			posicionar_personaje()

func _on_ascensor_body_entered(body: Node2D) -> void:
	esta_en_ascensor = true
	
func _on_ascensor_body_exited(body: Node2D) -> void:
	esta_en_ascensor = false

func subir():
	if sumando:
		return
	sumando = true
	while sumando:
		actualizar_luz()
		await get_tree().create_timer(0.9).timeout
		if GameManager.piso_actual <= 3:
			GameManager.piso_actual += 1
		else:
			return
	
func bajar():
	if sumando:
		return
	sumando = true
	while sumando:
		actualizar_luz()
		await get_tree().create_timer(0.9).timeout
		if GameManager.piso_actual > 0:
			GameManager.piso_actual -= 1
		else:
			return

func posicionar_personaje():
	if GameManager.piso_actual == 0:
		global_position = marca_pb.global_position
	elif GameManager.piso_actual == 1:
		global_position = marca_p1.global_position
	elif GameManager.piso_actual == 2:
		global_position = marca_p2.global_position
	elif GameManager.piso_actual == 3:
		global_position = marca_p3.global_position
	elif GameManager.piso_actual == 4:
		global_position = marca_p4.global_position
	SoundManager.reproducir_ding()
	actualizar_luz()

func actualizar_luz():
	luz_pb.visible = false
	luz_p1.visible = false
	luz_p2.visible = false
	luz_p3.visible = false
	luz_p4.visible = false
	
	if GameManager.piso_actual == 0:
		luz_pb.visible = true
	elif GameManager.piso_actual == 1:
		luz_p1.visible = true
	elif GameManager.piso_actual == 2:
		luz_p2.visible = true
	elif GameManager.piso_actual == 3:
		luz_p3.visible = true
	elif GameManager.piso_actual == 4:
		luz_p4.visible = true
