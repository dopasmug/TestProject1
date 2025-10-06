extends CharacterBody3D

var direction := Vector2.ZERO # Направление движения
var acceleration := 8.0 # Коэффициент ускорения
@export var speed := 500.0 # Скорость
@export var gravity := 24.1 # Гравитация
@export var jump_speed := 8.8 # Сила прыжка

func _physics_process(delta: float) -> void:
	# Проверка нажатий на Пробел и левый Shift
	var jump = Input.is_action_just_pressed("player_jump") # Прыжок
	var slow_move = Input.is_action_pressed("player_slow") # Замедление
	
	move_and_slide()
	
	if is_on_floor():
		var input_vector = Vector2(
			Input.get_axis("player_right", "player_left"),
			Input.get_axis("player_down", "player_up")
		).normalized()
		
		if input_vector != Vector2.ZERO:
			direction = direction.move_toward(input_vector, acceleration * delta)
		else:
			direction = direction.move_toward(Vector2.ZERO, acceleration * delta)
		
		if slow_move: direction *= 0.75
		if jump: velocity.y = jump_speed
		
		update_velocity_xy(delta)
	else:
		velocity.y -= gravity * delta
		# Столкновение со стеной
		if is_on_wall():
			# Проверка столкновений
			for i in range(get_slide_collision_count()):
				var collision = get_slide_collision(i)
				var normal = collision.get_normal()
				if collision:
					# Отскок 
					direction = custom_bounce(direction, normal) * 0.65
					update_velocity_xy(delta)
					velocity.y = 0

# Перевод вектора нормали стены (Vector3 to Vector2)
# Расчет отражения вектора направления относительно вектора нормали стены
func custom_bounce(dir: Vector2, normal_3d: Vector3) -> Vector2:
	var normal_2d := Vector2( normal_3d.x, normal_3d.z )
	return dir.bounce(normal_2d)

# Обновление вектора скорости по осям X и Z в 3D-пространстве
func update_velocity_xy(delta: float) -> void:
	velocity.z = direction.y * speed * delta # Y
	velocity.x = direction.x * speed * delta # X
