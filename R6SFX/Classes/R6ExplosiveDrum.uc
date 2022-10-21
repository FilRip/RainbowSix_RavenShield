//================================================================================
// R6ExplosiveDrum.
//================================================================================
class R6ExplosiveDrum extends R6SFX;

defaultproperties
{
    AutoDestroy=True
    Emitters(0)=SpriteEmitter'SpriteExplosiveDrum01'
    Emitters(1)=SpriteEmitter'SpriteExplosiveDrum02'
    Emitters(2)=MeshEmitter'MeshExplosiveDrum03'
    Emitters(3)=SpriteEmitter'SpriteFlashExplosiveDrum04'
    bAlwaysRelevant=True
    LifeSpan=15.00
}
