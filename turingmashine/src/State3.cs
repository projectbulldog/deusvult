using Godot;
using System;

public class State3 : State
{
    public State3()
    {
        this.isAccepted = true;
    }

    public override StateReturn Calculate(TuringMachine turingMachine)
    {
        var tapes = turingMachine.ReadTapes();
        var result = new StateReturn();
        if (tapes[0] == 'I' && tapes[1] == 'I' && tapes[2] == '_')
        {
            result.NewState = 3;
            result.Tape3Character = 'I';
            result.Tape2Direction = Direction.Left;
            result.Tape3Direction = Direction.Right;
        }
        else if (tapes[0] == 'I' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.NewState = 4;
            result.Tape1Character = '_';
            result.Tape1Direction = Direction.Left;
            result.Tape2Direction = Direction.Right;
        }
        else if (tapes[0] == '_' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.NewState = 3;
            result.IsAccepted = true;
            result.IsFinished = true;
        }
        else if (tapes[0] == '_' && tapes[1] == 'I' && tapes[2] == '_')
        {
            result.NewState = 3;
            result.IsAccepted = true;
            result.IsFinished = true;
        }
        return result;
    }
}
