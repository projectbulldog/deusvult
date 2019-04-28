using Godot;
using System;

public class State3  : State
{
    public State3()
    {
        this.isAccepted = true;
    }
    
    public override StateReturn Calculate(TuringMachine turingMachine)
    {
        var tapes = turingMachine.ReadTapes();
        var result = new StateReturn();
        if(tapes[0] == 'I' && tapes[1] == 'I' && tapes[2] == '_')
      {
          result.newState = 3;
          result.tape3Character = 'I';
          result.tape2Direction = Direction.Left;
          result.tape3Direction = Direction.Right;
      }
      else if(tapes[0] == 'I' && tapes[1] == '_' && tapes[2] == '_')
        {
          result.newState = 4;
          result.tape1Character = '_';
          result.tape1Direction = Direction.Left;
          result.tape2Direction = Direction.Right;
        }
        else if(tapes[0] == '_' && tapes[1] == '_' && tapes[2] == '_')
        {
          result.newState = 3;
            result.isAccepted = true;
            result.isFinished = true;
        }
        else if(tapes[0] == '_' && tapes[1] == 'I' && tapes[2] == '_')
        {
          result.newState = 3;
            result.isAccepted = true;
            result.isFinished = true;
        }
        return result;
    }
}
