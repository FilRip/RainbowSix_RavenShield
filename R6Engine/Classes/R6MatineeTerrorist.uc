//================================================================================
// R6MatineeTerrorist.
//================================================================================
class R6MatineeTerrorist extends R6Terrorist
	Native
	Placeable;

var(R6Equipment) bool m_bUseTerroristTemplate;
var R6MatineeAttach m_MatineeAttach;
var(R6Equipment) Class<R6AbstractWeapon> m_PrimaryWeapon;
var(R6Equipment) Class<R6Terrorist> m_TerroristTemplate;

event PostBeginPlay ()
{
	m_MatineeAttach=new Class'R6MatineeAttach';
	if ( (m_TerroristTemplate != None) && m_bUseTerroristTemplate )
	{
		Skins=m_TerroristTemplate.Default.Skins;
		LinkMesh(m_TerroristTemplate.Default.Mesh);
	}
	m_szPrimaryWeapon=string(m_PrimaryWeapon);
	CommonInit();
	SetPhysics(Physics);
}

function SetAttachVar (Actor AttachActor, string StaticMeshTag, name PawnTag)
{
	m_MatineeAttach.m_AttachActor=AttachActor;
	m_MatineeAttach.m_StaticMeshTag=StaticMeshTag;
	m_MatineeAttach.m_PawnTag=PawnTag;
	m_MatineeAttach.m_AttachPawn=self;
	m_MatineeAttach.InitAttach();
}

function MatineeAttach ()
{
	m_MatineeAttach.MatineeAttach();
}

function MatineeDetach ()
{
	m_MatineeAttach.MatineeDetach();
}

defaultproperties
{
    m_szPrimaryWeapon="R63rdWeapons.NormalSubMP5A4"
}
/*
    Mesh=SkeletalMesh'R6Terrorist_UKX.Militant01Mesh'
    KParams=KarmaParamsSkel'KarmaParamsSkel23'
*/

