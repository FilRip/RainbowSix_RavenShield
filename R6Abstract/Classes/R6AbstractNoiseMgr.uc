//================================================================================
// R6AbstractNoiseMgr.
//================================================================================
class R6AbstractNoiseMgr extends Object
	Native
	Abstract;
//	Export;

enum ESoundType {
	SNDTYPE_None,
	SNDTYPE_Gunshot,
	SNDTYPE_BulletImpact,
	SNDTYPE_GrenadeImpact,
	SNDTYPE_GrenadeLike,
	SNDTYPE_Explosion,
	SNDTYPE_PawnMovement,
	SNDTYPE_Choking,
	SNDTYPE_Talking,
	SNDTYPE_Screaming,
	SNDTYPE_Reload,
	SNDTYPE_Equipping,
	SNDTYPE_Dead,
	SNDTYPE_Door
};

event R6MakeNoise (ESoundType eType, Actor Source);

function R6MakePawnMovementNoise (R6AbstractPawn Pawn);

function Init ();
