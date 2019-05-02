using Godot;
using System;

public class State3 : State
{
    public State3()
    {
        this.isAccepted = true;
    }

    public override StateReturn Calculate(char tape1, char tape2, char tape3)
    {
        var result = this.CreateStateReturn(tape1, tape2, tape3);
        if (tape1 == Alphabet.NUMBER && tape2 == Alphabet.NUMBER && tape3 == Alphabet.EMPTY)
        {
            result.NewState = 3;
            result.Tape3Character = Alphabet.NUMBER;
            result.Tape2Direction = Direction.Left;
            result.Tape3Direction = Direction.Right;
        }
        else if (tape1 == Alphabet.NUMBER && tape2 == Alphabet.EMPTY && tape3 == Alphabet.EMPTY)
        {
            result.NewState = 4;
            result.Tape1Direction = Direction.Left;
            result.Tape2Direction = Direction.Right;
        }
        else
        {
            result.IsAccepted = this.isAccepted;
            result.IsFinished = true;
            result.NewState = 3;
        }
        return result;
    }
}
