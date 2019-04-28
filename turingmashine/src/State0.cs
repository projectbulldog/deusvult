using Godot;
using System;

public class State0 : State
{
    public override StateReturn Calculate(TuringMachine turingMachine)
    {
        var tapes = turingMachine.ReadTapes();
        var result = new StateReturn();
        if (tapes[0] == 'I' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.NewState = 0;
            result.Tape1Direction = Direction.Right;
        }
        else if (tapes[0] == '*' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.NewState = 1;
            result.Tape1Direction = Direction.Right;
        }
        else
        {
            result.IsFinished = true;
        }

        return result;
    }
}
