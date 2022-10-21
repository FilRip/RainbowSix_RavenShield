//================================================================================
// R6MuzzleGadget.
//================================================================================
class R6MuzzleGadget extends R6AbstractGadget;
//	NoNativeReplication;

var Actor m_FPMuzzelModel;
var(R6Attachment) Class<Actor> m_pFPMuzzleClass;

replication
{
	reliable if ( bNetOwner && (Role == Role_Authority) )
		m_FPMuzzelModel;
}

simulated event Destroyed ()
{
	Super.Destroyed();
	DestroyFPGadget();
}

simulated function UpdateAttachment (R6EngineWeapon weapOwner)
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	Super.UpdateAttachment(weapOwner);
	SetBase(None);
	SetBase(weapOwner,weapOwner.Location);
	weapOwner.GetTagInformations("TagMuzzle",vTagLocation,rTagRotator);
	SetRelativeLocation(vTagLocation);
	SetRelativeRotation(rTagRotator);
}

simulated function AttachFPGadget ()
{
	if ( (m_WeaponOwner == None) || (R6AbstractWeapon(m_WeaponOwner).m_FPWeapon == None) )
	{
		return;
	}
	if ( m_FPMuzzelModel == None )
	{
		if ( m_pFPMuzzleClass != None )
		{
			m_FPMuzzelModel=Spawn(m_pFPMuzzleClass);
		}
	}
	if ( m_FPMuzzelModel != None )
	{
		R6AbstractWeapon(m_WeaponOwner).m_FPWeapon.AttachToBone(m_FPMuzzelModel,'TagMuzzle');
	}
}

simulated function DestroyFPGadget ()
{
	local Actor temp;

	if ( m_FPMuzzelModel != None )
	{
		temp=m_FPMuzzelModel;
		m_FPMuzzelModel=None;
		temp.Destroy();
	}
}

defaultproperties
{
    m_eGadgetType=4
    m_NameID="Muzzle"
    m_bDrawFromBase=True
}
