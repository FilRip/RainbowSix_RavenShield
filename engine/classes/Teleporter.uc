//================================================================================
// Teleporter.
//================================================================================
class Teleporter extends SmallNavigationPoint
	Native
	Placeable;

var() bool bChangesVelocity;
var() bool bChangesYaw;
var() bool bReversesX;
var() bool bReversesY;
var() bool bReversesZ;
var() bool bEnabled;
var float LastFired;
var Actor TriggerActor;
var Actor TriggerActor2;
var() name ProductRequired;
var() Vector TargetVelocity;
var() string URL;

replication
{
	reliable if ( bNetInitial && (Role == Role_Authority) )
		bChangesVelocity,bChangesYaw,bReversesX,bReversesY,bReversesZ,TargetVelocity;
	reliable if ( Role == Role_Authority )
		bEnabled,URL;
}

function PostBeginPlay ()
{
	if ( URL ~= "" )
	{
		SetCollision(False,False,False);
	}
	if (  !bEnabled )
	{
		FindTriggerActor();
	}
	Super.PostBeginPlay();
}

function FindTriggerActor ()
{
	local Actor A;

	TriggerActor=None;
	TriggerActor2=None;
	foreach DynamicActors(Class'Actor',A)
	{
		if ( A.Event == Tag )
		{
			if ( TriggerActor == None )
			{
				TriggerActor=A;
			}
			else
			{
				TriggerActor2=A;
				return;
			}
		}
	}
}

simulated function bool Accept (Actor Incoming, Actor Source)
{
	local Rotator newRot;
	local Rotator OldRot;
	local float mag;
	local Vector oldDir;
	local Controller P;

	Disable('Touch');
	newRot=Incoming.Rotation;
	if ( bChangesYaw )
	{
		OldRot=Incoming.Rotation;
		newRot.Yaw=Rotation.Yaw;
		if ( Source != None )
		{
			newRot.Yaw += 32768 + Incoming.Rotation.Yaw - Source.Rotation.Yaw;
		}
	}
	if ( Pawn(Incoming) != None )
	{
		if ( Role == Role_Authority )
		{
			P=Level.ControllerList;
JL00C7:
			if ( P != None )
			{
				if ( P.Enemy == Incoming )
				{
					P.LineOfSightTo(Incoming);
				}
				P=P.nextController;
				goto JL00C7;
			}
		}
		if (  !Pawn(Incoming).SetLocation(Location) )
		{
			Log(string(self) $ " Teleport failed for " $ string(Incoming));
		}
		if ( (Role == Role_Authority) || (Level.TimeSeconds - LastFired > 0.50) )
		{
			Pawn(Incoming).SetRotation(newRot);
			Pawn(Incoming).SetViewRotation(newRot);
			LastFired=Level.TimeSeconds;
		}
		if ( Pawn(Incoming).Controller != None )
		{
			Pawn(Incoming).Controller.MoveTimer=-1.00;
			Pawn(Incoming).SetMoveTarget(self);
		}
		Incoming.PlayTeleportEffect(False,True);
	}
	else
	{
		if (  !Incoming.SetLocation(Location) )
		{
			Enable('Touch');
			return False;
		}
		if ( bChangesYaw )
		{
			Incoming.SetRotation(newRot);
		}
	}
	Enable('Touch');
	if ( bChangesVelocity )
	{
		Incoming.Velocity=TargetVelocity;
	}
	else
	{
		if ( bChangesYaw )
		{
			if ( Incoming.Physics == PHYS_Walking )
			{
				OldRot.Pitch=0;
			}
			oldDir=vector(OldRot);
			mag=Incoming.Velocity Dot oldDir;
			Incoming.Velocity=Incoming.Velocity - mag * oldDir + mag * vector(Incoming.Rotation);
		}
		if ( bReversesX )
		{
			Incoming.Velocity.X *= -1.00;
		}
		if ( bReversesY )
		{
			Incoming.Velocity.Y *= -1.00;
		}
		if ( bReversesZ )
		{
			Incoming.Velocity.Z *= -1.00;
		}
	}
	return True;
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	local Actor A;

	bEnabled= !bEnabled;
	if ( bEnabled )
	{
		foreach TouchingActors(Class'Actor',A)
		{
			Touch(A);
		}
	}
}

simulated function Touch (Actor Other)
{
	local Teleporter D;
	local Teleporter Dest[16];
	local int i;

	if (  !bEnabled )
	{
		return;
	}
	if ( Other.bCanTeleport && (Other.PreTeleport(self) == False) )
	{
		if ( (InStr(URL,"/") >= 0) || (InStr(URL,"#") >= 0) )
		{
			if ( (Role == Role_Authority) && (Pawn(Other) != None) && Pawn(Other).IsHumanControlled() )
			{
				Level.Game.SendPlayer(PlayerController(Pawn(Other).Controller),URL);
			}
		}
		else
		{
			foreach AllActors(Class'Teleporter',D)
			{
				if ( (string(D.Tag) ~= URL) && (D != self) )
				{
					Dest[i]=D;
					i++;
					if ( i > 16 )
					{
						goto JL012B;
					}
				}
JL012B:
			}
			i=Rand(i);
			if ( Dest[i] != None )
			{
				if ( Other.IsA('Pawn') )
				{
					Other.PlayTeleportEffect(False,True);
				}
				Dest[i].Accept(Other,self);
				if ( Pawn(Other) != None )
				{
					TriggerEvent(Event,self,Pawn(Other));
				}
			}
		}
	}
}

function Actor SpecialHandling (Pawn Other)
{
	local Vector Dist2D;

	if ( bEnabled && (Teleporter(Other.Controller.RouteCache[1]) != None) && (string(Other.Controller.RouteCache[1].Tag) ~= URL) )
	{
		if ( Abs(Location.Z - Other.Location.Z) < CollisionHeight + Other.CollisionHeight )
		{
			Dist2D=Location - Other.Location;
			Dist2D.Z=0.00;
			if ( VSize(Dist2D) < CollisionRadius + Other.CollisionRadius )
			{
				Touch(Other);
			}
		}
		return self;
	}
	if ( TriggerActor == None )
	{
		FindTriggerActor();
		if ( TriggerActor == None )
		{
			return None;
		}
	}
	if ( (TriggerActor2 != None) && (VSize(TriggerActor2.Location - Other.Location) < VSize(TriggerActor.Location - Other.Location)) )
	{
		return TriggerActor2;
	}
	return TriggerActor;
}

defaultproperties
{
    bChangesYaw=True
    bEnabled=True
    RemoteRole=ROLE_SimulatedProxy
    bCollideActors=True
    bDirectional=True
}
/*
    Texture=Texture'S_Teleport'
*/

