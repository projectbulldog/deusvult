using Godot;
using System;
using System.Linq;

public class TuringMachine : Node2D
{
    private Tape tape1;
    private Tape tape2;
    private Tape tape3;

    private State currentState;

    private State[] states;

    private Timer timer;

    private int steps = 0;

    private Label countLabel;
    private Label resultLabel;

    public TuringMachine()
    {
        this.timer = new Timer();
        timer.WaitTime = 0.2f;
        timer.Connect("timeout", this, "NextStep");
        this.AddChild(timer);
    }

    public void Init(Tape tape1, Tape tape2, Tape tape3, Label countLabel, Label resultLabel)
    {
        this.tape1 = tape1;
        this.tape2 = tape2;
        this.tape3 = tape3;
        this.countLabel = countLabel;
        this.resultLabel = resultLabel;
    }

    public void Reset(float timerInterval, string input, object[] allStates)
    {
        timer.Stop();
        timer.WaitTime = timerInterval;
        steps = 0;
        this.countLabel.Text = steps.ToString();
        this.resultLabel.Text = "";
        this.tape1.Reset();
        this.tape2.Reset();
        this.tape3.Reset();

        var splittedNumbers = input.Split('*');
        for (int j = 0; j < splittedNumbers.Length; j++)
        {
            int number = splittedNumbers[j] != null ? int.Parse(splittedNumbers[j]) : 0;
            for (int i = 0; i < (int)number; i++)
            {
                this.tape1.Text += "I";
            }
            if (j < splittedNumbers.Length - 1) this.tape1.Text += "*";
        }

        this.tape1.CurrentReaderPosition = 0;
        this.tape2.CurrentReaderPosition = 0;
        this.tape3.CurrentReaderPosition = 0;
        this.tape1.UpdateTextPosition();
        this.tape2.UpdateTextPosition();
        this.tape3.UpdateTextPosition();

        this.states = new State[allStates.Length];
        for (int i = 0; i < allStates.Length; i++)
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
        this.steps++;
        this.countLabel.Text = steps.ToString();
        if (this.currentState != states[result.NewState])
        {
            this.currentState.LeaveState();
            this.currentState = this.states[result.NewState];
            this.currentState.EnterState();
        }
        if (result.IsFinished)
        {
            timer.Stop();
            var calculateButton = this.GetParent().GetNode<Button>(new NodePath("Camera2D/UI/Control/CalculateAll"));
            calculateButton.Text = "Berechnen";
            if (this.currentState.IsAccepted)
            {
                this.currentState.SelfModulate = Color.ColorN("green");
                var tapeContent = this.tape3.Text;
                this.resultLabel.Text = tapeContent.Count(c => c == 'I').ToString();
            }
            var animation = this.GetParent().GetNode<AnimationPlayer>(new NodePath("AnimationPlayer"));
            animation.RootNode = this.currentState.GetPath();
            animation.Play("Finish");
            return;
        }

        if (result.Tape1Character != '\0') this.tape1.ReplaceCurrentCharacter(result.Tape1Character);
        if (result.Tape2Character != '\0') this.tape2.ReplaceCurrentCharacter(result.Tape2Character);
        if (result.Tape3Character != '\0') this.tape3.ReplaceCurrentCharacter(result.Tape3Character);

        this.tape1.CurrentReaderPosition += (int)result.Tape1Direction;
        this.tape2.CurrentReaderPosition += (int)result.Tape2Direction;
        this.tape3.CurrentReaderPosition += (int)result.Tape3Direction;
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