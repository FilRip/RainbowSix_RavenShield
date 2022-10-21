//================================================================================
// R6IODevice.
//================================================================================
class R6IODevice extends R6IOObject;

var(Debug) bool bShowLog;
var(R6ActionObject) float m_fPlantTimeMin;
var(R6ActionObject) float m_fPlantTimeMax;
var(R6ActionObject) Texture m_InteractionIcon;
var Sound m_PhoneBuggingSnd;
var Sound m_PhoneBuggingStopSnd;
var(R6ActionObject) array<Material> m_ArmedTextures;
var Vector m_vOffset;

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( Role == Role_Authority )
	{
		if ( (m_eAnimToPlay == 4) || (m_eAnimToPlay == 3) )
		{
			AddSoundBankName("SFX_Penthouse_Single");
			if ( m_eAnimToPlay == 3 )
			{
				m_StartSnd=m_PhoneBuggingSnd;
				m_InterruptedSnd=m_PhoneBuggingStopSnd;
				m_CompletedSnd=m_PhoneBuggingStopSnd;
			}
		}
	}
}

simulated event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	local bool bDisplayBombIcon;
	local Vector vActorDir;
	local Vector vFacingDir;

	if ( (CanToggle() == False) ||  !m_bRainbowCanInteract )
	{
		return;
	}
	if ( m_bIsActivated )
	{
		Query.iHasAction=1;
	}
	else
	{
		Query.iHasAction=0;
		return;
	}
	Query.textureIcon=m_InteractionIcon;
	Query.iPlayerActionID=3;
	Query.iTeamActionID=3;
	Query.iTeamActionIDList[0]=3;
	Query.iTeamActionIDList[1]=0;
	Query.iTeamActionIDList[2]=0;
	Query.iTeamActionIDList[3]=0;
	if ( fDistance < m_fCircumstantialActionRange )
	{
		vFacingDir=vector(Rotation);
		vFacingDir.Z=0.00;
		vActorDir=Normal(Location - PlayerController.Pawn.Location);
		vActorDir.Z=0.00;
		if ( vActorDir Dot vFacingDir > 0.85 )
		{
			Query.iInRange=1;
		}
		else
		{
			Query.iInRange=0;
		}
	}
	else
	{
		Query.iInRange=0;
	}
	Query.bCanBeInterrupted=True;
	Query.fPlayerActionTimeRequired=GetTimeRequired(R6PlayerController(PlayerController).m_pawn);
}

simulated function string R6GetCircumstantialActionString (int iAction)
{
	switch (iAction)
	{
		case 3:
		switch (m_eAnimToPlay)
		{
/*			case 4:
			return Localize("RDVOrder","Order_Computer","R6Menu");
			case 2:
			return Localize("RDVOrder","Order_KeyPad","R6Menu");
			case 3:
			return Localize("RDVOrder","Order_PlantDevice","R6Menu");
			default:*/
		}
		return "";
		default:
	}
	return "";
}

simulated function ToggleDevice (R6Pawn aPawn)
{
	local int iSkinCount;

	if ( CanToggle() == False )
	{
		return;
	}
	Super.ToggleDevice(aPawn);
	if ( bShowLog )
	{
		Log("Set Device" @ string(self) @ "by pawn" @ string(aPawn) @ "and his controller" @ string(aPawn.Controller));
	}
	m_bIsActivated=False;
	for (iSkinCount=0;iSkinCount < m_ArmedTextures.Length;iSkinCount++)
	{
		SetSkin(m_ArmedTextures[iSkinCount],iSkinCount);
	}
	R6AbstractGameInfo(Level.Game).IObjectInteract(aPawn,self);
}

simulated function bool HasKit (R6Pawn aPawn)
{
	return R6Rainbow(aPawn).m_bHasElectronicsKit;
}

simulated function float GetMaxTimeRequired ()
{
	return m_fPlantTimeMax;
}

simulated function float GetTimeRequired (R6Pawn aPawn)
{
	local float fPlantingTime;

	if ( bShowLog )
	{
		Log("GetTimeRequired" @ string(m_fPlantTimeMin) @ string(aPawn) @ string(aPawn.GetSkill(SKILL_Electronics)));
	}
	fPlantingTime=m_fPlantTimeMin + (1 - aPawn.GetSkill(SKILL_Electronics)) * (m_fPlantTimeMax - m_fPlantTimeMin);
	if ( HasKit(aPawn) && (fPlantingTime - m_fGainTimeWithElectronicsKit > 0) )
	{
		fPlantingTime -= m_fGainTimeWithElectronicsKit;
	}
	return fPlantingTime;
}

defaultproperties
{
    m_fPlantTimeMin=4.00
    m_fPlantTimeMax=12.00
    m_bIsActivated=True
}
/*
    m_InteractionIcon=Texture'R6ActionIcons.InteractiveDevice'
    m_PhoneBuggingSnd=Sound'SFX_Penthouse_Single.Play_PhoneBugging'
    m_PhoneBuggingStopSnd=Sound'SFX_Penthouse_Single.Stop_PhoneBugging_Go'
    m_StartSnd=Sound'SFX_Penthouse_Single.Play_seq_random_CompType'
    m_InterruptedSnd=Sound'SFX_Penthouse_Single.Stop_seq_random_CompType_Go'
    m_CompletedSnd=Sound'SFX_Penthouse_Single.Stop_seq_random_CompType_Go'
*/
