//================================================================================
// R6RemoteChargeGadget.
//================================================================================
class R6RemoteChargeGadget extends R6DemolitionsGadget;

function PlaceChargeAnimation ()
{
	ServerPlaceChargeAnimation();
}

function ServerPlaceChargeAnimation ()
{
//	R6Pawn(Owner).SetNextPendingAction(PENDING_Coughing5);
}

function SetAmmoStaticMesh ()
{
//	m_FPWeapon.m_smGun.SetStaticMesh(StaticMesh'R61stC4');
}

defaultproperties
{
    m_ChargeAttachPoint=TagC4Hand
    m_pBulletClass=Class'R6RemoteChargeUnit'
    m_pFPWeaponClass=Class'R61stWeapons.R61stRemoteCharge'
    m_PawnWaitAnimLow=StandGrenade_nt
    m_PawnWaitAnimHigh=StandGrenade_nt
    m_PawnWaitAnimProne=ProneGrenade_nt
    m_PawnFiringAnim=CrouchC4
    m_AttachPoint=TagC4Hand
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=419.00,W=0.00)
    m_NameID="RemoteChargeGadget"
}
/*
    m_DetonatorStaticMesh=StaticMesh'R61stWeapons_SM.Items.R61stC4Detonator'
    m_ChargeStaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdC4'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdC4Detonator'
    m_SingleFireStereoSnd=Sound'Gadget_Claymore.Play_ClaymorePlacement'
    m_SingleFireEndStereoSnd=Sound'Gadget_Claymore.Stop_Claymore_Go'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

