//================================================================================
// Door.
//================================================================================
class Door extends NavigationPoint
	Native
	Placeable;

var() bool bInitiallyClosed;
var() bool bBlockedWhenClosed;
var bool bDoorOpen;
var bool bTempNoCollide;
var Mover MyDoor;
var Actor RecommendedTrigger;
var() name DoorTag;
var() name DoorTrigger;

function PostBeginPlay ()
{
	local Vector dist;

	if ( DoorTrigger != 'None' )
	{
		foreach AllActors(Class'Actor',RecommendedTrigger,DoorTrigger)
		{
/*			goto JL0028;
JL0028:*/
		}
		if ( RecommendedTrigger != None )
		{
			dist=Location - RecommendedTrigger.Location;
			if ( Abs(dist.Z) < RecommendedTrigger.CollisionHeight )
			{
				dist.Z=0.00;
				if ( VSize(dist) < RecommendedTrigger.CollisionRadius )
				{
					RecommendedTrigger=None;
				}
			}
		}
	}
	bBlocked=bInitiallyClosed && bBlockedWhenClosed;
	bDoorOpen= !bInitiallyClosed;
	Super.PostBeginPlay();
}

function MoverOpened ()
{
	bBlocked= !bInitiallyClosed && bBlockedWhenClosed;
	bDoorOpen=bInitiallyClosed;
}

function MoverClosed ()
{
	bBlocked=bInitiallyClosed && bBlockedWhenClosed;
	bDoorOpen= !bInitiallyClosed;
}

function Actor SpecialHandling (Pawn Other)
{
	if ( MyDoor == None )
	{
		return self;
	}
	if ( (MyDoor.BumpType == 0) &&  !Other.IsPlayerPawn() )
	{
		return None;
	}
	if ( bInitiallyClosed == bDoorOpen || MyDoor.bOpening || MyDoor.bDelaying )
	{
		return self;
	}
	if ( RecommendedTrigger != None )
	{
		return RecommendedTrigger;
	}
	return self;
}

function bool ProceedWithMove (Pawn Other)
{
	if ( bDoorOpen ||  !MyDoor.bDamageTriggered )
	{
		return True;
	}
	Other.ShootSpecial(MyDoor);
	MyDoor.Trigger(Other,Other);
	Other.Controller.WaitForMover(MyDoor);
	return False;
}

event bool SuggestMovePreparation (Pawn Other)
{
	if ( bDoorOpen )
	{
		return False;
	}
	if ( MyDoor.bOpening || MyDoor.bDelaying )
	{
		Other.Controller.WaitForMover(MyDoor);
		return True;
	}
	if ( MyDoor.bDamageTriggered )
	{
		Other.ShootSpecial(MyDoor);
		MyDoor.Trigger(Other,Other);
		Other.Controller.WaitForMover(MyDoor);
		return True;
	}
	return False;
}

defaultproperties
{
    bInitiallyClosed=True
    ExtraCost=100
    bSpecialMove=True
    RemoteRole=ROLE_None
}
/*
    Texture=Texture'S_Door'
*/

