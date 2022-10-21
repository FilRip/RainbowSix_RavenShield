//================================================================================
// R6InteractiveObjectActionLoopRandomAnim.
//================================================================================
class R6InteractiveObjectActionLoopRandomAnim extends R6InteractiveObjectAction;

var(PlayAnim) editinlineuse array<name> m_aAnimName;

function name GetNextAnim ()
{
	return m_aAnimName[Rand(m_aAnimName.Length)];
}

defaultproperties
{
    m_eType=4
}