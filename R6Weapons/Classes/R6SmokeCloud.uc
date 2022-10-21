//================================================================================
// R6SmokeCloud.
//================================================================================
class R6SmokeCloud extends Actor
	Native;
//	NoNativeReplication;

var float m_fStartTime;
var float m_fExpansionTime;
var float m_fFinalRadius;
var float m_fCurrentRadius;
var R6Grenade m_grenade;

function SetCloud (R6Grenade aGrenade, float fExpansionTime, float fFinalRadius, float fDuration)
{
	m_grenade=aGrenade;
	m_fExpansionTime=fExpansionTime;
	m_fFinalRadius=fFinalRadius;
	LifeSpan=fDuration;
	m_fStartTime=Level.TimeSeconds;
	Instigator=None;
	SetTimer(0.25,True);
}

event Timer ()
{
	local float fElapsedTime;

	fElapsedTime=Level.TimeSeconds - m_fStartTime;
	if ( (m_grenade != None) && (m_grenade.Physics != 0) )
	{
		SetLocation(m_grenade.Location + vect(0.00,0.00,125.00));
	}
	if ( fElapsedTime < m_fExpansionTime )
	{
		m_fCurrentRadius=fElapsedTime / m_fExpansionTime * m_fFinalRadius;
	}
	else
	{
		m_fCurrentRadius=m_fFinalRadius;
		SetTimer(0.00,False);
	}
	SetCollisionSize(m_fCurrentRadius,CollisionHeight);
}

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=0
    m_bDeleteOnReset=True
    bCollideActors=True
    CollisionRadius=10.00
    CollisionHeight=125.00
}