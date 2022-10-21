//================================================================================
// AnimNotify_Effect.
//================================================================================
class AnimNotify_Effect extends AnimNotify
	Native;

var() bool Attach;
var() float DrawScale;
var() name Bone;
var() name Tag;
var() Class<Actor> EffectClass;
var() Vector OffsetLocation;
var() Rotator OffsetRotation;
var() Vector DrawScale3D;
var transient private Actor LastSpawnedEffect;

defaultproperties
{
    DrawScale=1.00
    DrawScale3D=(X=1.00,Y=1.00,Z=1.00)
}