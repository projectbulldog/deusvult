using Godot;
using System;

public class State4 : State
{
    public State4()
    {
        this.isAccepted = true;
    }

    public override StateReturn Calculate(TuringMachine turingMachine)
    {
        var tapes = turingMachine.ReadTapes();
        var result = new StateReturn();
        if (tapes[0] == 'I' && tapes[1] == 'I' && tapes[2] == '_')
        {
            result.NewState = 4;
            result.Tape2Direction = Direction.Right;
        }
        else if (tapes[0] == 'I' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.NewState = 3;
            result.Tape2Direction = Direction.Left;
        }
        else if (tapes[0] == '_' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.NewState = 4;
            result.IsAccepted = true;
            result.IsFinished = true;
        }
        else if (tapes[0] == '_' && tapes[1] == 'I' && tapes[2] == '_')
        {
            result.NewState = 4;
            result.IsAccepted = true;
            result.IsFinished = true;
        }
        return result;
    }
}
