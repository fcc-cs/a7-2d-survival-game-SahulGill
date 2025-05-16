extends CharacterBody2D

var speed = 100
var player_state

@export var inv: Inv


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		
	velocity = direction * speed 
	move_and_slide()
	
	player_anim(direction)

func player_anim(dir):
	
	var anim_aprite = $AnimatedSprite2D
	
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

func player():
	pass

func collect(item):
	inv.insert(item)
