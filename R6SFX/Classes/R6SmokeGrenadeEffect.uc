//================================================================================
// R6SmokeGrenadeEffect.
//================================================================================
class R6SmokeGrenadeEffect extends R6SFX;

defaultproperties
{
    AutoDestroy=True
    Emitters(0)=SpriteEmitter'SpriteEmitterSmoke1'
    bNetDirty=True
    bAlwaysRelevant=True
    LifeSpan=60.00
}
