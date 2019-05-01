using Godot;
using System;
using System.Diagnostics;

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
        if (this.currentReaderPosition < 14)
        {
            while (this.currentReaderPosition <= 14)
            {
                this.Text = this.Text.Insert(0, Alphabet.EMPTY.ToString());
                this.currentReaderPosition++;
            }
        }

        var neededUnderlinesAfter = this.CurrentReaderPosition + 14 - this.Text.Length;
        for (int i = 0; i <= neededUnderlinesAfter; i++)
        {
            this.Text += Alphabet.EMPTY;
        }
        var character = this.Text[this.CurrentReaderPosition];
        this.Text = this.Text.Remove(this.CurrentReaderPosition, 1);
        this.BbcodeText = this.Text;
        this.BbcodeText = this.BbcodeText.Insert(this.CurrentReaderPosition, $"[color=#FF0000]{character}[/color]");
    }

    public char Read()
    {
        return this.Text.Length > this.currentReaderPosition ? this.Text[this.currentReaderPosition] : Alphabet.EMPTY;
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
