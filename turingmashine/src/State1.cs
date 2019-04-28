using Godot;
using System;

public class State1 : State
{
    public override StateReturn Calculate(TuringMachine turingMachine)
    {
        var tapes = turingMachine.ReadTapes();
        var result = new StateReturn();
        if (tapes[0] == 'I' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.NewState = 1;
            result.Tape1Direction = Direction.Right;
            result.Tape2Character = 'I';
            result.Tape2Direction = Direction.Right;
        }
        else if (tapes[0] == '_' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.NewState = 2;
            result.Tape1Direction = Direction.Left;
            result.Tape2Direction = Direction.Left;
        }
        else
        {
            result.IsFinished = true;
            result.NewState = 1;
        }
        return result;
    }
}
