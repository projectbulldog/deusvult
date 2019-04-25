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
        this.UpdateTextPosition();
    } 
     }

    public override void _Ready()
    {
        this.BbcodeEnabled = true;
    }

    public void UpdateTextPosition()
    {
        if(this.CurrentRaderPosition >= this.Text.Length)
        {
            this.Text += "_";
        }
        this.Text = this.Text.Replace("__", "_");
        if(this.currentReaderPosition < 0)
        {
            this.Text = this.Text.Insert(0, "_");
            this.currentReaderPosition = 0;
        }
            var character = this.Text[this.CurrentRaderPosition];
            this.Text = this.Text.Remove(this.CurrentRaderPosition, 1);
            this.BbcodeText = this.Text;
            this.BbcodeText = this.BbcodeText.Insert(this.CurrentRaderPosition, $"[color=#FF0000]{character}[/color]");
        
    }
    
    public char ReadCurrentPosition()
    {
        if(this.Text.Length > this.currentReaderPosition)
        {
            return this.Text[this.currentReaderPosition];
        }
        else
        {
            return '_';
        }
    }

    public void ReplaceCurrentCharacter(char character)
    {
        this.Text = this.Text.Remove(this.CurrentRaderPosition, 1);
        this.Text = this.Text.Insert(this.CurrentRaderPosition, character.ToString());
        this.UpdateTextPosition();
    }
}
