using Godot;
using System;

public class StateReturn
{
    public char tape1Character{get;set;}
    public char tape2Character{get;set;}
    public char tape3Character{get;set;}

    public Direction tape1Direction {get;set;}
    public Direction tape2Direction {get;set;}
    public Direction tape3Direction {get;set;}

    public int newState{get;set;}

    public bool isAccepted {get;set;}

    public bool isFinished {get;set;}
}
