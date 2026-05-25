extends Area2D
@export var elemento : String
@export var barra: ColorRect

func _process(delta: float) -> void:
	visible = not GameManager.paused

func _on_body_entered(body: Node2D) -> void:
	GameManager.player_zone = elemento
	if elemento in ["caldera1", "caldera2"] and body is CharacterBody2D:
		if GameManager.broken_boiler == elemento:
			barra.cargar = true

func _on_body_exited(body: Node2D) -> void:
	GameManager.player_zone = ""
	if elemento in ["caldera1", "caldera2"] and body is CharacterBody2D:
		barra.cargar = false
