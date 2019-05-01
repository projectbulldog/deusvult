using Godot;
using System;

public class State1 : State
{
    public override StateReturn Calculate(char tape1, char tape2, char tape3)
    {
        var result = this.CreateStateReturn(tape1, tape2, tape3);
        if (tape1 == Alphabet.NUMBER && tape2 == Alphabet.EMPTY && tape3 == Alphabet.EMPTY)
        {
            result.NewState = 1;
            result.Tape1Direction = Direction.Right;
            result.Tape2Character = Alphabet.NUMBER;
            result.Tape2Direction = Direction.Right;
        }
        else if (tape1 == Alphabet.EMPTY && tape2 == Alphabet.EMPTY && tape3 == Alphabet.EMPTY)
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
