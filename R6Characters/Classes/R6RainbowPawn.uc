//================================================================================
// R6RainbowPawn.
//================================================================================
class R6RainbowPawn extends R6Rainbow
	Abstract;

var Texture m_FPHandsTexture;

simulated event PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'RainbowAnim');
	Super.PostBeginPlay();
}

simulated event PostNetBeginPlay ()
{
	Super.PostNetBeginPlay();
}

simulated function SetFemaleParameters ()
{
	SetPawnScale(0.95);
	m_fAttachFactor=0.95;
	m_fPrePivotPawnInitialOffset=-4.00;
	if ( Level.NetMode != 3 )
	{
		PrePivot.Z += m_fPrePivotPawnInitialOffset;
	}
}

simulated function SetRainbowFaceTexture ()
{
	local int iFaceIndex;
	local string aFaceTexture;
	local Texture aTexture;

	if ( bShowLog )
	{
		Log(string(self) $ " SetRainbowFaceTexture() : bIsFemale =" $ string(bIsFemale) $ " m_iOperativeID=" $ string(m_iOperativeID));
	}
	iFaceIndex=3;
	if ( bIsFemale )
	{
		SetFemaleParameters();
		if ( m_Helmet != None )
		{
			m_Helmet.DrawScale=1.00;
		}
		if ( m_NightVision != None )
		{
			m_NightVision.DrawScale=1.00;
		}
	}
	switch (m_iOperativeID)
	{
		case 0:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceArnavisca";
		break;
		case 1:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceBeckenbauer";
		break;
		case 2:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceBogart";
		break;
		case 3:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceBurke";
		break;
		case 4:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceChaves";
		break;
		case 5:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceDuBarry";
		break;
		case 6:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceFilatov";
		break;
		case 7:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceGalanos";
		break;
		case 8:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceHaider";
		break;
		case 9:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceHanley";
		break;
		case 10:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceHomer";
		break;
		case 11:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceLofquist";
		break;
		case 12:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceLoiselle";
		break;
		case 13:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceMaldini";
		break;
		case 14:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceMcAllen";
		break;
		case 15:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceMorris";
		break;
		case 16:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceMurad";
		break;
		case 17:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceNarino";
		break;
		case 18:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceNoronha";
		break;
		case 19:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceNovikov";
		break;
		case 20:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceSuo_Won";
		break;
		case 21:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFacePetersen";
		break;
		case 22:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFacePrice";
		break;
		case 23:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceRakuzanka";
		break;
		case 24:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceRaymond";
		break;
		case 25:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceWalter";
		break;
		case 26:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceWeber";
		break;
		case 27:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceWoo";
		break;
		case 28:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceYakoby";
		break;
		default:
		aFaceTexture="R6Characters_t.RainbowFaces.R6RFaceReserve";
	}
	if ( aFaceTexture != "" )
	{
		Skins[iFaceIndex]=Texture(DynamicLoadObject(aFaceTexture,Class'Texture'));
	}
}

defaultproperties
{
    m_FOVClass=Class'R6FieldOfView'
}
/*
    m_FPHandsTexture=Texture'R61stWeapons_T.Hands.R61stHands'
    KParams=KarmaParamsSkel'KarmaParamsSkel213'
*/

