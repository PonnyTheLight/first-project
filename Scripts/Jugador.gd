extends CharacterBody2D

@onready var JugadorAnimacion = $AnimatedSprite2D
@export var Velocidad := 300.0
@export var SaltoVelocidad := 300.0
var Gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var Jumps = 0
var VelocidadRodar = 130
var Caminando = false
var Direccion
var Monedas = 0

func _ready() -> void:
	JugadorAnimacion.play("Idle")

func _physics_process(delta: float) -> void:
	Direccion = Input.get_axis("Izuierda", "Derecha")
	velocity.x = Direccion * Velocidad
	if Direccion == 0:
		JugadorAnimacion.play("Idle")
		Caminando = false
	else:
		JugadorAnimacion.play("Caminar")
		Caminando = true
	if Direccion == -1:
		JugadorAnimacion.flip_h = true
	elif Direccion == 1:
		JugadorAnimacion.flip_h = false
	if not is_on_floor():
		velocity.y += Gravity * delta
	if Input.is_action_just_pressed("Saltar") and is_on_floor():
		velocity.y -= SaltoVelocidad
	if Input.is_action_just_pressed("ui_down"):
		if !JugadorAnimacion.flip_h:
			JugadorAnimacion.play("Rodar")
			velocity.x = VelocidadRodar
			await JugadorAnimacion.animation_finished
			velocity.x = 0
		else:
			JugadorAnimacion.play("Rodar")
			velocity.x = -VelocidadRodar
			await JugadorAnimacion.animation_finished
			velocity.x = 0
	move_and_slide()


func _on_recoleccion_area_entered(area: Area2D) -> void:
	if area.is_in_group("Recogibles"):
		Monedas += 1
