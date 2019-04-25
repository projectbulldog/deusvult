extends Node2D

var text_input
var isCalculate = false

var indexTape1 = 0
var indexTape2 = 0
var indexTape3 = 0

func _ready():
	$Camera2D/UI/Control/CalculateAll.connect("pressed", self, "_calculate_pressed")

func _process(delta):
	if(Input.is_key_pressed(KEY_ENTER)):
		start_calculate()

func _calculate_pressed():
	start_calculate()

func start_calculate():
	if(isCalculate):
		return
	
	isCalculate = true
	$Camera2D/UI/tape1.text = ""
	$Camera2D/UI/tape2.text = ""
	$Camera2D/UI/tape3.text = ""
	
			
	var turingMachine = preload("res://TuringMachine.cs").new()
	
	var states = [$state0]
	turingMachine.Start($Camera2D/UI/Control/TextEdit.text, $Camera2D/UI/tape1, $Camera2D/UI/tape2, $Camera2D/UI/tape3, states)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	