//================================================================================
// R6PawnReplicationInfo.
//================================================================================
class R6PawnReplicationInfo extends Actor
	Native;
//	NoNativeReplication;

var byte m_PawnType;
var bool m_bSex;
var bool m_bDoNotPlayFullAutoSound;
var Controller m_ControllerOwner;
var Sound m_TriggerSnd[4];
var Sound m_SingleFireStereoSnd[4];
var Sound m_SingleFireEndStereoSnd[4];
var Sound m_BurstFireStereoSnd[4];
var Sound m_FullAutoStereoSnd[4];
var Sound m_FullAutoEndStereoSnd[4];
var Sound m_EmptyMagSnd[4];
var Sound m_ReloadEmptySnd[4];
var Sound m_ReloadSnd[4];
var Sound m_ShellSingleFireSnd[4];
var Sound m_ShellBurstFireSnd[4];
var Sound m_ShellFullAutoSnd[4];
var Sound m_ShellEndFullAutoSnd[4];

replication
{
	reliable if ( Role == Role_Authority )
		m_PawnType,m_bSex,m_ControllerOwner;
}

simulated function ResetOriginalData ()
{
	Super.ResetOriginalData();
	m_bDoNotPlayFullAutoSound=False;
}

simulated function AssignSound (Class<R6EngineWeapon> WeaponClass, byte u8CurrentWepon)
{
	if ( WeaponClass != None )
	{
		m_TriggerSnd[u8CurrentWepon]=WeaponClass.Default.m_TriggerSnd;
		m_SingleFireStereoSnd[u8CurrentWepon]=WeaponClass.Default.m_SingleFireStereoSnd;
		m_SingleFireEndStereoSnd[u8CurrentWepon]=WeaponClass.Default.m_SingleFireEndStereoSnd;
		m_BurstFireStereoSnd[u8CurrentWepon]=WeaponClass.Default.m_BurstFireStereoSnd;
		m_FullAutoStereoSnd[u8CurrentWepon]=WeaponClass.Default.m_FullAutoStereoSnd;
		m_FullAutoEndStereoSnd[u8CurrentWepon]=WeaponClass.Default.m_FullAutoEndStereoSnd;
		m_ReloadSnd[u8CurrentWepon]=WeaponClass.Default.m_ReloadSnd;
		m_ReloadEmptySnd[u8CurrentWepon]=WeaponClass.Default.m_ReloadEmptySnd;
		m_EmptyMagSnd[u8CurrentWepon]=WeaponClass.Default.m_EmptyMagSnd;
		m_ShellSingleFireSnd[u8CurrentWepon]=WeaponClass.Default.m_ShellSingleFireSnd;
		m_ShellBurstFireSnd[u8CurrentWepon]=WeaponClass.Default.m_ShellBurstFireSnd;
		m_ShellFullAutoSnd[u8CurrentWepon]=WeaponClass.Default.m_ShellFullAutoSnd;
		m_ShellEndFullAutoSnd[u8CurrentWepon]=WeaponClass.Default.m_ShellEndFullAutoSnd;
		AddAndFindBankInSound(WeaponClass.Default.m_EquipSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_UnEquipSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_ReloadSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_ReloadEmptySnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_ChangeROFSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_SingleFireStereoSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_SingleFireEndStereoSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_BurstFireStereoSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_FullAutoStereoSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_FullAutoEndStereoSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_EmptyMagSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_TriggerSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_ShellSingleFireSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_ShellBurstFireSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_ShellFullAutoSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_ShellEndFullAutoSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_SniperZoomFirstSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_SniperZoomSecondSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_CommonWeaponZoomSnd,LBS_Gun);
		AddAndFindBankInSound(WeaponClass.Default.m_BipodSnd,LBS_Gun);
	}
}

defaultproperties
{
    m_PawnType=1
    RemoteRole=ROLE_AutonomousProxy
    DrawType=0
    bHidden=True
    bAlwaysRelevant=True
    bSkipActorPropertyReplication=True
    NetUpdateFrequency=5.00
}
