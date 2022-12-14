//================================================================================
// R6THeadAttachment.
//================================================================================
class R6THeadAttachment extends StaticMeshActor;

enum EHeadAttachmentType {
	ATTACH_Glasses,
	ATTACH_Sunglasses,
	ATTACH_GasMask,
	ATTACH_None
};

enum ETerroristType {
	TTYPE_B1T1,
	TTYPE_B1T3,
	TTYPE_B2T2,
	TTYPE_B2T4,
	TTYPE_M1T1,
	TTYPE_M1T3,
	TTYPE_M2T2,
	TTYPE_M2T4,
	TTYPE_P1T1,
	TTYPE_P2T2,
	TTYPE_P3T3,
	TTYPE_P1T4,
	TTYPE_P2T5,
	TTYPE_P3T6,
	TTYPE_P1T7,
	TTYPE_P2T8,
	TTYPE_P3T9,
	TTYPE_P1T10,
	TTYPE_P2T11,
	TTYPE_P3T12,
	TTYPE_P4T13,
	TTYPE_D1T1,
	TTYPE_D1T2,
	TTYPE_GOSP,
	TTYPE_GUTI,
	TTYPE_S1T1,
	TTYPE_S1T2,
	TTYPE_TXIC,
	TTYPE_T1T1,
	TTYPE_T2T2,
	TTYPE_T1T3,
	TTYPE_T2T4
};

