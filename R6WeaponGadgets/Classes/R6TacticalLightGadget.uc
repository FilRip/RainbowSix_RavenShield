//================================================================================
// R6TacticalLightGadget.
//================================================================================
class R6TacticalLightGadget extends R6AbstractGadget;
//	NoNativeReplication;

var R6TacticalGlowLight m_GlowLight;

simulated event Destroyed ()
{
	Super.Destroyed();
	if ( m_GlowLight != None )
	{
		m_GlowLight.Destroy();
		m_GlowLight=None;
	}
}

function ActivateGadget (bool bActivate, optional bool bControllerInBehindView)
{
	local Vector vTagLocation;
	local Rotator rTagRotator;
	local Vector vGlowLightLocation;
	local Rotator rGlowLightRotator;

	if ( bActivate == True )
	{
		if ( (bControllerInBehindView == True) || (Level.NetMode != 0) )
		{
			if ( m_GlowLight == None )
			{
				m_GlowLight=Spawn(Class'R6TacticalGlowLight');
				m_GlowLight.SetOwner(m_WeaponOwner);
			}
			m_WeaponOwner.GetTagInformations("TagGadget",vTagLocation,rTagRotator,m_OwnerCharacter.m_fAttachFactor);
			m_GlowLight.SetBase(None);
			m_GlowLight.SetBase(m_WeaponOwner,m_WeaponOwner.Location);
			m_GlowLight.SetRelativeLocation(vTagLocation + vGlowLightLocation);
			m_GlowLight.SetRelativeRotation(rTagRotator + rGlowLightRotator);
		}
	}
	else
	{
		if ( m_GlowLight != None )
		{
			m_GlowLight.SetBase(None);
			m_GlowLight.Destroy();
			m_GlowLight=None;
		}
	}
}

simulated function UpdateAttachment (R6EngineWeapon weapOwner)
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	Super.UpdateAttachment(weapOwner);
	SetBase(None);
	SetBase(weapOwner,weapOwner.Location);
	weapOwner.GetTagInformations("TagGadget",vTagLocation,rTagRotator);
	SetRelativeLocation(vTagLocation);
	SetRelativeRotation(rTagRotator);
}

defaultproperties
{
    m_eGadgetType=6
    DrawType=8
    m_bDrawFromBase=True
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Gadgets.R63rdTACSubGuns'
*/

