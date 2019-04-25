using Godot;
using System;

public class State1 : State
{
    public override StateReturn Calculate(TuringMachine turingMachine)
    {
        var tapes = turingMachine.ReadTapes();
        var result = new StateReturn();
        if(tapes[0] == 'I' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.newState = 1;
            result.tape1Direction = DirectionEnum.Right;
            result.tape2Character = 'I';
            result.tape2Direction = DirectionEnum.Right;
        }
        else if(tapes[0] == '_' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.newState = 2;
            result.tape1Direction = DirectionEnum.Left;
            result.tape2Direction = DirectionEnum.Left;
        }
        else
        {
            result.isFinished = true;
            result.newState = 1;
        }
        return result;
    }
}
