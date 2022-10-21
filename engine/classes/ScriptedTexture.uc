//================================================================================
// ScriptedTexture.
//================================================================================
class ScriptedTexture extends Texture;
//	Export;

var Actor NotifyActor;
var() Texture SourceTexture;
var const transient int Junk1;
var const transient int Junk2;
var const transient int Junk3;
var const transient float LocalTime;

native(473) final function DrawTile (float X, float Y, float XL, float YL, float U, float V, float UL, float VL, Texture Tex, bool bMasked);

native(472) final function DrawText (float X, float Y, string Text, Font Font);

native(474) final function DrawColoredText (float X, float Y, string Text, Font Font, Color FontColor);

native(475) final function ReplaceTexture (Texture Tex);

native(476) final function TextSize (string Text, out float XL, out float YL, Font Font);
