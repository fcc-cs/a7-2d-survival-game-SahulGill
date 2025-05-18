extends CharacterBody2D

signal stick_collected
signal apple_collected
signal slime_collected

var speed = 100
var player_state

@export var inv: Inv

var bow_equipped = false
var bow_cooldown = true
var arrow = preload("res://scenes/arrow.tscn")

var mouse_location_from_player = null

@onready var camera = $Camera2D

func _physics_process(delta: float) -> void:
	mouse_location_from_player = get_global_mouse_position() - self.position

	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
	velocity = direction * speed 
	move_and_slide()
	
	if Input.is_action_just_pressed("f"):
		bow_equipped = !bow_equipped

	var mouse_position = get_global_mouse_position()
	$Marker2D.look_at(mouse_position)
	
	if Input.is_action_just_pressed("left_mouse") and bow_equipped and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		
		await get_tree().create_timer(0.4).timeout
		bow_cooldown = true
		
	player_anim(direction)

func player_anim(dir):
	var anim_aprite = $AnimatedSprite2D
	
	if !bow_equipped:
		speed = 100
		if player_state == "idle":
			anim_aprite.play("idle")
	
		if player_state == "walking":
			# 4 directional walking 
			if dir.y == -1:
				anim_aprite.play("n-walk")
			if dir.y == 1:
				anim_aprite.play("s-walk")
			if dir.x == -1:
				anim_aprite.play("w-walk")
			if dir.x == 1:
				anim_aprite.play("e-walk")
		
			# 8 directional walking 
			if dir.x > 0.5 and dir.y < -0.5:
				anim_aprite.play("ne-walk") 
			if dir.x > 0.5 and dir.y > 0.5:
				anim_aprite.play("se-walk") 
			if dir.x < -0.5 and dir.y > 0.5:
				anim_aprite.play("sw-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				anim_aprite.play("nw-walk") 
	
	
	else:
		speed = 0
		if mouse_location_from_player.x >= -25 and mouse_location_from_player.x <= 25 and mouse_location_from_player.y < 0:
			anim_aprite.play("n-attack")
		if mouse_location_from_player.y >= -25 and mouse_location_from_player.y <= 25 and mouse_location_from_player.x > 0:
			anim_aprite.play("e-attack")
		if mouse_location_from_player.x >= -25 and mouse_location_from_player.x <= 25 and mouse_location_from_player.y > 0:
			anim_aprite.play("s-attack")
		if mouse_location_from_player.y >= -25 and mouse_location_from_player.y <= 25 and mouse_location_from_player.x < 0:
			anim_aprite.play("w-attack")
		
		
		if mouse_location_from_player.x >= 25 and mouse_location_from_player.y <= -25:
			anim_aprite.play("ne-attack")
		if mouse_location_from_player.x >= 0.5 and mouse_location_from_player.y >= 25:
			anim_aprite.play("se-attack")
		if mouse_location_from_player.x <= -0.5 and mouse_location_from_player.y >= 25:
			anim_aprite.play("sw-attack")
		if mouse_location_from_player.x <= -25 and mouse_location_from_player.y <= -25:
			anim_aprite.play("nw-attack")


func player():
	pass

func collect(item):
	inv.insert(item)
	
	if item.name == "stick":
		emit_signal("stick_collected")
	
	if item.name == "slime": #slime
		emit_signal("slime_collected")
		
	if item.name == "apple": #apple
		emit_signal("apple_collected")
	
