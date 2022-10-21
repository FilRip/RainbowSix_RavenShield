//================================================================================
// AnimNotify_DestroyEffect.
//================================================================================
class AnimNotify_DestroyEffect extends AnimNotify
	Native;

var() bool bExpireParticles;
var() name DestroyTag;

defaultproperties
{
    bExpireParticles=True
}