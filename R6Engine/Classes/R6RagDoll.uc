//================================================================================
// R6RagDoll.
//================================================================================
class R6RagDoll extends R6AbstractCorpse
	Native;

struct STSpring
{
	var int iFirst;
	var int iSecond;
	var float fMinSquared;
	var float fMaxSquared;
};

struct STParticle
{
	var Coords cCurrentPos;
	var Vector vPreviousOrigin;
	var Vector vBonePosition;
	var float fMass;
	var int iToward;
	var int iRefBone;
	var name BoneName;
};

var float m_fAccumulatedTime;
var R6AbstractPawn m_pawnOwner;
var array<STSpring> m_aSpring;
var STParticle m_aParticle[16];
const NB_PARTICLES= 16;

function TakeAHit (int iBone, Vector vMomentum)
{
	AddImpulseToBone(iBone,vMomentum);
}

function RenderCorpseBones (Canvas C)
{
	RenderBones(C);
}

defaultproperties
{
    RemoteRole=ROLE_AutonomousProxy
    bAlwaysRelevant=True
    m_bShowInHeatVision=True
}
