//================================================================================
// R6TerroristMgr.
//================================================================================
class R6TerroristMgr extends R6AbstractTerroristMgr
	Native;

struct STHostage
{
	var R6Hostage hostage;
	var R6TerroristAI terro;
	var int bInZone;
};

var int m_iCurrentMax;
var int m_iCurrentGroupID;
var const array<R6DeploymentZone> m_aDeploymentZoneWithHostage;
var STHostage m_ArrayHostage[16];
const MAX_Hostage= 16;

native(1825) final function Init (Actor dummy);

native(1826) final function R6DeploymentZone FindNearestZoneForHostage (R6Terrorist terro);

function Initialization (Actor dummy)
{
	Init(dummy);
}

function ResetOriginalData ()
{
	local int i;

	for (i=0;i < 16;i++)
	{
		m_ArrayHostage[i].hostage=None;
		m_ArrayHostage[i].terro=None;
		m_ArrayHostage[i].bInZone=0;
	}
	m_iCurrentMax=0;
}

function int FindHostageIndex (R6Hostage hostage)
{
	local int i;

	if ( hostage.m_iIndex != -1 )
	{
		return hostage.m_iIndex;
	}
	else
	{
		m_iCurrentMax++;
		assert (m_iCurrentMax < 16);
		m_ArrayHostage[m_iCurrentMax].hostage=hostage;
		hostage.m_iIndex=m_iCurrentMax;
		return m_iCurrentMax;
	}
}

function bool IsHostageAssigned (R6Hostage hostage)
{
	local int i;

	i=FindHostageIndex(hostage);
	if ( hostage.m_ePersonality == 3 )
	{
		return True;
	}
	else
	{
		return (m_ArrayHostage[i].terro != None) || (m_ArrayHostage[i].bInZone == 1);
	}
}

function AssignHostageTo (R6Hostage hostage, R6TerroristAI terro)
{
	local int i;
	local R6DeploymentZone Zone;

	i=FindHostageIndex(hostage);
	m_ArrayHostage[i].terro=terro;
	m_ArrayHostage[i].bInZone=0;
}

function AssignHostageToZone (R6Hostage hostage, R6DeploymentZone Zone)
{
	local int i;

	i=FindHostageIndex(hostage);
	m_ArrayHostage[i].terro=None;
	m_ArrayHostage[i].bInZone=1;
	Zone.AddHostage(hostage);
}

function RemoveHostageAssignment (R6Hostage hostage)
{
	local int i;

	i=FindHostageIndex(hostage);
	m_ArrayHostage[i].terro=None;
	m_ArrayHostage[i].bInZone=0;
}

defaultproperties
{
    m_iCurrentMax=-1
}
