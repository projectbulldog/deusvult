using Godot;
using System;

public class Tape : RichTextLabel
{
    private int currentReaderPosition;

    public int CurrentRaderPosition {
        get
    {
        return this.currentReaderPosition;
    }
    set{
        this.currentReaderPosition = value;
        this.BbcodeEnabled = true;
        this.UpdateTextPosition();
    } 
     }

    public override void _Ready()
    {
    }

    public void UpdateTextPosition()
    {
        if(this.Text.Length > 0)
        {
            var character = this.Text[this.CurrentRaderPosition];
        this.Text = this.Text.Remove(this.CurrentRaderPosition, 1);
        this.BbcodeText = this.Text;
        this.BbcodeText = this.BbcodeText.Insert(this.CurrentRaderPosition, $"[color=#FF0000]{character}[/color]");
        }
    }
    
    public char ReadCurrentPosition(int index)
    {
        if(this.Text.Length < index)
        {
            return this.Text[index];
        }
        else
        {
            return ' ';
        }
    }
}
