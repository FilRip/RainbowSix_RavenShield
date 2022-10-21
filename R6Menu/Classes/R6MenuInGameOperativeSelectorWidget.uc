//================================================================================
// R6MenuInGameOperativeSelectorWidget.
//================================================================================
class R6MenuInGameOperativeSelectorWidget extends R6MenuWidget;

var const int c_OutsideMarginX;
var const int c_OutsideMarginY;
var const int c_InsideMarginX;
var const int c_InsideMarginY;
var const int c_ColumnWidth;
var const int c_RowHeight;
var bool m_bInitalized;
var bool m_bIsSinglePlayer;
var Sound m_OperativeOpenSnd;
var R6GameOptions m_pGameOptions;
var array<R6OperativeSelectorItem> aItems;

function UpdateOperativeItems ()
{
	local R6GameReplicationInfo gameRepInfo;
	local int iOperative;
	local int iOperativeCount;
	local int iOperativePos;
	local int iPosX;
	local int iPosY;
	local int iTeam;
	local R6RainbowTeam MPTeam;
	local R6TeamMemberReplicationInfo pTeamMemberRepInfo;
	local R6Rainbow P;

	gameRepInfo=R6GameReplicationInfo(GetPlayerOwner().GameReplicationInfo);
	iOperativePos=0;
	m_bIsSinglePlayer=gameRepInfo.Level.NetMode == NM_Standalone;
	if ( m_bIsSinglePlayer )
	{
		iTeam=0;
JL0057:
		if ( iTeam < 3 )
		{
			iPosX=c_OutsideMarginX + c_InsideMarginX + iTeam * (c_InsideMarginX + c_ColumnWidth);
			if ( gameRepInfo.m_RainbowTeam[iTeam] != None )
			{
				iOperativeCount=gameRepInfo.m_RainbowTeam[iTeam].m_iMembersLost + gameRepInfo.m_RainbowTeam[iTeam].m_iMemberCount;
				iOperative=0;
JL00ED:
				if ( iOperative < iOperativeCount )
				{
					iPosY=c_OutsideMarginY + c_InsideMarginY + iOperative * (c_InsideMarginY + c_RowHeight);
					if (  !m_bInitalized )
					{
						aItems[iOperativePos]=R6OperativeSelectorItem(CreateWindow(Class'R6OperativeSelectorItem',iPosX,iPosY,c_ColumnWidth,c_RowHeight));
					}
					aItems[iOperativePos].SetCharacterInfo(gameRepInfo.m_RainbowTeam[iTeam].m_Team[iOperative]);
					aItems[iOperativePos].m_DarkColor=Root.Colors.TeamColorDark[iTeam];
					aItems[iOperativePos].m_NormalColor=Root.Colors.TeamColor[iTeam];
					iOperativePos++;
					iOperative++;
					goto JL00ED;
				}
			}
			iTeam++;
			goto JL0057;
		}
	}
	else
	{
		m_pGameOptions=Class'Actor'.static.GetGameOptions();
		P=R6Rainbow(GetPlayerOwner().Pawn);
		iPosX=c_OutsideMarginX + c_InsideMarginX + c_InsideMarginX + c_ColumnWidth;
		iOperative=0;
JL0273:
		if ( iOperative < 4 )
		{
			if (  !m_bInitalized )
			{
				iPosY=c_OutsideMarginY + c_InsideMarginY + iOperative * (c_InsideMarginY + c_RowHeight);
				aItems[iOperative]=R6OperativeSelectorItem(CreateWindow(Class'R6OperativeSelectorItem',iPosX,iPosY,c_ColumnWidth,c_RowHeight));
			}
			aItems[iOperative].HideWindow();
			iOperative++;
			goto JL0273;
		}
		foreach P.AllActors(Class'R6TeamMemberReplicationInfo',pTeamMemberRepInfo)
		{
			if ( P.m_TeamMemberRepInfo.m_iTeamId == pTeamMemberRepInfo.m_iTeamId )
			{
				aItems[pTeamMemberRepInfo.m_iTeamPosition].SetCharacterInfoMP(pTeamMemberRepInfo);
				aItems[pTeamMemberRepInfo.m_iTeamPosition].m_DarkColor=m_pGameOptions.HUDMPDarkColor;
				aItems[pTeamMemberRepInfo.m_iTeamPosition].m_NormalColor=m_pGameOptions.HUDMPColor;
				aItems[pTeamMemberRepInfo.m_iTeamPosition].ShowWindow();
			}
		}
	}
	m_bInitalized=True;
}

function ShowWindow ()
{
	Super.ShowWindow();
	UpdateOperativeItems();
//	GetPlayerOwner().PlaySound(m_OperativeOpenSnd,9);
}

function HideWindow ()
{
	local int iOperativePos;

	Super.HideWindow();
	iOperativePos=0;
JL000D:
	if ( iOperativePos < aItems.Length )
	{
		aItems[iOperativePos].m_Operative=None;
		aItems[iOperativePos].m_MemberRepInfo=None;
		iOperativePos++;
		goto JL000D;
	}
}

