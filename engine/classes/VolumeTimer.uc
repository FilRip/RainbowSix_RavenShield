//================================================================================
// VolumeTimer.
//================================================================================
class VolumeTimer extends Info;

var PhysicsVolume V;

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	SetTimer(1.00,True);
	V=PhysicsVolume(Owner);
}

function Timer ()
{
	V.TimerPop(self);
}

defaultproperties
{
    RemoteRole=Role_None
}