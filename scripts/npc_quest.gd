extends Control

signal quest_menu_closed

var quest1_active = false
var quest1_complete = false
var stick = 0

func _process(delta: float) -> void:
	if quest1_active:
		if stick == 3:
			print("quest1 complete")
			quest1_active = false
			quest1_complete = true
			finished_quest()
			
func quest1_chat():
	$quest1_ui.visible = true 

func next_quest():
	if !quest1_complete:
		quest1_chat()
	else:
		$no_quest.visible = true
		await get_tree().create_timer(3).timeout
		$no_quest.visible = false

func _on_yes_pressed() -> void:
	$quest1_ui.visible = false
	quest1_active = true
	stick = 0
	emit_signal("quest_menu_closed")

func _on_no_pressed() -> void:
	$quest1_ui.visible = false
	quest1_active = false
	emit_signal("quest_menu_closed")

func stick_collected():
	stick += 1
	print("stick for quest")

func finished_quest():
	$finished_quest.visible = true
	await get_tree().create_timer(3).timeout
	$finished_quest.visible = false
