using Godot;
using System;

public abstract class State : Sprite
{
    protected bool isAccepted = false;

    public virtual void EnterState()
    {
        if(this.isAccepted)
        {
            this.SelfModulate = Color.ColorN("blue");
        }
        else
        {
            this.SelfModulate = Color.ColorN("red");
        }
    }

    public abstract StateReturn Calculate(TuringMachine turingMachine);

    public virtual void LeaveState()
    {
        this.SelfModulate = Color.ColorN("white");
    }
}
