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
var _reparando_activo := false


func _ready() -> void:
	actualizar_luz()


func _physics_process(delta):
	var direccion := 0
	var anim_override := false

	if Input.is_action_pressed("ui_left"):
		$ColorRect/AnimatedSprite2D.play("correr")
		$ColorRect/AnimatedSprite2D.flip_h = true
		direccion -= 1
		anim_override = true

	if Input.is_action_pressed("ui_right"):
		$ColorRect/AnimatedSprite2D.flip_h = false
		$ColorRect/AnimatedSprite2D.play("correr")
		direccion += 1
		anim_override = true

	var en_zona_techo := GameManager.player_zone in ["techo_1", "techo_2"]
	var en_zona_caldera := GameManager.player_zone in ["caldera1", "caldera2"]
	var en_zona_electrico := GameManager.player_zone in ["desperfecto_electrico1", "desperfecto_electrico2"]
	var en_zona_viento := GameManager.player_zone in ["viento_1", "viento_2"]
	var en_zona_reparable := en_zona_techo or en_zona_electrico or en_zona_viento

	var zona_reparable_rota := (
		(GameManager.player_zone == GameManager.leaking_techo) or
		(GameManager.player_zone == GameManager.broken_electrico) or
		(GameManager.player_zone == GameManager.broken_viento)
	)

	var anim_reparar := "reparando_techo"
	if en_zona_viento:
		anim_reparar = "reparando"

	if en_zona_reparable and not _reparando_activo and zona_reparable_rota:
		if Input.is_action_just_pressed("ui_accept"):
			_reparando_activo = true
			$ColorRect/AnimatedSprite2D.play(anim_reparar)
			anim_override = true
			reparar_problema()

	if not _reparando_activo and en_zona_caldera and Input.is_action_pressed("ui_accept"):
		if GameManager.player_zone == GameManager.broken_boiler:
			$ColorRect/AnimatedSprite2D.play("reparando")
			anim_override = true

	if Input.is_action_just_pressed("ui_accept"):
		if GameManager.player_zone == GameManager.broken_boiler and GameManager.broken_boiler != "":
			if GameManager.player_zone == "caldera1":
				caldera1.barra.cargar = true
			elif GameManager.player_zone == "caldera2":
				caldera2.barra.cargar = true

	if _reparando_activo:
		if not en_zona_reparable:
			_reparando_activo = false
		else:
			anim_override = true

	if not anim_override:
		$ColorRect/AnimatedSprite2D.play("idle")

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
		if GameManager.floor <= 3:
			GameManager.floor += 1
		else:
			return

func bajar():
	if sumando:
		return
	sumando = true
	while sumando:
		actualizar_luz()
		await get_tree().create_timer(0.9).timeout
		if GameManager.floor > 0:
			GameManager.floor -= 1
		else:
			return


func posicionar_personaje():
	if GameManager.floor == 0:
		global_position = marca_pb.global_position
	elif GameManager.floor == 1:
		global_position = marca_p1.global_position
	elif GameManager.floor == 2:
		global_position = marca_p2.global_position
	elif GameManager.floor == 3:
		global_position = marca_p3.global_position
	elif GameManager.floor == 4:
		global_position = marca_p4.global_position
	SoundManager.reproducir_ding()
	actualizar_luz()


func actualizar_luz():
	luz_pb.visible = false
	luz_p1.visible = false
	luz_p2.visible = false
	luz_p3.visible = false
	luz_p4.visible = false

	if GameManager.floor == 0:
		luz_pb.visible = true
	elif GameManager.floor == 1:
		luz_p1.visible = true
	elif GameManager.floor == 2:
		luz_p2.visible = true
	elif GameManager.floor == 3:
		luz_p3.visible = true
	elif GameManager.floor == 4:
		luz_p4.visible = true


func reparar_problema():
	var target_zone = GameManager.player_zone
	await get_tree().create_timer(3).timeout

	if not _reparando_activo:
		return

	_completar_reparacion(target_zone)
	_reparando_activo = false


func _completar_reparacion(zona: String) -> void:
	match zona:
		"techo_1":
			EnemiesManager.gotera_1.visible = false
			GameManager.leaking_techo = ""
		"techo_2":
			EnemiesManager.gotera_2.visible = false
			GameManager.leaking_techo = ""
		"desperfecto_electrico1":
			EnemiesManager.desperfecto_electrico_1.visible = false
			GameManager.broken_electrico = ""
		"desperfecto_electrico2":
			EnemiesManager.desperfecto_electrico_2.visible = false
			GameManager.broken_electrico = ""
		"viento_1":
			EnemiesManager.viento_1.visible = false
			GameManager.broken_viento = ""
		"viento_2":
			EnemiesManager.viento_2.visible = false
			GameManager.broken_viento = ""

	SoundManager.detener_gota()
