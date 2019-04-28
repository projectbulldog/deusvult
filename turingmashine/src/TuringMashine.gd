extends Node2D

var isAutoCalculating = false
var turingMachine

func _ready():
	$Camera2D/UI/Control/CalculateAll.connect("pressed", self, "_calculate_pressed")
	turingMachine = preload("TuringMachine.cs").new()
	turingMachine.Init($Camera2D/UI/tape1, $Camera2D/UI/tape2, $Camera2D/UI/tape3, $Camera2D/UI/Control_Count/Count, $Camera2D/UI/Control_Result/Result)
	self.add_child(turingMachine)

func _process(delta):
	if(Input.is_key_pressed(KEY_ENTER)):
		_on_Read_pressed()

func _calculate_pressed():
	start_calculate()

func start_calculate():
	if(!isAutoCalculating):
		turingMachine.AutoStart()
		$Camera2D/UI/Control/CalculateAll.text = "Stop"
	if(isAutoCalculating):
		turingMachine.AutoStop()
		$Camera2D/UI/Control/CalculateAll.text = "Berechnen"
	isAutoCalculating = !isAutoCalculating

func _on_Step_pressed():
	turingMachine.NextStep()

func _on_Read_pressed():
	$Camera2D/UI/Control/CalculateAll.text = "Berechnen"
	isAutoCalculating = false
	$state0.self_modulate = ColorN("white")
	$state1.self_modulate = ColorN("white")
	$state2.self_modulate = ColorN("white")
	$state3.self_modulate = ColorN("white")
	$state4.self_modulate = ColorN("white")
	var states = [$state0, $state1, $state2, $state3, $state4]
	var interval : float = getWaitTime($Camera2D/UI/HSlider.value)
	turingMachine.Reset(interval, $Camera2D/UI/Control/TextEdit.text, states)

func _on_TextEdit_text_changed(new_text):
	turingMachine.ChangeWaitTimer(new_text)

func _on_HSlider_value_changed(value):
	turingMachine.ChangeWaitTimer(getWaitTime(value))

func getWaitTime(value):
	return 2 * pow(10, -value)