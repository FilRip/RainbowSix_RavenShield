//================================================================================
// R6SubActionAnimSequence.
//================================================================================
class R6SubActionAnimSequence extends MatSubAction
	Native;

var int m_CurIndex;
var(R6Animation) bool m_bUseRootMotion;
var bool m_bFirstTime;
var bool m_bResetAnimation;
var(R6Animation) R6Pawn m_AffectedPawn;
var(R6Animation) Actor m_AffectedActor;
var R6PlayAnim m_CurSequence;
var(R6Animation) export editinlineuse array<R6PlayAnim> m_Sequences;

event Initialize ()
{
	m_bFirstTime=True;
	if ( (m_AffectedPawn != None) && (m_AffectedActor == None) )
	{
		m_AffectedActor=m_AffectedPawn;
	}
}

event SequenceChanged ()
{
	m_AffectedActor.SetAttachVar(m_CurSequence.m_AttachActor,m_CurSequence.m_StaticMeshTag,m_CurSequence.m_PawnTag);
}

event SequenceFinished ()
{
	if ( m_bUseRootMotion )
	{
		m_AffectedActor.bCollideWorld=True;
		m_AffectedActor.SetPhysics(PHYS_Walking);
	}
}

defaultproperties
{
    m_bUseRootMotion=True
    m_bFirstTime=True
    Desc="PlayAnimation"
}
/*
    Icon=Texture'R6SubActionAnimSequenceIcon'
*/

