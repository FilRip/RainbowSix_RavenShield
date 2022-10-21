//================================================================================
// R6MuzzleFlash556mm.
//================================================================================
class R6MuzzleFlash556mm extends R6SFX;

defaultproperties
{
    Emitters(0)=SpriteEmitter'SmokeEmitter556a'
    Emitters(1)=SpriteEmitter'SmokeEmitter556b'
    Emitters(2)=SpriteEmitter'NoMuzzleEmitter556'
    Emitters(3)=SpriteEmitter'WithMuzzleEmitter556'
    Emitters(4)=SpriteEmitter'R61stMuzzleFlash556'
    RemoteRole=ROLE_None
    m_bDrawFromBase=True
    m_bTickOnlyWhenVisible=True
}
