using Godot;
using System;

public class State2 : State
{
    public override StateReturn Calculate(char tape1, char tape2, char tape3)
    {
        var result = this.CreateStateReturn(tape1, tape2, tape3);
        if (tape1 == Alphabet.NUMBER && tape2 == Alphabet.NUMBER && tape3 == Alphabet.EMPTY)
        {
            result.NewState = 2;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = Alphabet.EMPTY;
        }
        else if (tape1 == Alphabet.OPERATION && tape2 == Alphabet.NUMBER && tape3 == Alphabet.EMPTY)
        {
            result.NewState = 3;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = Alphabet.EMPTY;
        }
        else if (tape1 == Alphabet.OPERATION && tape2 == Alphabet.NUMBER && tape3 == Alphabet.EMPTY)
        {
            result.NewState = 3;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = Alphabet.EMPTY;
        }
        else if (tape1 == Alphabet.OPERATION && tape2 == Alphabet.EMPTY && tape3 == Alphabet.EMPTY)
        {
            result.NewState = 3;
            result.Tape1Direction = Direction.Left;
            result.Tape1Character = Alphabet.EMPTY;
        }
        else
        {
            result.IsFinished = true;
            result.NewState = 2;
        }
        return result;
    }
}
