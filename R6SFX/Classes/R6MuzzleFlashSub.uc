//================================================================================
// R6MuzzleFlashSub.
//================================================================================
class R6MuzzleFlashSub extends R6SFX;

defaultproperties
{
    Emitters(0)=SpriteEmitter'SmokeEmitterSuba'
    Emitters(1)=SpriteEmitter'SmokeEmitterSubb'
    Emitters(2)=SpriteEmitter'NoMuzzleEmitterSub'
    Emitters(3)=SpriteEmitter'WithMuzzleEmitterSub'
    Emitters(4)=SpriteEmitter'R61stMuzzleFlashSub'
    RemoteRole=ROLE_None
    m_bDrawFromBase=True
    m_bTickOnlyWhenVisible=True
}
