using Godot;
using System;

public class TuringMachine : Node2D
{
    private Tape tape1;
    private Tape tape2;
    private Tape tape3;

    private State currentState;

    private State[] states;

    public void Start(float timerInterval, string input, Tape tape1, Tape tape2, Tape tape3, object[] allStates)
    {
        var children = this.GetParent().GetChildren();
        foreach(var child in children)
        {
            if(child != this && child.GetType() == typeof(TuringMachine))
            {
               var underChilds = ((TuringMachine)child).GetChildren();
               foreach(var v in underChilds)
               {
                   ((Timer)v).RemoveAndSkip();
               }
               ((TuringMachine)child).RemoveAndSkip();
            }
        }
        this.tape1 = tape1;
        this.tape2 = tape2;
        this.tape3 = tape3;
        this.tape1.CurrentRaderPosition = 0;
        this.tape2.CurrentRaderPosition = 0;
        this.tape3.CurrentRaderPosition = 0;

        this.tape1.Text = "";
        this.tape2.Text = "";
        this.tape3.Text = "";
        var timer = new Timer();
        timer.WaitTime = timerInterval;
        timer.Connect("timeout", this, "NextStep");

        var splittedNumbers = input.Split('*');
        for(int j = 0; j < splittedNumbers.Length; j++)
        {
            int number = splittedNumbers[j] != null ? int.Parse(splittedNumbers[j]) : 0;
            for(int i = 0; i < (int)number; i++)
            {
                this.tape1.Text += "I";
            }
            if(j < splittedNumbers.Length - 1)  this.tape1.Text += "*";
        }
        
        this.tape1.UpdateTextPosition();
        this.tape2.UpdateTextPosition();
        this.tape3.UpdateTextPosition();

        this.states = new State[allStates.Length];
        for(int i = 0; i < allStates.Length; i++)
        {
            this.states[i] = (State)allStates[i];
        }
        this.currentState = states[0];
        this.AddChild(timer);
        timer.Start();
        this.currentState.EnterState();
    }

    public void NextStep()
    {
        var result = this.currentState.Calculate(this);
        if(this.currentState != states[result.newState])
        {
            this.currentState.LeaveState();
        this.currentState = this.states[result.newState];
        this.currentState.EnterState();
        }

        if(result.tape1Character != '\0')   this.tape1.ReplaceCurrentCharacter(result.tape1Character);
        if(result.tape2Character != '\0')   this.tape2.ReplaceCurrentCharacter(result.tape2Character);
        if(result.tape3Character != '\0')   this.tape3.ReplaceCurrentCharacter(result.tape3Character);

        this.tape1.CurrentRaderPosition += (int)result.tape1Direction;
        this.tape2.CurrentRaderPosition += (int)result.tape2Direction;
        this.tape3.CurrentRaderPosition += (int)result.tape3Direction;
    }

    public char[] ReadTapes()
    {
        char[] tapeCharacters = new char[3];
        tapeCharacters[0] = this.tape1.ReadCurrentPosition();
        tapeCharacters[1] = this.tape2.ReadCurrentPosition();
        tapeCharacters[2] = this.tape3.ReadCurrentPosition();
        return tapeCharacters;
    }
}
