//================================================================================
// Light.
//================================================================================
class Light extends Actor
	Native
//	NoNativeReplication
	Placeable;

defaultproperties
{
    LightType=1
    LightSaturation=255
    LightPeriod=32
    LightCone=128
    bStatic=True
    bHidden=True
    bNoDelete=True
    bMovable=False
    CollisionRadius=24.00
    CollisionHeight=24.00
    LightBrightness=64.00
    LightRadius=64.00
}
/*
    Texture=Texture'S_Light'
*/

