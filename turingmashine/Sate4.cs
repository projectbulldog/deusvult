using Godot;
using System;

public class Sate4: State
{
    public override StateReturn Calculate(TuringMachine turingMachine)
    {
        var tapes = turingMachine.ReadTapes();
        var result = new StateReturn();
        if(tapes[0] == 'I' && tapes[1] == 'I' && tapes[2] == '_')
      {
          result.newState = 4;
          result.tape2Direction = DirectionEnum.Right;
      }
      else if(tapes[0] == 'I' && tapes[1] == '_' && tapes[2] == '_')
        {
          result.newState = 3;
          result.tape2Direction = DirectionEnum.Left;
        }
        else if(tapes[0] == '_' && tapes[1] == '_' && tapes[2] == '_')
        {
          result.newState = 4;
            this.SelfModulate = Color.ColorN("green");
            result.isAccepted = true;
            result.isFinished = true;
        }
        else if(tapes[0] == '_' && tapes[1] == 'I' && tapes[2] == '_')
        {
          result.newState = 4;
            this.SelfModulate = Color.ColorN("green");
            result.isAccepted = true;
            result.isFinished = true;
        }
        return result;
    }
}
