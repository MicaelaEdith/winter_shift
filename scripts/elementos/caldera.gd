#    Caldera
extends Area2D
@export var elemento : String
@export var barra: ColorRect
@export var personaje: CharacterBody2D

var lo_tiene = false


func _process(delta: float) -> void:
	if GameManager.juego_pausado:
		self.visible = false
	else:
		self.visible = true

func _on_body_entered(body: Node2D) -> void:
	print("[Caldera] - ENTRA a ", elemento," : la caldera tiene al jugador? ",lo_tiene)
	lo_tiene = true
	if body is CharacterBody2D:
	
		if elemento == "techo_1" or elemento == "techo_2":
			GameManager.jugador_en_elemeto = elemento
			personaje.reparando_techo = true
		else:
			GameManager.reparando = true
			GameManager.jugador_en_elemeto = elemento
			if GameManager.activo == elemento:
				barra.descargando = false
				barra.cargar = true
		
			
			
func _on_body_exited(body: Node2D) -> void:
	lo_tiene = false
	print("[Caldera] - SALE de ", elemento," : la caldera tiene al jugador? ",lo_tiene)
	if body is CharacterBody2D:
		if elemento == "techo_1" or elemento == "techo_2":
			personaje.reparando_techo = false
		else:
			
			GameManager.reparando = false
			GameManager.jugador_en_elemeto = ""
			barra.cargar = false
			if GameManager.activo == elemento:
				barra.descargando == true

func tiene_al_personaje():
	return lo_tiene
	
