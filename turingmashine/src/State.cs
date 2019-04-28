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

    public abstract StateReturn Calculate(TuringMachine turingMachine);

    public virtual void LeaveState()
    {
        this.SelfModulate = Color.ColorN("white");
    }
}
