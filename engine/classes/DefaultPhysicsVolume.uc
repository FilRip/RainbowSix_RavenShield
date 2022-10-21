//================================================================================
// DefaultPhysicsVolume.
//================================================================================
class DefaultPhysicsVolume extends PhysicsVolume
	Native;
//	NoNativeReplication;

function Destroyed ()
{
	Log(string(self) $ " destroyed!");
	assert (False);
}

defaultproperties
{
    RemoteRole=ROLE_None
    bStatic=False
    bNoDelete=False
    bAlwaysRelevant=False
}