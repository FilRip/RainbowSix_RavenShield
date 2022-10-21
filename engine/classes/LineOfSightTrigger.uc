//================================================================================
// LineOfSightTrigger.
//================================================================================
class LineOfSightTrigger extends Triggers
	Native;

var() int MaxViewAngle;
var() bool bEnabled;
var bool bTriggered;
var() float MaxViewDist;
var float OldTickTime;
var float RequiredViewDir;
var Actor SeenActor;
var() name SeenActorTag;

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	RequiredViewDir=Cos(MaxViewAngle * 3.14 / 180);
	if ( (SeenActorTag != 'None') && (SeenActorTag != 'None') )
	{
		foreach AllActors(Class'Actor',SeenActor,SeenActorTag)
		{
/*			goto JL005B;
JL005B:*/
		}
	}
}

event PlayerSeesMe (PlayerController P)
{
	TriggerEvent(Event,self,P.Pawn);
	bTriggered=True;
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	bEnabled=True;
}

defaultproperties
{
    MaxViewAngle=15
    bEnabled=True
    MaxViewDist=3000.00
    bCollideActors=False
}