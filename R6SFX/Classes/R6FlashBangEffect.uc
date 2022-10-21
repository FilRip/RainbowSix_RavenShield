//================================================================================
// R6FlashBangEffect.
//================================================================================
class R6FlashBangEffect extends R6SFX;

defaultproperties
{
    AutoDestroy=True
    Emitters(0)=SpriteEmitter'SpriteEmitterFlashBang1'
    Emitters(1)=SpriteEmitter'SpriteEmitterFlashBang2'
    Emitters(2)=SpriteEmitter'SpriteEmitterFlashBang3'
    bDynamicLight=True
    bNetDirty=True
    bAlwaysRelevant=True
    LifeSpan=5.00
}
