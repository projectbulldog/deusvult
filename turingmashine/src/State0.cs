using Godot;
using System;

public class State0 : State
{
    public override StateReturn Calculate(char tape1, char tape2, char tape3)
    {
        var result = this.CreateStateReturn(tape1, tape2, tape3);
        if (tape1 == Alphabet.NUMBER && tape2 == Alphabet.EMPTY && tape3 == Alphabet.EMPTY)
        {
            result.NewState = 0;
            result.Tape1Direction = Direction.Right;
        }
        else if (tape1 == Alphabet.OPERATION && tape2 == Alphabet.EMPTY && tape3 == Alphabet.EMPTY)
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
