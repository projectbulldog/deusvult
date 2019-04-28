using Godot;
using System;

public class State2 : State
{
    public override StateReturn Calculate(TuringMachine turingMachine)
    {
        var tapes = turingMachine.ReadTapes();
        var result = new StateReturn();
        if (tapes[0] == 'I' && tapes[1] == 'I' && tapes[2] == '_')
        {
            result.newState = 2;
            result.tape1Direction = Direction.Left;
            result.tape1Character = '_';
        }
        else if (tapes[0] == '*' && tapes[1] == 'I' && tapes[2] == '_')
        {
            result.newState = 3;
            result.tape1Direction = Direction.Left;
            result.tape1Character = '_';
        }
        else if (tapes[0] == '*' && tapes[1] == 'I' && tapes[2] == '_')
        {
            result.newState = 3;
            result.tape1Direction = Direction.Left;
            result.tape1Character = '_';
        }
        else if (tapes[0] == '*' && tapes[1] == '_' && tapes[2] == '_')
        {
            result.newState = 3;
            result.tape1Direction = Direction.Left;
            result.tape1Character = '_';
        }
        else
        {
            result.isFinished = true;
            result.newState = 2;
        }
        return result;
    }
}
