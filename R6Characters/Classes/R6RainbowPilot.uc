//================================================================================
// R6RainbowPilot.
//================================================================================
class R6RainbowPilot extends R6RainbowPawn;

simulated function SetRainbowFaceTexture ()
{
	if ( bIsFemale )
	{
		SetFemaleParameters();
//		Skins[1]=Texture(DynamicLoadObject("R6Characters_t.Rainbow.R6RPilotHeadF",Class'Texture'));
		if ( m_Helmet != None )
		{
			m_Helmet.DrawScale=1.00;
		}
		if ( m_NightVision != None )
		{
			m_NightVision.DrawScale=1.10;
		}
	}
}

simulated function AttachNightVision ()
{
	Super.AttachNightVision();
	m_NightVision.SetRelativeLocation(vect(-1.00,-1.00,0.00));
}

defaultproperties
{
    m_bScaleGasMaskForFemale=False
    m_GasMaskClass=Class'R6Engine.R6PilotGasMask'
    m_HelmetClass=Class'R6RPilotHelmet'
    m_NightVisionClass=Class'R6Engine.R6PilotNightVision'
    m_eArmorType=2
}
/*
    Mesh=SkeletalMesh'R6Rainbow_UKX.PilotMesh'
    KParams=KarmaParamsSkel'KarmaParamsSkel247'
    m_FPHandsTexture=Texture'R61stWeapons_T.Hands.R61stHandsGreen'
    Skins=[0]=Texture'R6Characters_T.Rainbow.R6RPilot'
*/

