//================================================================================
// Volume.
//================================================================================
class Volume extends Brush
	Native;
//	Localized;

var() int LocationPriority;
var Actor AssociatedActor;
var() DecorationList DecoList;
var() name AssociatedActorTag;
var() localized string LocationName;

native function bool Encompasses (Actor Other);

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( (AssociatedActorTag != 'None') && (AssociatedActorTag != 'None') )
	{
		foreach AllActors(Class'Actor',AssociatedActor,AssociatedActorTag)
		{
			goto JL003F;
JL003F:
		}
	}
	if ( AssociatedActor != None )
	{
		GotoState('AssociatedTouch');
		InitialState=GetStateName();
	}
}

function DisplayDebug (Canvas Canvas, out float YL, out float YPos)
{
	Super.DisplayDebug(Canvas,YL,YPos);
	Canvas.DrawText("AssociatedActor " $ string(AssociatedActor),False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
}

state AssociatedTouch
{
	event Touch (Actor Other)
	{
		AssociatedActor.Touch(Other);
	}
	
	event UnTouch (Actor Other)
	{
		AssociatedActor.UnTouch(Other);
	}
	
	function BeginState ()
	{
		local Actor A;
	
		foreach TouchingActors(Class'Actor',A)
		{
			Touch(A);
		}
	}
	
}

defaultproperties
{
    LocationName="unspecified"
    bSkipActorPropertyReplication=True
    bCollideActors=True
}