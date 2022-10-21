//================================================================================
// R6MuzzleFlash762mm.
//================================================================================
class R6MuzzleFlash762mm extends R6SFX;

defaultproperties
{
    Emitters(0)=SpriteEmitter'SmokeEmitter762a'
    Emitters(1)=SpriteEmitter'SmokeEmitter762b'
    Emitters(2)=SpriteEmitter'NoMuzzleEmitter762'
    Emitters(3)=SpriteEmitter'WithMuzzleEmitter762'
    Emitters(4)=SpriteEmitter'R61stMuzzleFlash762'
    RemoteRole=ROLE_None
    m_bDrawFromBase=True
    m_bTickOnlyWhenVisible=True
}
