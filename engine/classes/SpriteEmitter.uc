//================================================================================
// SpriteEmitter.
//================================================================================
class SpriteEmitter extends ParticleEmitter
	Native;

enum EParticleDirectionUsage {
	PTDU_None,
	PTDU_Up,
	PTDU_Right,
	PTDU_Forward,
	PTDU_Normal,
	PTDU_UpAndNormal,
	PTDU_RightAndNormal
};

var(Sprite) EParticleDirectionUsage UseDirectionAs;
var(Sprite) Vector ProjectionNormal;
var transient Vector RealProjectionNormal;

defaultproperties
{
    ProjectionNormal=(X=0.00,Y=0.00,Z=1.00)
}