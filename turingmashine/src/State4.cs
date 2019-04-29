using Godot;
using System;

public class State4 : State
{
    public State4()
    {
        this.isAccepted = true;
    }

    public override StateReturn Calculate(char tape1, char tape2, char tape3)
    {
        var result = this.CreateStateReturn(tape1, tape2, tape3);
        if (tape1 == 'I' && tape2 == 'I' && tape3 == '_')
        {
            result.NewState = 4;
            result.Tape2Direction = Direction.Right;
        }
        else if (tape1 == 'I' && tape2 == '_' && tape3 == '_')
        {
            result.NewState = 3;
            result.Tape2Direction = Direction.Left;
        }
        else if (tape1 == '_' && tape2 == '_' && tape3 == '_')
        {
            result.NewState = 4;
            result.IsAccepted = this.isAccepted;
            result.IsFinished = true;
        }
        else if (tape1 == '_' && tape2 == 'I' && tape3 == '_')
        {
            result.NewState = 4;
            result.IsAccepted = this.isAccepted;
            result.IsFinished = true;
        }
        return result;
    }
}
