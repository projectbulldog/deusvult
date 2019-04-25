using Godot;
using System;

public class State0 : State
{
    public override StateReturn Calculate(TuringMachine turingMachine)
    {
        var tapes = turingMachine.ReadTapes();
        var result = new StateReturn();
        if(tapes[0] == 'I' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.newState = 0;
            result.tape1Direction = DirectionEnum.Right;
        }
        else if(tapes[0] == '*' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.newState = 1;
            result.tape1Direction = DirectionEnum.Right;
        }
        else
        {
            result.isFinished = true;
        }

        return result;
    }
}
