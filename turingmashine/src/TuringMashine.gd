extends Node2D

var isAutoCalculating = false
var turingMachine

func _ready():
	$Camera2D/UI/Control/CalculateAll.connect("pressed", self, "_calculate_pressed")
	turingMachine = preload("TuringMachine.cs").new()
	var states = [$state0, $state1, $state2, $state3, $state4]
	turingMachine.Init($Camera2D/UI/tape1, $Camera2D/UI/tape2, $Camera2D/UI/tape3, $Camera2D/UI/Control_Count/Count, $Camera2D/UI/Control_Result/Result, states)
	self.add_child(turingMachine)
	
	$Camera2D/UI/Control/CalculateAll.disabled = true
	$Camera2D/UI/Control/Step.disabled = true

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
	var input = $Camera2D/UI/Control/TextEdit.text;
	var regex = RegEx.new()
	regex.compile("^\\d+\\*\\d+$")
	if(regex.search(input) == null):
		$Camera2D/UI/Popup.popup_centered()
		return
	
	isAutoCalculating = false
	$Camera2D/UI/Control/CalculateAll.disabled = false
	$Camera2D/UI/Control/Step.disabled = false
	$Camera2D/UI/Control/CalculateAll.text = "Berechnen"
	var interval : float = getWaitTime($Camera2D/UI/HSlider.value)
	turingMachine.Reset(interval, input)

func _on_TextEdit_text_changed(new_text):
	turingMachine.ChangeWaitTimer(new_text)

func _on_HSlider_value_changed(value):
	turingMachine.ChangeWaitTimer(getWaitTime(value))

func getWaitTime(value):
	return 2 * pow(10, -value)