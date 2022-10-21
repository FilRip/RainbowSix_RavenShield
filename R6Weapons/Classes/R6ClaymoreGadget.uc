//================================================================================
// R6ClaymoreGadget.
//================================================================================
class R6ClaymoreGadget extends R6DemolitionsGadget;

function PlaceChargeAnimation ()
{
	R6Pawn(Owner).PlayClaymoreAnimation();
	ServerPlaceChargeAnimation();
}

function ServerPlaceChargeAnimation ()
{
//	R6Pawn(Owner).SetNextPendingAction(PENDING_Coughing7);
}

function SetAmmoStaticMesh ()
{
//	m_FPWeapon.m_smGun.SetStaticMesh(StaticMesh'R61stClaymore');
}

defaultproperties
{
    m_ChargeAttachPoint=TagClaymoreHand
    m_pBulletClass=Class'R6ClaymoreUnit'
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGadgetClaymore'
    m_pFPWeaponClass=Class'R61stWeapons.R61stClaymore'
    m_PawnWaitAnimLow=StandGrenade_nt
    m_PawnWaitAnimHigh=StandGrenade_nt
    m_PawnWaitAnimProne=ProneGrenade_nt
    m_PawnFiringAnim=CrouchClaymore
    m_PawnFiringAnimProne=ProneClaymore
    m_AttachPoint=TagClaymoreHand
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=452.00,W=0.00)
    m_NameID="ClaymoreGadget"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdClaymoreDetonator'
    m_DetonatorStaticMesh=StaticMesh'R61stWeapons_SM.Items.R61stClaymoreDetonator'
    m_ChargeStaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdClaymore'
    m_SingleFireStereoSnd=Sound'Gadget_Claymore.Play_ClaymorePlacement'
    m_SingleFireEndStereoSnd=Sound'Gadget_Claymore.Stop_Claymore_Go'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

