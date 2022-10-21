//================================================================================
// R6MuzzleFlash9mm.
//================================================================================
class R6MuzzleFlash9mm extends R6SFX;

defaultproperties
{
    Emitters(0)=SpriteEmitter'SmokeEmitter9a'
    Emitters(1)=SpriteEmitter'SmokeEmitter9b'
    Emitters(2)=SpriteEmitter'NoMuzzleEmitter9'
    Emitters(3)=SpriteEmitter'WithMuzzleEmitter9'
    Emitters(4)=SpriteEmitter'R61stMuzzleFlash9'
    RemoteRole=ROLE_None
    m_bDrawFromBase=True
    m_bTickOnlyWhenVisible=True
}
