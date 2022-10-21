//================================================================================
// R6MatineeRainbow.
//================================================================================
class R6MatineeRainbow extends R6Rainbow
	Native
	Placeable;

var(R6Equipment) bool m_bActivateGadget;
var(R6Equipment) bool m_bUseRainbowTemplate;
var R6RainbowAI m_controller;
var R6MatineeAttach m_MatineeAttach;
var(R6Equipment) Class<R6AbstractWeapon> m_PrimaryWeapon;
var(R6Equipment) Class<R6AbstractWeapon> m_SecondaryWeapon;
var(R6Equipment) Class<R6AbstractGadget> m_PrimaryGadget;
var(R6Equipment) Class<R6AbstractGadget> m_SecondaryGadget;
var(R6Equipment) Class<R6Rainbow> m_RainbowTemplate;

event PostBeginPlay ()
{
	m_MatineeAttach=new Class'R6MatineeAttach';
	if ( (m_RainbowTemplate != None) && m_bUseRainbowTemplate )
	{
		Skins=m_RainbowTemplate.Default.Skins;
		LinkMesh(m_RainbowTemplate.Default.Mesh);
		m_HelmetClass=m_RainbowTemplate.Default.m_HelmetClass;
	}
	Super.PostBeginPlay();
	m_szPrimaryWeapon=string(m_PrimaryWeapon);
	m_szPrimaryGadget=string(m_PrimaryGadget);
	m_szSecondaryWeapon=string(m_SecondaryWeapon);
	m_szSecondaryGadget=string(m_SecondaryGadget);
	if ( Controller != None )
	{
		UnPossessed();
	}
	Controller=Spawn(ControllerClass);
	m_controller=R6RainbowAI(Controller);
	m_controller.m_PaceMember=self;
	m_controller.m_TeamLeader=self;
	m_controller.Possess(self);
	GiveDefaultWeapon();
	if ( m_bActivateGadget == True )
	{
		m_bWeaponGadgetActivated=True;
		R6AbstractWeapon(EngineWeapon).m_SelectedWeaponGadget.ActivateGadget(True);
	}
}

function SetMovementPhysics ()
{
}

function SetAttachVar (Actor AttachActor, string StaticMeshTag, name PawnTag)
{
	Log("R6MatineeRainbow::SetAttachVar");
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
    m_bActivateGadget=True
    m_bUseRainbowTemplate=True
}
/*
    Mesh=SkeletalMesh'R6Rainbow_UKX.LightMesh'
    KParams=KarmaParamsSkel'KarmaParamsSkel21'
*/

