//================================================================================
// R6TearsGazGrenadeEffect.
//================================================================================
class R6TearsGazGrenadeEffect extends R6SFX;

defaultproperties
{
    AutoDestroy=True
    Emitters(0)=SpriteEmitter'SpriteEmitterGasGrenade'
    Emitters(1)=SpriteEmitter'SpriteEmitterGasGrenade01'
    Emitters(2)=SpriteEmitter'SpriteEmitterGasGrenade02'
    Emitters(3)=SpriteEmitter'SpriteEmitterGasGrenade03'
    bDynamicLight=True
    bNetDirty=True
    bAlwaysRelevant=True
    LifeSpan=60.00
}
