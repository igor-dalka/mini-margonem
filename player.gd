extends CharacterBody2D

const TILE_SIZE := 64
var is_moving := false
var last_dir := Vector2.DOWN   # domyślny kierunek idle

func _process(delta):
	if is_moving:
		return

	var dir := Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		dir = Vector2(0, -1)
	elif Input.is_action_pressed("ui_down"):
		dir = Vector2(0, 1)
	elif Input.is_action_pressed("ui_left"):
		dir = Vector2(-1, 0)
	elif Input.is_action_pressed("ui_right"):
		dir = Vector2(1, 0)

	if dir != Vector2.ZERO:
		last_dir = dir
		play_walk_anim(dir)
		move_by_grid(dir)
	else:
		play_idle_anim()


func move_by_grid(direction: Vector2):
	if is_moving:
		return

	var start_pos = global_position
	var target_pos = start_pos + direction * TILE_SIZE

	if not can_move_to(target_pos):
		print("blocked")
		play_idle_anim()
		return

	is_moving = true

	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.30)

	tween.finished.connect(func():
		is_moving = false
		play_idle_anim()
	)


func can_move_to(pos: Vector2) -> bool:
	var shape = $CollisionShape2D.shape

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape

	# ⭐ NAJWAŻNIEJSZE — ustawiamy collider dokładnie tam,
	# gdzie gracz stanie po ruchu
	query.transform = Transform2D(0, pos - $CollisionShape2D.position)

	query.collide_with_bodies = true
	query.collide_with_areas = false
	query.exclude = [self]

	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_shape(query)

	return result.is_empty()


# ----------------------------
# ANIMACJE
# ----------------------------

func play_walk_anim(dir: Vector2):
	if dir == Vector2.RIGHT:
		$AnimationPlayer.play("walk_right")
	elif dir == Vector2.LEFT:
		$AnimationPlayer.play("walk_left")
	elif dir == Vector2.UP:
		$AnimationPlayer.play("walk_up")
	elif dir == Vector2.DOWN:
		$AnimationPlayer.play("walk_down")


func play_idle_anim():
	$AnimationPlayer.play("idle")
