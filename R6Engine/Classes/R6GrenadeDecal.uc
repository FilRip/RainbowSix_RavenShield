//================================================================================
// R6GrenadeDecal.
//================================================================================
class R6GrenadeDecal extends R6DecalsBase;

var Texture m_GrenadeDecalTexture;

simulated function PostBeginPlay ()
{
	local Rotator DecalRot;

	if ( Level.NetMode != 1 )
	{
		DecalRot.Pitch=49152;
		DecalRot.Yaw=0;
		DecalRot.Roll=Rand(65535);
		Level.m_DecalManager.AddDecal(Location,DecalRot,m_GrenadeDecalTexture,DECAL_GrenadeDecals,1,0.00,0.00,50.00);
	}
	Super.PostBeginPlay();
}

defaultproperties
{
    bHidden=True
    bNetOptional=True
    bNetInitialRotation=False
    LifeSpan=0.10
    Texture=None
}
/*
    m_GrenadeDecalTexture=Texture'R6SFX_T.Grenade.GrenadeImpact'
*/

