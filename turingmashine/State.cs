using Godot;
using System;

public abstract class State : Sprite
{
    public virtual void EnterState()
    {
        this.SelfModulate = Color.ColorN("red");
    }

    public abstract StateReturn Calculate(TuringMachine turingMachine);

    public virtual void LeaveState()
    {
        this.SelfModulate = Color.ColorN("white");
    }
}
