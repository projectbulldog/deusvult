using Godot;
using System;

public class TuringMachine : Node2D
{
    public void Start(string input, Tape tape1, Tape tape2, Tape tape3, object[] states)
    {
		tape1.CurrentRaderPosition = 0;
		tape2.CurrentRaderPosition = 0;
		tape3.CurrentRaderPosition = 0;
        var splittedNumbers = input.Split('*');
        foreach(var split in splittedNumbers)
        {
            int number = split != null ? int.Parse(split) : 0;
            for(int i = 0; i < (int)number; i++)
            {
                tape1.Text += "I";
            }
            tape1.Text += " ";
        }
        
		tape1.CurrentRaderPosition = 0;
		tape2.CurrentRaderPosition = 0;
		tape3.CurrentRaderPosition = 0;

        ((State)states[0]).Enter();
    }
}
