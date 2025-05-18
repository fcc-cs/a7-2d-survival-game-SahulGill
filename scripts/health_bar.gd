extends TextureProgressBar

@export var character: CharacterBody2D

func _ready() -> void:
	character.HealthChanged.connect(update)
	update()

func update():
	value = character.current_health
