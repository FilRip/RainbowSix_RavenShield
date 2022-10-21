//================================================================================
// R6Magazine.
//================================================================================
class R6Magazine extends Actor
	Abstract;
//	NoNativeReplication;

var() bool bDisplayedOnceInserted;

defaultproperties
{
    bDisplayedOnceInserted=True
    RemoteRole=ROLE_AutonomousProxy
    DrawScale3D=(X=-1.00,Y=-1.00,Z=1.00)
}