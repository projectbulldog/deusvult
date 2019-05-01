using Godot;
using System;

public class Tape : RichTextLabel
{
    private int currentReaderPosition;

    public int CurrentReaderPosition
    {
        get
        {
            return this.currentReaderPosition;
        }
        set
        {
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
        if (this.CurrentReaderPosition < 15)
        {
            while (this.CurrentReaderPosition <= 15)
            {
                this.Text = this.Text.Insert(0, "_");
                this.CurrentReaderPosition++;
            }
        }

        var neededUnderlinesAfter = this.CurrentReaderPosition + 15 - this.Text.Length;
        for (int i = 0; i <= neededUnderlinesAfter; i++)
        {
            this.Text += "_";
        }
        if (this.currentReaderPosition < 0)
        {
            this.Text = this.Text.Insert(0, "_");
            this.currentReaderPosition = 0;
        }
        var character = this.Text[this.CurrentReaderPosition];
        this.Text = this.Text.Remove(this.CurrentReaderPosition, 1);
        this.BbcodeText = this.Text;
        this.BbcodeText = this.BbcodeText.Insert(this.CurrentReaderPosition, $"[color=#FF0000]{character}[/color]");

    }

    public char Read()
    {
        return this.Text.Length > this.currentReaderPosition ? this.Text[this.currentReaderPosition] : '_';
    }

    public void Write(char character)
    {
        this.Text = this.Text.Remove(this.CurrentReaderPosition, 1);
        this.Text = this.Text.Insert(this.CurrentReaderPosition, character.ToString());
        this.UpdateTextPosition();
    }

    public void Reset()
    {
        this.Text = "";
        this.BbcodeText = "";
    }
}
