using Godot;
using System;

public class StateReturn
{
    public char Tape1Character { get; set; }
    public char Tape2Character { get; set; }
    public char Tape3Character { get; set; }

    public Direction Tape1Direction { get; set; }
    public Direction Tape2Direction { get; set; }
    public Direction Tape3Direction { get; set; }

    public int NewState { get; set; }

    public bool IsAccepted { get; set; }

    public bool IsFinished { get; set; }
}
