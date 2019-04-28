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
            result.newState = 1;
            result.tape1Direction = Direction.Right;
            result.tape2Character = 'I';
            result.tape2Direction = Direction.Right;
        }
        else if (tapes[0] == '_' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.newState = 2;
            result.tape1Direction = Direction.Left;
            result.tape2Direction = Direction.Left;
        }
        else
        {
            result.isFinished = true;
            result.newState = 1;
        }
        return result;
    }
}
