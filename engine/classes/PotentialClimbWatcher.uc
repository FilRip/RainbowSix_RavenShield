//================================================================================
// PotentialClimbWatcher.
//================================================================================
class PotentialClimbWatcher extends Info
	Native;

simulated function Tick (float DeltaTime)
{
	local Rotator PawnRot;
	local LadderVolume L;
	local bool bFound;

	if ( (Owner == None) || Owner.bDeleteMe ||  !Pawn(Owner).CanGrabLadder() )
	{
		Destroy();
		return;
	}
	PawnRot=Owner.Rotation;
	PawnRot.Pitch=0;
	foreach Owner.TouchingActors(Class'LadderVolume',L)
	{
		if ( L.Encompasses(Owner) )
		{
			if ( (Vector(PawnRot) Dot L.LookDir) > 0.90 )
			{
				Pawn(Owner).ClimbLadder(L);
				Destroy();
				return;
			}
			else
			{
				bFound=True;
			}
		}
	}
	if (  !bFound )
	{
		Destroy();
	}
}
