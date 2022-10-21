//================================================================================
// R6MuzzleFlash12Gauge.
//================================================================================
class R6MuzzleFlash12Gauge extends R6SFX;

defaultproperties
{
    Emitters(0)=SpriteEmitter'SmokeEmitter12Ga'
    Emitters(1)=SpriteEmitter'SmokeEmitter12Gb'
    Emitters(2)=SpriteEmitter'NoMuzzleEmitter12G'
    Emitters(3)=SpriteEmitter'WithMuzzleEmitter12G'
    Emitters(4)=SpriteEmitter'R61stMuzzleFlash12G'
    RemoteRole=ROLE_None
    m_bDrawFromBase=True
    m_bTickOnlyWhenVisible=True
}
