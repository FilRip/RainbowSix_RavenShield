//================================================================================
// Info.
//================================================================================
class Info extends Actor
	Native
	Abstract
//	NoNativeReplication
	HideCategories(Movement,Collision,Lighting,LightColor,Karma,Force);

defaultproperties
{
    bHidden=True
    bSkipActorPropertyReplication=True
    bOnlyDirtyReplication=True
    NetUpdateFrequency=5.00
}