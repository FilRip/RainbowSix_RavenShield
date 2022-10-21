//================================================================================
// R6MiniScopeGadget.
//================================================================================
class R6MiniScopeGadget extends R6AbstractGadget;
//	NoNativeReplication;

var Actor m_FPMiniScopeModel;
var Texture m_ScopeTexure;
var Texture m_ScopeAdd;
var(R6Attachment) Class<Actor> m_pFPMiniScopeClass;

simulated event Destroyed ()
{
	Super.Destroyed();
	DestroyFPGadget();
}

function InitGadget (R6EngineWeapon OwnerWeapon, Pawn OwnerCharacter)
{
	OwnerWeapon.m_fMaxZoom=3.50;
	OwnerWeapon.UseScopeStaticMesh();
	Super.InitGadget(OwnerWeapon,OwnerCharacter);
}

function ActivateGadget (bool bActivate, optional bool bControllerInBehindView)
{
}

simulated function UpdateAttachment (R6EngineWeapon weapOwner)
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	Super.UpdateAttachment(weapOwner);
	m_GadgetShortName=Localize(m_NameID,"ID_SHORTNAME","R6WeaponGadgets");
	SetBase(None);
	SetBase(weapOwner,weapOwner.Location);
	weapOwner.GetTagInformations("TagScope",vTagLocation,rTagRotator);
	SetRelativeLocation(vTagLocation);
	SetRelativeRotation(rTagRotator);
}

simulated function AttachFPGadget ()
{
	if ( (m_WeaponOwner == None) || (R6AbstractWeapon(m_WeaponOwner).m_FPWeapon == None) )
	{
		return;
	}
	if ( (m_FPMiniScopeModel == None) && (m_pFPMiniScopeClass != None) )
	{
		m_FPMiniScopeModel=Spawn(m_pFPMiniScopeClass);
		m_FPMiniScopeModel.SetOwner(self);
		m_FPMiniScopeModel.RemoteRole=ROLE_None;
	}
	if ( m_FPMiniScopeModel != None )
	{
		R6AbstractWeapon(m_WeaponOwner).m_FPWeapon.AttachToBone(m_FPMiniScopeModel,'TagScope');
		R6AbstractWeapon(m_WeaponOwner).m_FPWeapon.SwitchFPMesh();
		R6AbstractWeapon(m_WeaponOwner).m_FPHands.SwitchFPAnim();
	}
	m_WeaponOwner.m_ScopeTexture=m_ScopeTexure;
	m_WeaponOwner.m_ScopeAdd=m_ScopeAdd;
}

simulated function DestroyFPGadget ()
{
	local Actor temp;

	if ( m_FPMiniScopeModel != None )
	{
		temp=m_FPMiniScopeModel;
		m_FPMiniScopeModel=None;
		temp.Destroy();
	}
}

defaultproperties
{
    m_pFPMiniScopeClass=Class'R61stMiniScope'
    m_NameID="MiniScope"
    DrawType=8
    m_bDrawFromBase=True
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Gadgets.R63rdMiniScope'
    m_ScopeTexure=Texture'Inventory_t.Scope.ScopeBlurTex_3'
    m_ScopeAdd=Texture'Inventory_t.Scope.ScopeBlurTex_3add'
*/

