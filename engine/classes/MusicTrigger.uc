//================================================================================
// MusicTrigger.
//================================================================================
class MusicTrigger extends Triggers;

var() bool FadeOutAllSongs;
var() float FadeInTime;
var() float FadeOutTime;
var() string Song;
var transient int SongHandle;
var transient bool Triggered;

function Trigger (Actor Other, Pawn EventInstigator)
{
	if ( FadeOutAllSongs )
	{
		goto JL0058;
	}
	if (  !Triggered )
	{
		Triggered=True;
	}
	else
	{
		Triggered=False;
		if ( SongHandle != 0 )
		{
			goto JL0058;
		}
		Log("WARNING: invalid song handle");
	}
JL0058:
}

defaultproperties
{
    bCollideActors=False
}