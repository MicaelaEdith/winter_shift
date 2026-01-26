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
@export var caldera1: Area2D
@export var caldera2: Area2D

var esta_en_ascensor := false
var sumando := false
var reparando_techo := false
var puede_reparar = false

func _ready() -> void:
	actualizar_luz()

	
func _physics_process(delta):
	var direccion := 0
	if Input.is_action_pressed("ui_left"):
		$ColorRect/AnimatedSprite2D.play("correr")
		$ColorRect/AnimatedSprite2D.flip_h = true
		direccion -= 1
	elif Input.is_action_just_released("ui_left"):
		$ColorRect/AnimatedSprite2D.stop()
		
	if Input.is_action_pressed("ui_right"):
		$ColorRect/AnimatedSprite2D.flip_h = false
		$ColorRect/AnimatedSprite2D.play("correr")
		direccion += 1
	elif Input.is_action_just_released("ui_right"):
		$ColorRect/AnimatedSprite2D.stop()
	
	if not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		$ColorRect/AnimatedSprite2D.play("idle")
		
	if reparando_techo:
		$ColorRect/AnimatedSprite2D.stop()
		if Input.is_action_pressed("ui_accept"):
			if puede_reparar:
				$ColorRect/AnimatedSprite2D.play("reparando_techo")
				reparar_techo()
	
	if Input.is_action_pressed("ui_accept"):
		if GameManager.activos.has("caldera1") or GameManager.activos.has("caldera2"):
			if caldera1.tiene_al_personaje or caldera2.tiene_al_personaje:
				$ColorRect/AnimatedSprite2D.play("reparando")
				if caldera1.tiene_al_personaje:
					caldera1.barra.descargando = false
					caldera1.barra.cargar = false
				elif caldera2.tiene_al_personaje:
					caldera2.barra.descargando = false
					caldera2.barra.cargar = false
	
	
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

func reparar_techo():
	await get_tree().create_timer(3).timeout
	var anim_actual = $ColorRect/AnimatedSprite2D.animation
	if anim_actual == "reparando_techo":
		EnemiesManager.gotera_2.visible = false
		SoundManager.detener_gota()
		reparando_techo = false
		puede_reparar = false

	pass

func _on_area_reparacion_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
