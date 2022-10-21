//================================================================================
// R6PlanningGrenade.
//================================================================================
class R6PlanningGrenade extends R6ReferenceIcons;

var Texture m_pIconTex[4];

function SetGrenadeType (EPlanAction eGrenade)
{
	Texture=m_pIconTex[eGrenade - 1];
}

defaultproperties
{
    m_bSkipHitDetection=False
    DrawScale=1.25
}
/*
    m_pIconTex(0)=Texture'R6Planning.Icons.PlanIcon_Frag'
    m_pIconTex(1)=Texture'R6Planning.Icons.PlanIcon_Flash'
    m_pIconTex(2)=Texture'R6Planning.Icons.PlanIcon_Gas'
    m_pIconTex(3)=Texture'R6Planning.Icons.PlanIcon_Smoke'
*/

