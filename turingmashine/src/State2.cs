using Godot;
using System;

public class State2 : State
{
    public override StateReturn Calculate(char tape1, char tape2, char tape3)
    {
        var result = this.CreateStateReturn(tape1, tape2, tape3);
        if (tape1 == 'I' && tape2 == 'I' && tape3 == '_')
        {
            result.NewState = 2;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = '_';
        }
        else if (tape1 == '*' && tape2 == 'I' && tape3 == '_')
        {
            result.NewState = 3;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = '_';
        }
        else if (tape1 == '*' && tape2 == 'I' && tape3 == '_')
        {
            result.NewState = 3;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = '_';
        }
        else if (tape1 == '*' && tape2 == '_' && tape3 == '_')
        {
            result.NewState = 3;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = '_';
        }
        else
        {
            result.IsFinished = true;
            result.NewState = 2;
        }
        return result;
    }
}
