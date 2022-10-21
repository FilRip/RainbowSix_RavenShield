Class ARSGreenTeamPawnClass extends R6RainbowMediumBlue;

event Touch(actor Other)
{
    if (Other.IsA('R6Weapons'))
        CheckPickupWeapon();
}

function CheckPickupWeapon()
{
}

function DropWeapon ()
{
	EngineWeapon.StartFalling();
}

function int R6TakeDamage (int iKillValue, int iStunValue, Pawn instigatedBy, Vector vHitLocation, Vector vMomentum, int iBulletToArmorModifier, optional int iBulletGoup)
{
    Log("TakeDamage");
    Log("Health = "$string(Health));
    Log("iKillValue="$string(iKillValue));
    Log("iStunValue="$string(iStunValue));
    return Super.R6TakeDamage(iKillValue,iStunValue,instigatedBy,vHitLocation,vMomentum,iBulletToArmorModifier,iBulletGoup);
}

defaultproperties
{
    bCanJump=True
    m_fWalkingSpeed=170.00
    m_fWalkingBackwardStrafeSpeed=170.00
    m_fRunningSpeed=300.00
    m_fRunningBackwardStrafeSpeed=300.00
    m_fCrouchedWalkingSpeed=120.00
    m_fCrouchedWalkingBackwardStrafeSpeed=120.00
    m_fCrouchedRunningSpeed=120.00
    m_fCrouchedRunningBackwardStrafeSpeed=120.00
    m_fProneSpeed=45.00
    m_fProneStrafeSpeed=17.00
}

