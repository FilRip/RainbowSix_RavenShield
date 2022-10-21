//================================================================================
// R6MuzzleFlash50M33.
//================================================================================
class R6MuzzleFlash50M33 extends R6SFX;

defaultproperties
{
    Emitters(0)=SpriteEmitter'SmokeEmitter50a'
    Emitters(1)=SpriteEmitter'SmokeEmitter50b'
    Emitters(2)=SpriteEmitter'NoMuzzleEmitter50'
    Emitters(3)=SpriteEmitter'WithMuzzleEmitter50'
    Emitters(4)=SpriteEmitter'R61stMuzzleFlash50'
    RemoteRole=ROLE_None
    m_bDrawFromBase=True
    m_bTickOnlyWhenVisible=True
}
