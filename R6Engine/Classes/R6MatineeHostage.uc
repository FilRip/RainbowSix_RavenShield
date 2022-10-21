//================================================================================
// R6MatineeHostage.
//================================================================================
class R6MatineeHostage extends R6Hostage
	Native
	Placeable;

var(R6Equipment) bool m_bUseHostageTemplate;
var R6MatineeAttach m_MatineeAttach;
var(R6Equipment) Class<R6Hostage> m_HostageTemplate;

event PostBeginPlay ()
{
	m_MatineeAttach=new Class'R6MatineeAttach';
	if ( (m_HostageTemplate != None) && m_bUseHostageTemplate )
	{
		Skins=m_HostageTemplate.Default.Skins;
		LinkMesh(m_HostageTemplate.Default.Mesh);
	}
	Super.PostBeginPlay();
	if ( Controller != None )
	{
		UnPossessed();
	}
	Controller=Spawn(ControllerClass);
	Controller.Possess(self);
	m_controller=R6HostageAI(Controller);
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
    m_bUseHostageTemplate=True
    CollisionHeight=85.00
}
/*
    Mesh=SkeletalMesh'R6Hostage_UKX.CasualManMesh'
    KParams=KarmaParamsSkel'KarmaParamsSkel18'
*/

