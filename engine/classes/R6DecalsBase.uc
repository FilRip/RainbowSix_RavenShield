//================================================================================
// R6DecalsBase.
//================================================================================
class R6DecalsBase extends Actor
	Native;
//	NoNativeReplication;

simulated function PostBeginPlay ()
{
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    DrawType=0
    bNetTemporary=True
    bReplicateMovement=False
    bNetInitialRotation=True
    bUnlit=True
    bGameRelevant=True
}