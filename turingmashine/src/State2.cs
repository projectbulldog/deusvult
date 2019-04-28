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
            result.NewState = 2;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = '_';
        }
        else if (tapes[0] == '*' && tapes[1] == 'I' && tapes[2] == '_')
        {
            result.NewState = 3;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = '_';
        }
        else if (tapes[0] == '*' && tapes[1] == 'I' && tapes[2] == '_')
        {
            result.NewState = 3;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = '_';
        }
        else if (tapes[0] == '*' && tapes[1] == '_' && tapes[2] == '_')
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
