//================================================================================
// R6Shotgun.
//================================================================================
class R6Shotgun extends R6Weapons
	Abstract;

function int NbBulletToShot ()
{
	if ( (m_pBulletClass != None) && (m_pBulletClass.Default.m_szBulletType == "BUCK") )
	{
		return 9;
	}
	return 1;
}

defaultproperties
{
    m_eWeaponType=3
    m_eGripType=5
    m_PawnWaitAnimLow=StandShotGunLow_nt
    m_PawnWaitAnimHigh=StandShotGunHigh_nt
    m_PawnWaitAnimProne=ProneShotGun_nt
    m_PawnFiringAnim=StandFireShotGun
    m_AttachPoint=TagRightHand
    m_HoldAttachPoint=TagBack
}
/*
    m_ShellSingleFireSnd=Sound'CommonShotguns.Play_Shotgun_SingleShell'
    m_ShellEndFullAutoSnd=Sound'CommonShotguns.Play_Shotgun_EndShell'
*/

