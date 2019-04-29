using Godot;
using System;

public class State3 : State
{
    public State3()
    {
        this.isAccepted = true;
    }

    public override StateReturn Calculate(char tape1, char tape2, char tape3)
    {
        var result = this.CreateStateReturn(tape1, tape2, tape3);
        if (tape1 == 'I' && tape2 == 'I' && tape3 == '_')
        {
            result.NewState = 3;
            result.Tape3Character = 'I';
            result.Tape2Direction = Direction.Left;
            result.Tape3Direction = Direction.Right;
        }
        else if (tape1 == 'I' && tape2 == '_' && tape3 == '_')
        {
            result.NewState = 4;
            result.Tape1Direction = Direction.Left;
            result.Tape2Direction = Direction.Right;
        }
        else if (tape1 == '_' && tape2 == '_' && tape3 == '_')
        {
            result.NewState = 3;
            result.IsAccepted = isAccepted;
            result.IsFinished = true;
        }
        else if (tape1 == '_' && tape2 == 'I' && tape3 == '_')
        {
            result.NewState = 3;
            result.IsAccepted = isAccepted;
            result.IsFinished = true;
        }
        return result;
    }
}
