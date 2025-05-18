extends CharacterBody2D

signal HealthChanged

var speed = 50
@export var max_health = 100
@onready var current_health: int = max_health

var dead = false
var player_in_area = false
var player 

@onready var slime = $slime_collectible
@export var itemRes: InvItem


func _ready() -> void:
	emit_signal("HealthChanged")
	dead = false


func _physics_process(delta: float) -> void:
	if !dead:
		$"detection area/CollisionShape2D".disabled = false
		
		if player_in_area:
			position += (player.position - position) / speed 
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
			
	else:
		$"detection area/CollisionShape2D".disabled = true
		


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false


func _on_hitbox_area_entered(area: Area2D) -> void:
	var damage 
	if area.has_method("arrow_deal_damage"):
		damage = 50
		take_damage(50)
		emit_signal("HealthChanged")
		
func take_damage(damage):
	
	current_health -= damage
	
	if !dead:
		if current_health <= 0:
			death()

func death():
	dead = true
	$HealthBar.visible = false
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	drop_slime()
	
	$hitbox/CollisionShape2D.disabled = true
	$"detection area/CollisionShape2D".disabled = true

func drop_slime():
	slime.visible = true
	$slime_collect_area/CollisionShape2D.disabled = false
	slime_collect()

func slime_collect():
	await get_tree().create_timer(1.5).timeout
	slime.visible = false
	player.collect(itemRes)
	queue_free()


func _on_slime_collect_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
