extends Control

var inputs
var currentInputId

func _input(event):
	if event.is_action_pressed("ui_accept") && currentInputId != null:
		print("HIER")
		inputs[currentInputId].emit_signal("gui_input", event)
	if Input.is_action_just_pressed("ui_down") && currentInputId != null && currentInputId < inputs.size() - 1:
		if currentInputId != null:	self.changeCurrentInput(currentInputId + 1)
		else: self.changeCurrentInput(0)
	if Input.is_action_just_pressed("ui_up") && currentInputId != null && currentInputId > 0:
		if currentInputId != null:	self.changeCurrentInput(currentInputId - 1)
		else: self.changeCurrentInput(inputs.size() - 1)
	if (Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down")) && currentInputId == null:
		self.changeCurrentInput(0)

func _ready():
	$GridContainer/VBoxContainer/HBoxContainer/NewGame.connect("gui_input", self, "newGame_input")
	$GridContainer/VBoxContainer/HBoxContainer/NewGame.connect("mouse_entered", self, "newGame_mouseEntered")
	$GridContainer/VBoxContainer/HBoxContainer/NewGame.connect("mouse_exited", self, "newGame_mouseExited")

	$GridContainer/VBoxContainer/HBoxContainer2/Options.connect("gui_input", self, "options_input")
	$GridContainer/VBoxContainer/HBoxContainer2/Options.connect("mouse_entered", self, "options_mouseEntered")
	$GridContainer/VBoxContainer/HBoxContainer2/Options.connect("mouse_exited", self, "options_mouseExited")

	$GridContainer/VBoxContainer/HBoxContainer3/Exit.connect("gui_input", self, "exit_input")
	$GridContainer/VBoxContainer/HBoxContainer3/Exit.connect("mouse_entered", self, "exit_mouseEntered")
	$GridContainer/VBoxContainer/HBoxContainer3/Exit.connect("mouse_exited", self, "exit_mouseExited")
	
	inputs = [$GridContainer/VBoxContainer/HBoxContainer/NewGame, $GridContainer/VBoxContainer/HBoxContainer2/Options, $GridContainer/VBoxContainer/HBoxContainer3/Exit]
	self.changeCurrentInput(0)

func changeCurrentInput(newId):
	if currentInputId != null: inputs[currentInputId].self_modulate = ColorN("white")
	if(newId != null):
		currentInputId = newId
		inputs[currentInputId].self_modulate = ColorN("red")
	else: currentInputId = null

func newGame_input(event):
	if event.is_action_pressed("ui_accept") || Input.is_mouse_button_pressed(BUTTON_LEFT):
		self.get_tree().change_scene("res://World.tscn")
		self.queue_free()

func newGame_mouseEntered():
	self.changeCurrentInput(0)

func newGame_mouseExited():
	self.changeCurrentInput(null)

func options_input(event):
#	Todo
	print(event)
	pass

func options_mouseEntered():
	self.changeCurrentInput(1)

func options_mouseExited():
	self.changeCurrentInput(null)

func exit_input(event):
	if event.is_action_pressed("ui_accept") || Input.is_mouse_button_pressed(BUTTON_LEFT):
		get_tree().quit()

func exit_mouseEntered():
	self.changeCurrentInput(2)

func exit_mouseExited():
	self.changeCurrentInput(null)