function bool SetAttachmentStaticMesh (EHeadAttachmentType eAttType, ETerroristType eTerro)
{
	local int iNbChoice;
	local string aMesh[10];
	local StaticMesh sm;

	switch (eTerro)
	{
		case TTYPE_B1T1:
		case TTYPE_B1T3:
		switch (eAttType)
		{
			case ATTACH_Glasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM06B1T1Glasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM09B1T1Glasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM10B1T1Glasses";
			iNbChoice=3;
			break;
			case ATTACH_Sunglasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM06B1T1SGlasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM09B1T1SGlasses";
			iNbChoice=2;
			break;
			case ATTACH_GasMask:
			iNbChoice=0;
			break;
			default:
		}
		break;
		case TTYPE_B2T2:
		case TTYPE_B2T4:
		switch (eAttType)
		{
			case ATTACH_Glasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM01B2T2Glasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM06B2T2Glasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM09B2T2Glasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM10B2T2Glasses";
			iNbChoice=4;
			break;
			case ATTACH_Sunglasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM06B2T2SGlasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM09B2T2SGlasses";
			iNbChoice=2;
			break;
			ATTACH_GasMask:
			iNbChoice=0;
			break;
			default:
		}
		break;
		case TTYPE_M1T1:
		switch (eAttType)
		{
			case ATTACH_Glasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM01M1T1Glasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM02M1T1Glasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM03M1T1Glasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM05M1T1Glasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM07M1T1Glasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM08M1T1Glasses";
			aMesh[6]="R6THeadAttachment_SM.R6TM09M1T1Glasses";
			aMesh[7]="R6THeadAttachment_SM.R6TM11M1T1Glasses";
			aMesh[8]="R6THeadAttachment_SM.R6TM13M1T1Glasses";
			aMesh[9]="R6THeadAttachment_SM.R6TM14M1T1Glasses";
			iNbChoice=10;
			break;
			case ATTACH_Sunglasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM05M1T1SGlasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM08M1T1SGlasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM09M1T1SGlasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM13M1T1SGlasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM14M1T1SGlasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM15M1T1SGlasses";
			iNbChoice=6;
			break;
			case ATTACH_GasMask:
			aMesh[0]="R6THeadAttachment_SM.R6TM11M1T1GMask";
			aMesh[1]="R6THeadAttachment_SM.R6TM13M1T1GMask";
			aMesh[2]="R6THeadAttachment_SM.R6TM15M1T1GMask";
			iNbChoice=3;
			break;
			default:
		}
		break;
		case TTYPE_M1T3:
		switch (eAttType)
		{
			case ATTACH_Glasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM01M1T3Glasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM02M1T3Glasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM03M1T3Glasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM05M1T3Glasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM07M1T3Glasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM08M1T3Glasses";
			aMesh[6]="R6THeadAttachment_SM.R6TM09M1T3Glasses";
			aMesh[7]="R6THeadAttachment_SM.R6TM11M1T3Glasses";
			aMesh[8]="R6THeadAttachment_SM.R6TM13M1T3Glasses";
			aMesh[9]="R6THeadAttachment_SM.R6TM14M1T3Glasses";
			iNbChoice=10;
			break;
			case ATTACH_Sunglasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM05M1T3SGlasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM08M1T3SGlasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM09M1T3SGlasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM13M1T3SGlasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM14M1T3SGlasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM15M1T3SGlasses";
			iNbChoice=6;
			break;
			case ATTACH_GasMask:
			aMesh[0]="R6THeadAttachment_SM.R6TM11M1T3GMask";
			aMesh[1]="R6THeadAttachment_SM.R6TM13M1T3GMask";
			aMesh[2]="R6THeadAttachment_SM.R6TM15M1T3GMask";
			iNbChoice=3;
			break;
			default:
		}
		break;
		case TTYPE_M2T2:
		switch (eAttType)
		{
			case ATTACH_Glasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM01M2T2Glasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM02M2T2Glasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM03M2T2Glasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM05M2T2Glasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM07M2T2Glasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM08M2T2Glasses";
			aMesh[6]="R6THeadAttachment_SM.R6TM09M2T2Glasses";
			aMesh[7]="R6THeadAttachment_SM.R6TM11M2T2Glasses";
			aMesh[8]="R6THeadAttachment_SM.R6TM13M2T2Glasses";
			aMesh[9]="R6THeadAttachment_SM.R6TM14M2T2Glasses";
			iNbChoice=10;
			break;
			case ATTACH_Sunglasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM05M2T2SGlasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM08M2T2SGlasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM09M2T2SGlasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM13M2T2SGlasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM14M2T2SGlasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM15M2T2SGlasses";
			iNbChoice=6;
			break;
			case ATTACH_GasMask:
			aMesh[0]="R6THeadAttachment_SM.R6TM11M2T2GMask";
			aMesh[1]="R6THeadAttachment_SM.R6TM13M2T2GMask";
			aMesh[2]="R6THeadAttachment_SM.R6TM15M2T2GMask";
			iNbChoice=3;
			break;
			default:
		}
		break;
		case TTYPE_M2T4:
		switch (eAttType)
		{
			case ATTACH_Glasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM01M2T4Glasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM02M2T4Glasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM03M2T4Glasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM05M2T4Glasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM07M2T4Glasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM08M2T4Glasses";
			aMesh[6]="R6THeadAttachment_SM.R6TM09M2T4Glasses";
			aMesh[7]="R6THeadAttachment_SM.R6TM11M2T4Glasses";
			aMesh[8]="R6THeadAttachment_SM.R6TM13M2T4Glasses";
			aMesh[9]="R6THeadAttachment_SM.R6TM14M2T4Glasses";
			iNbChoice=10;
			break;
			case ATTACH_Sunglasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM05M2T4SGlasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM08M2T4SGlasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM09M2T4SGlasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM13M2T4SGlasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM14M2T4SGlasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM15M2T4SGlasses";
			iNbChoice=6;
			break;
			case ATTACH_GasMask:
			aMesh[0]="R6THeadAttachment_SM.R6TM11M2T4GMask";
			aMesh[1]="R6THeadAttachment_SM.R6TM13M2T4GMask";
			aMesh[2]="R6THeadAttachment_SM.R6TM15M2T4GMask";
			iNbChoice=3;
			break;
			default:
		}
		break;
		case TTYPE_P1T1:
		case TTYPE_P1T4:
		case TTYPE_P1T7:
		case TTYPE_P1T10:
		switch (eAttType)
		{
			case ATTACH_Glasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM02P1T1Glasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM03P1T1Glasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM04P1T1Glasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM06P1T1Glasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM07P1T1Glasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM08P1T1Glasses";
			aMesh[6]="R6THeadAttachment_SM.R6TM10P1T1Glasses";
			aMesh[7]="R6THeadAttachment_SM.R6TM11P1T1Glasses";
			aMesh[8]="R6THeadAttachment_SM.R6TM13P1T1Glasses";
			aMesh[9]="R6THeadAttachment_SM.R6TM15P1T1Glasses";
			iNbChoice=10;
			break;
			case ATTACH_Sunglasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM06P1T1SGlasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM08P1T1SGlasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM13P1T1SGlasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM15P1T1SGlasses";
			iNbChoice=4;
			break;
			case ATTACH_GasMask:
			aMesh[0]="R6THeadAttachment_SM.R6TM11P1T1GMask";
			aMesh[1]="R6THeadAttachment_SM.R6TM13P1T1GMask";
			aMesh[2]="R6THeadAttachment_SM.R6TM15P1T1GMask";
			iNbChoice=3;
			break;
			default:
		}
		break;
		case TTYPE_P2T2:
		case TTYPE_P2T5:
		case TTYPE_P2T8:
		case TTYPE_P2T11:
		switch (eAttType)
		{
			case ATTACH_Glasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM02P2T2Glasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM03P2T2Glasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM04P2T2Glasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM06P2T2Glasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM07P2T2Glasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM08P2T2Glasses";
			aMesh[6]="R6THeadAttachment_SM.R6TM10P2T2Glasses";
			aMesh[7]="R6THeadAttachment_SM.R6TM11P2T2Glasses";
			aMesh[8]="R6THeadAttachment_SM.R6TM13P2T2Glasses";
			aMesh[9]="R6THeadAttachment_SM.R6TM15P2T2Glasses";
			iNbChoice=10;
			break;
			case ATTACH_Sunglasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM06P2T2SGlasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM08P2T2SGlasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM13P2T2SGlasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM15P2T2SGlasses";
			iNbChoice=4;
			break;
			case ATTACH_GasMask:
			aMesh[0]="R6THeadAttachment_SM.R6TM11P2T2GMask";
			aMesh[1]="R6THeadAttachment_SM.R6TM13P2T2GMask";
			aMesh[2]="R6THeadAttachment_SM.R6TM15P2T2GMask";
			iNbChoice=3;
			break;
			default:
		}
		break;
		case TTYPE_P3T3:
		case TTYPE_P3T6:
		case TTYPE_P3T9:
		case TTYPE_P3T12:
		switch (eAttType)
		{
			case ATTACH_Glasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM02P3T3Glasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM03P3T3Glasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM04P3T3Glasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM06P3T3Glasses";
			aMesh[4]="R6THeadAttachment_SM.R6TM07P3T3Glasses";
			aMesh[5]="R6THeadAttachment_SM.R6TM08P3T3Glasses";
			aMesh[6]="R6THeadAttachment_SM.R6TM10P3T3Glasses";
			aMesh[7]="R6THeadAttachment_SM.R6TM13P3T3Glasses";
			aMesh[8]="R6THeadAttachment_SM.R6TM15P3T3Glasses";
			iNbChoice=9;
			break;
			case ATTACH_Sunglasses:
			aMesh[0]="R6THeadAttachment_SM.R6TM06P3T3SGlasses";
			aMesh[1]="R6THeadAttachment_SM.R6TM08P3T3SGlasses";
			aMesh[2]="R6THeadAttachment_SM.R6TM13P3T3SGlasses";
			aMesh[3]="R6THeadAttachment_SM.R6TM15P3T3SGlasses";
			iNbChoice=4;
			break;
			case ATTACH_GasMask:
			aMesh[0]="R6THeadAttachment_SM.R6TM11P3T3GMask";
			aMesh[1]="R6THeadAttachment_SM.R6TM13P3T3GMask";
			aMesh[2]="R6THeadAttachment_SM.R6TM15P3T3GMask";
			iNbChoice=3;
			break;
			default:
		}
		break;
		default:
	}
	if ( iNbChoice > 0 )
	{
		sm=StaticMesh(DynamicLoadObject(aMesh[Rand(iNbChoice)],Class'StaticMesh'));
		SetStaticMesh(sm);
		return True;
	}
	else
	{
		return False;
	}
}

defaultproperties
{
    SkinsIndex=0
    RemoteRole=ROLE_SimulatedProxy
    bStatic=False
    bWorldGeometry=False
    bShadowCast=False
    bCollideActors=False
    bBlockActors=False
    bBlockPlayers=False
    bEdShouldSnap=False
    DrawScale3D=(X=-1.00,Y=-1.00,Z=1.00)
}
