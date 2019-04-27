using Godot;
using System;

public class TuringMachine : Node2D
{
    private Tape tape1;
    private Tape tape2;
    private Tape tape3;

    private State currentState;

    private State[] states;

    private Timer timer;

    public TuringMachine()
    {
        this.timer = new Timer();
        timer.WaitTime = 0.2f;
        timer.Connect("timeout", this, "NextStep");
        this.AddChild(timer);
    }

    public void Reset(float timerInterval, string input, Tape tape1, Tape tape2, Tape tape3, object[] allStates)
    {
        timer.Stop();
        timer.WaitTime = timerInterval;
        this.tape1 = tape1;
        this.tape2 = tape2;
        this.tape3 = tape3;
        this.tape1.Text = "";
        this.tape2.Text = "";
        this.tape3.Text = "";

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
        
        this.tape1.CurrentReaderPosition = 0;
        this.tape2.CurrentReaderPosition = 0;
        this.tape3.CurrentReaderPosition = 0;
        this.tape1.UpdateTextPosition();
        this.tape2.UpdateTextPosition();
        this.tape3.UpdateTextPosition();

        this.states = new State[allStates.Length];
        for(int i = 0; i < allStates.Length; i++)
        {
            this.states[i] = (State)allStates[i];
        }
        this.currentState = states[0];
        this.currentState.EnterState();
    }

    public void AutoStart()
    {
        timer.Start();
    }

    public void AutoStop()
    {
        timer.Stop();
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
        if(result.isFinished)
        {
            timer.Stop();
            var calculateButton = this.GetParent().GetNode<Button>(new NodePath("Camera2D/UI/Control/CalculateAll"));
            calculateButton.Text = "Berechnen";
            if(this.currentState.IsAccepted)
            {
                this.currentState.SelfModulate = Color.ColorN("green");
               var particles= this.GetParent().GetNode<Particles2D>(new NodePath("Success"));
               particles.Position = this.currentState.Position;
               particles.Emitting = true;
            }
            return;
        }

        if(result.tape1Character != '\0')   this.tape1.ReplaceCurrentCharacter(result.tape1Character);
        if(result.tape2Character != '\0')   this.tape2.ReplaceCurrentCharacter(result.tape2Character);
        if(result.tape3Character != '\0')   this.tape3.ReplaceCurrentCharacter(result.tape3Character);

        this.tape1.CurrentReaderPosition += (int)result.tape1Direction;
        this.tape2.CurrentReaderPosition += (int)result.tape2Direction;
        this.tape3.CurrentReaderPosition += (int)result.tape3Direction;
    }

    public char[] ReadTapes()
    {
        char[] tapeCharacters = new char[3];
        tapeCharacters[0] = this.tape1.ReadCurrentPosition();
        tapeCharacters[1] = this.tape2.ReadCurrentPosition();
        tapeCharacters[2] = this.tape3.ReadCurrentPosition();
        return tapeCharacters;
    }

    public void ChangeWaitTimer(float newInterval)
    {
        this.timer.WaitTime = newInterval;
    }
}
