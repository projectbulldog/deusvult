using Godot;
using System;

public class Tape : Label
{
    public int CurrentRaderPosition {get; set; }

    public override void _Ready()
    {
        
    }
    
    public char ReadCurrentPosition(int index)
    {
        return this.Text.Length < index ? this.Text[index] : ' ';
    }
}
