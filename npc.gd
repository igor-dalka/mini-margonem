extends CharacterBody2D

var player : Node2D


func _ready():
	# Znajdź gracza po grupie "player"
	player = get_tree().get_first_node_in_group("player")

	if player == null:
		print("⚠ NPC: Nie znaleziono gracza w grupie 'player'!")


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		if player == null:
			print("⚠ Brak gracza — upewnij się że Player jest w grupie 'player'")
			return

		# Sprawdzenie odległości
		var dist = player.global_position.distance_to(global_position)

		if dist <= 80:
			print("✔ NPC CLICKED — rozpocznij dialog!")
			start_dialog()
		else:
			print("✖ Jesteś za daleko. Podejdź bliżej!")


func start_dialog():
	# TU dodasz system dialogów później
	print("🗨 Rozmowa z NPC...")
