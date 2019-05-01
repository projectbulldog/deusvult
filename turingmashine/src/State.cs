using Godot;
using System;

public abstract class State : Sprite
{
    protected bool isAccepted = false;

    public bool IsAccepted => this.isAccepted;

    public virtual void EnterState()
    {
        this.SelfModulate = Color.ColorN("orange");
    }

    public virtual void LeaveState()
    {
        this.SelfModulate = Color.ColorN("white");
    }

    public abstract StateReturn Calculate(char tape1, char tape2, char tape3);

    protected StateReturn CreateStateReturn(char tape1, char tape2, char tape3)
    {
        var result = new StateReturn();
        result.Tape1Character = tape1;
        result.Tape2Character = tape2;
        result.Tape3Character = tape3;

        return result;
    }
}
