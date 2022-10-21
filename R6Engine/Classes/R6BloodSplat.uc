//================================================================================
// R6BloodSplat.
//================================================================================
class R6BloodSplat extends R6DecalsBase;

var Texture m_BloodSplatTexture;

simulated function PostBeginPlay ()
{
	local Rotator DecalRot;

	if ( Level.NetMode != 1 )
	{
		DecalRot=Rotation;
		DecalRot.Roll=Rand(65535);
		Level.m_DecalManager.AddDecal(Location,DecalRot,m_BloodSplatTexture,DECAL_BloodSplats,1,0.00,0.00,300.00);
	}
	Super.PostBeginPlay();
}

defaultproperties
{
    bHidden=True
    bNetOptional=True
    LifeSpan=0.10
    Texture=None
}
/*
    m_BloodSplatTexture=Texture'Inventory_t.BloodSplats.BloodSplat'
*/