function Paint (Canvas C, float X, float Y)
{
	local int iOperative;
	local int iTeam;
	local int iPosX;
	local int iPosY;
	local string szTeam;
	local float fTeamPosX;
	local float fTeamPosY;
	local R6Rainbow P;
	local R6TeamMemberReplicationInfo pTeamMemberRepInfo;

	if ( m_bIsSinglePlayer )
	{
		iTeam=0;
JL0010:
		if ( iTeam < 3 )
		{
			C.Style=5;
			iPosX=c_OutsideMarginX + c_InsideMarginX + iTeam * (c_InsideMarginX + c_ColumnWidth);
			iPosY=63 + c_InsideMarginY;
			C.DrawColor=Root.Colors.TeamColor[iTeam];
			C.DrawColor.A=51;
//			DrawStretchedTextureSegment(C,iPosX + 1,iPosY + 1,c_ColumnWidth - 2,18.00,0.00,0.00,1.00,1.00,Texture'White');
			C.DrawColor.A=255;
			C.SetPos(iPosX + c_ColumnWidth / 2,iPosY + 2);
			switch (iTeam)
			{
				case 0:
				szTeam=Caps(Localize("COLOR","ID_RED","R6COMMON"));
				break;
				case 1:
				szTeam=Caps(Localize("COLOR","ID_GREEN","R6COMMON"));
				break;
				case 2:
				szTeam=Caps(Localize("COLOR","ID_GOLD","R6COMMON"));
				break;
				default:
			}
			TextSize(C,szTeam,fTeamPosX,fTeamPosY);
			C.SetPos(iPosX + (c_ColumnWidth - fTeamPosX) / 2,iPosY + 1);
			C.DrawText(szTeam);
/*			DrawStretchedTextureSegment(C,iPosX,iPosY,c_ColumnWidth,1.00,0.00,0.00,1.00,1.00,Texture'White');
			DrawStretchedTextureSegment(C,iPosX,iPosY + 17 - 1,c_ColumnWidth,1.00,0.00,0.00,1.00,1.00,Texture'White');
			DrawStretchedTextureSegment(C,iPosX,iPosY,1.00,17.00,0.00,0.00,1.00,1.00,Texture'White');
			DrawStretchedTextureSegment(C,iPosX + c_ColumnWidth - 1,iPosY,1.00,17.00,0.00,0.00,1.00,1.00,Texture'White');*/
			iOperative=0;
JL0331:
			if ( iOperative < aItems.Length )
			{
				aItems[iOperative].UpdatePosition();
				iOperative++;
				goto JL0331;
			}
			iTeam++;
			goto JL0010;
		}
	}
	else
	{
		C.Style=5;
		iPosX=c_OutsideMarginX + c_InsideMarginX + c_InsideMarginX + c_ColumnWidth;
		iPosY=63 + c_InsideMarginY;
		C.DrawColor=m_pGameOptions.HUDMPColor;
		C.DrawColor.A=51;
//		DrawStretchedTextureSegment(C,iPosX + 1,iPosY + 1,c_ColumnWidth - 2,18.00,0.00,0.00,1.00,1.00,Texture'White');
		C.DrawColor.A=255;
		C.SetPos(iPosX + c_ColumnWidth / 2,iPosY + 2);
		szTeam=Caps(Localize("MISC","Team","R6Menu"));
		TextSize(C,szTeam,fTeamPosX,fTeamPosY);
		C.SetPos(iPosX + (c_ColumnWidth - fTeamPosX) / 2,iPosY + 1);
		C.DrawText(szTeam);
/*		DrawStretchedTextureSegment(C,iPosX,iPosY,c_ColumnWidth,1.00,0.00,0.00,1.00,1.00,Texture'White');
		DrawStretchedTextureSegment(C,iPosX,iPosY + 17 - 1,c_ColumnWidth,1.00,0.00,0.00,1.00,1.00,Texture'White');
		DrawStretchedTextureSegment(C,iPosX,iPosY,1.00,17.00,0.00,0.00,1.00,1.00,Texture'White');
		DrawStretchedTextureSegment(C,iPosX + c_ColumnWidth - 1,iPosY,1.00,17.00,0.00,0.00,1.00,1.00,Texture'White');*/
		iOperative=0;
JL05F6:
		if ( iOperative < aItems.Length )
		{
			aItems[iOperative].UpdatePositionMP();
			iOperative++;
			goto JL05F6;
		}
	}
}

defaultproperties
{
    c_OutsideMarginX=19
    c_OutsideMarginY=83
    c_InsideMarginX=2
    c_InsideMarginY=3
    c_ColumnWidth=198
    c_RowHeight=89
}
/*
    m_OperativeOpenSnd=Sound'SFX_Menus.Play_Rose_Open'
*/

