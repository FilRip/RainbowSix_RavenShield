//================================================================================
// WarpZoneInfo.
//================================================================================
class WarpZoneInfo extends ZoneInfo
	Native;

var const int iWarpZone;
var int numDestinations;
var() bool bNoTeleFrag;
var() name ThisTag;
var const Coords WarpCoords;
var() string OtherSideURL;
var() string Destinations[8];
var transient WarpZoneInfo OtherSideActor;
var transient Object OtherSideLevel;

replication
{
	reliable if ( Role == Role_Authority )
		ThisTag,OtherSideURL,OtherSideActor;
}

native(314) final function Warp (out Vector Loc, out Vector Vel, out Rotator R);

native(315) final function UnWarp (out Vector Loc, out Vector Vel, out Rotator R);

function PreBeginPlay ()
{
	Super.PreBeginPlay();
	Generate();
	numDestinations=0;
JL0013:
	if ( numDestinations < 8 )
	{
		if ( Destinations[numDestinations] != "" )
		{
			numDestinations++;
		}
		else
		{
			numDestinations=8;
		}
		goto JL0013;
	}
	if ( (numDestinations > 0) && (OtherSideURL == "") )
	{
		OtherSideURL=Destinations[0];
	}
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	local int nextPick;

	if ( numDestinations == 0 )
	{
		return;
	}
	nextPick=0;
JL0014:
	if ( (nextPick < 8) && (Destinations[nextPick] != OtherSideURL) )
	{
		nextPick++;
		goto JL0014;
	}
	nextPick++;
	if ( (nextPick > 7) || (Destinations[nextPick] == "") )
	{
		nextPick=0;
	}
	OtherSideURL=Destinations[nextPick];
	ForceGenerate();
}

simulated event Generate ()
{
	if ( OtherSideLevel != None )
	{
		return;
	}
	ForceGenerate();
}

simulated event ForceGenerate ()
{
	if ( InStr(OtherSideURL,"/") >= 0 )
	{
		OtherSideLevel=None;
		OtherSideActor=None;
	}
	else
	{
		OtherSideLevel=XLevel;
		foreach AllActors(Class'WarpZoneInfo',OtherSideActor)
		{
			if ( (string(OtherSideActor.ThisTag) ~= OtherSideURL) && (OtherSideActor != self) )
			{
				goto JL0067;
			}
JL0067:
		}
	}
}

simulated function ActorEntered (Actor Other)
{
	local Vector L;
	local Rotator R;
	local Controller P;

	if (  !Other.bJustTeleported )
	{
		Generate();
		if ( OtherSideActor != None )
		{
			Other.Disable('Touch');
			Other.Disable('UnTouch');
			L=Other.Location;
			if ( Pawn(Other) != None )
			{
				R=Pawn(Other).GetViewRotation();
			}
			UnWarp(L,Other.Velocity,R);
			OtherSideActor.Warp(L,Other.Velocity,R);
			if ( Other.IsA('Pawn') )
			{
				Pawn(Other).bWarping=bNoTeleFrag;
				if ( Other.SetLocation(L) )
				{
					if ( Role == Role_Authority )
					{
						P=Level.ControllerList;
JL0129:
						if ( P != None )
						{
							if ( P.Enemy == Other )
							{
								P.LineOfSightTo(Other);
							}
							P=P.nextController;
							goto JL0129;
						}
					}
					R.Roll=0;
					Pawn(Other).SetViewRotation(R);
					Pawn(Other).ClientSetLocation(L,R);
					if ( Pawn(Other).Controller != None )
					{
						Pawn(Other).Controller.MoveTimer=-1.00;
					}
				}
				else
				{
					GotoState('DelayedWarp');
				}
			}
			else
			{
				Other.SetLocation(L);
				Other.SetRotation(R);
			}
			Other.Enable('Touch');
			Other.Enable('UnTouch');
		}
	}
}

event ActorLeaving (Actor Other)
{
	if ( Other.IsA('Pawn') )
	{
		Pawn(Other).bWarping=False;
	}
}

state DelayedWarp
{
	function Tick (float DeltaTime)
	{
		local Controller P;
		local bool bFound;
	
		P=Level.ControllerList;
	JL0014:
		if ( P != None )
		{
			if ( P.Pawn.bWarping && (P.Pawn.Region.Zone == self) )
			{
				bFound=True;
				ActorEntered(P);
			}
			P=P.nextController;
			goto JL0014;
		}
		if (  !bFound )
		{
			GotoState('None');
		}
	}
	
}
