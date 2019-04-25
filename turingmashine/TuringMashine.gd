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
	
	text_input = $Camera2D/UI/Control/TextEdit.text
	var textArray = text_input.split("*")
	
	for i in range(0, textArray.size()):
		for j in range(0, textArray[i]):
			$Camera2D/UI/tape1.text += "I"
		if(i < textArray.size()-1):
			$Camera2D/UI/tape1.text += "*"
	
	state0()

func state0():
	var readTape1 = $Camera2D/UI/tape1.text[indexTape1];
	var readTape2 = $Camera2D/UI/tape2.text[indexTape2];
	var readTape3 = $Camera2D/UI/tape3.text[indexTape3];
	
	print(readTape1 + readTape2 + readTape3)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	