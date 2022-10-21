//================================================================================
// R6Gadget.
//================================================================================
class R6Gadget extends R6Weapons
	Native
	Abstract;

simulated function TurnOffEmitters (bool bTurnOff)
{
}

simulated function DisableWeaponOrGadget ()
{
	if ( bShowLog )
	{
		Log(string(self) $ " DisableWeaponOrGadget() was called...");
	}
}

function SetHoldAttachPoint ()
{
	if ( m_InventoryGroup == 4 )
	{
		m_HoldAttachPoint=m_HoldAttachPoint2;
	}
}

function GiveMoreAmmo ()
{
	m_iNbBulletsInWeapon += m_iClipCapacity;
}

defaultproperties
{
    m_stAccuracyValues=(fBaseAccuracy=-171984016.00,fShuffleAccuracy=11.86,fWalkingAccuracy=-107552800.00,fWalkingFastAccuracy=0.00,fRunningAccuracy=-107374880.00,fReticuleTime=0.00,fAccuracyChange=0.10,fWeaponJump=-171980736.00)
    m_eWeaponType=7
    m_eGripType=0
    m_InventoryGroup=3
    m_HoldAttachPoint=TagItemBack1
    m_HoldAttachPoint2=TagItemBack2
}

