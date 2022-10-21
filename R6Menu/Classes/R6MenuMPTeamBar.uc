//================================================================================
// R6MenuMPTeamBar.
//================================================================================
class R6MenuMPTeamBar extends UWindowWindow;

struct PlayerMenuInfo
{
	var string szPlayerName;
	var string szKilledBy;
	var int iKills;
	var int iEfficiency;
	var int iRoundsFired;
	var int iRoundsHit;
	var int iPingTime;
	var int iHealth;
	var int iTeamSelection;
	var int iRoundsPlayed;
	var int iRoundsWon;
	var int iDeathCount;
	var bool bOwnPlayer;
	var bool bSpectator;
	var bool bPlayerReady;
	var bool bJoinedTeamLate;
};

struct stCoord
{
	var float fXPos;
	var float fWidth;
};

enum eIconType {
	IT_Ready,
	IT_Health,
	IT_RoundsWon,
	IT_Kill,
	IT_DeadCounter,
	IT_Efficiency,
	IT_RoundFired,
	IT_RoundTaken,
	IT_KillerName,
	IT_Ping
};

enum eMenuLayout {
	eML_Ready,
	eML_HealthStatus,
	eML_Name,
	eML_RoundsWon,
	eML_Kill,
	eML_DeadCounter,
	eML_Efficiency,
	eML_RoundFired,
	eML_RoundHit,
	eML_KillerName,
	eML_PingTime
};

var int m_iIndex[9];
var int m_iTotalKills;
var int m_iTotalNbOfDead;
var int m_iTotalEfficiency;
var int m_iTotalRoundsFired;
var int m_iTotalRoundsTaken;
var int m_iTotalRoomTake;
var bool m_bTeamMenuLayout;
var bool m_bDisplayObj;
var Texture m_TIcon;
var R6WindowTextLabelExt m_pTextTeamBar;
var R6WindowIGPlayerInfoListBox m_IGPlayerInfoListBox;
var R6WindowTextLabel m_pTitleCoop;
var R6MenuMPInGameObj m_pMissionObj;
var Color m_vTeamColor;
var stCoord m_stMenuCoord[11];
var string m_szTeamName;
const C_iPLAYER_MAX= 16;
const C_iTOTAL_TEAM_STATUS= 8;
const C_iTOT_ROUND_TAKEN= 7;
const C_iROUND_FIRED= 6;
const C_iPERCENT_EFFICIENT= 5;
const C_iNUMBER_OF_MYDEAD= 4;
const C_iNUMBER_OF_KILLS= 3;
const C_iROUNDSWON= 2;
const C_iTEAM_NAME= 1;
const C_iREADY= 0;
const C_iMISSION_TITLE_H= 20;
const C_fTEAMBAR_TOT_HEIGHT= 12;
const C_fTEAMBAR_ICON_HEIGHT= 15;

function Paint (Canvas C, float X, float Y)
{
	C.Style=5;
	if (  !m_bDisplayObj )
	{
		if ( m_vTeamColor==Root.Colors.TeamColorLight[0] )
		{
			DrawSimpleBackGround(C,2.00,0.00,WinWidth - 4,WinHeight,Root.Colors.TeamColorDark[0]);
		}
		else
		{
			DrawSimpleBackGround(C,2.00,0.00,WinWidth - 4,WinHeight,Root.Colors.TeamColorDark[1]);
		}
		C.SetDrawColor(m_vTeamColor.R,m_vTeamColor.G,m_vTeamColor.B);
		DrawInGameTeamBar(C,0.00,15.00);
		DrawInGameTeamBarUpBorder(C,2.00,0.00,WinWidth - 4,15.00);
		DrawInGameTeamBarDownBorder(C,2.00,WinHeight - 12,WinWidth - 4,12.00);
	}
}

function SetWindowSize (float _fX, float _fY, float _fW, float _fH)
{
	local float fOldTop;
	local float fOldLeft;

	fOldTop=WinTop;
	fOldLeft=WinLeft;
	WinTop=_fY;
	WinLeft=_fX;
	WinWidth=_fW;
	WinHeight=_fH;
	if ( m_bDisplayObj )
	{
		if ( m_pTitleCoop != None )
		{
			m_pTitleCoop.WinTop=0.00;
			m_pTitleCoop.WinWidth=_fW;
			m_pTitleCoop.WinHeight=20.00;
		}
		if ( m_pMissionObj != None )
		{
			m_pMissionObj.WinTop=20.00;
			m_pMissionObj.WinWidth=_fW;
			m_pMissionObj.WinHeight=_fH - 20;
			m_pMissionObj.SetNewObjWindowSizes(_fX,_fY,_fW,_fH,True);
			m_pMissionObj.UpdateObjectives();
		}
	}
	if ( m_pTextTeamBar != None )
	{
		m_pTextTeamBar.WinTop=0.00;
		m_pTextTeamBar.WinWidth=_fW;
		m_pTextTeamBar.WinHeight=_fH;
		Refresh();
	}
	if ( m_IGPlayerInfoListBox != None )
	{
		m_IGPlayerInfoListBox.WinTop=15.00;
		m_IGPlayerInfoListBox.WinWidth=_fW;
		m_IGPlayerInfoListBox.WinHeight=_fH - GetPlayerListBorderHeight();
	}
}

function RefreshTeamBarInfo (int _iTeam)
{
	local int iTotalOfPlayers;
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
/*	if ( r6Root.m_eCurrentGameType == GetLevel().13 )
	{
		iTotalOfPlayers=16;
	}
	else
	{
		iTotalOfPlayers=8;
	}*/
	m_iTotalKills=0;
	m_iTotalNbOfDead=0;
	m_iTotalEfficiency=0;
	m_iTotalRoundsFired=0;
	m_iTotalRoundsTaken=0;
	m_iTotalRoomTake=0;
	ClearListOfItem();
	AddItems(_iTeam,iTotalOfPlayers);
/*	if ( r6Root.m_eCurrentGameType == GetLevel().13 )
	{
		m_pTextTeamBar.ChangeTextLabel(Localize("MPInGame","PlayersName","R6Menu"),m_iIndex[1]);
		m_pTextTeamBar.ChangeTextLabel("",m_iIndex[8]);
		m_pTextTeamBar.ChangeTextLabel("",m_iIndex[3]);
		m_pTextTeamBar.ChangeTextLabel("",m_iIndex[4]);
		m_pTextTeamBar.ChangeTextLabel("",m_iIndex[5]);
		m_pTextTeamBar.ChangeTextLabel("",m_iIndex[6]);
		m_pTextTeamBar.ChangeTextLabel("",m_iIndex[7]);
	}
	else
	{
		m_pTextTeamBar.ChangeTextLabel(m_szTeamName,m_iIndex[1]);
		m_pTextTeamBar.ChangeTextLabel(Localize("MPInGame","TotalTeamStatus","R6Menu"),m_iIndex[8]);
		m_pTextTeamBar.ChangeTextLabel(string(m_iTotalKills),m_iIndex[3]);
		m_pTextTeamBar.ChangeTextLabel(string(m_iTotalNbOfDead),m_iIndex[4]);
		m_pTextTeamBar.ChangeTextLabel(string(m_iTotalEfficiency),m_iIndex[5]);
		m_pTextTeamBar.ChangeTextLabel(string(m_iTotalRoundsFired),m_iIndex[6]);
		m_pTextTeamBar.ChangeTextLabel(string(m_iTotalRoundsTaken),m_iIndex[7]);
	}*/
}

function Refresh ()
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;

	m_pTextTeamBar.Clear();
	fYOffset=2.00;
	fXOffset=m_stMenuCoord[2].fXPos;
	fWidth=m_stMenuCoord[2].fWidth;
//	m_iIndex[1]=m_pTextTeamBar.AddTextLabel(m_szTeamName,fXOffset,fYOffset,fWidth,0,False);
	fXOffset=4.00;
	fYOffset=WinHeight - 12 + 1;
//	m_iIndex[8]=m_pTextTeamBar.AddTextLabel("",fXOffset,fYOffset,fWidth,0,False);
	fXOffset=m_stMenuCoord[4].fXPos;
	fWidth=m_stMenuCoord[4].fWidth;
//	m_iIndex[3]=m_pTextTeamBar.AddTextLabel("00",fXOffset,fYOffset,fWidth,2,False);
	fXOffset=m_stMenuCoord[5].fXPos;
	fWidth=m_stMenuCoord[5].fWidth;
//	m_iIndex[4]=m_pTextTeamBar.AddTextLabel("00",fXOffset,fYOffset,fWidth,2,False);
	fXOffset=m_stMenuCoord[6].fXPos;
	fWidth=m_stMenuCoord[6].fWidth;
//	m_iIndex[5]=m_pTextTeamBar.AddTextLabel("00",fXOffset,fYOffset,fWidth,2,False);
	fXOffset=m_stMenuCoord[7].fXPos;
	fWidth=m_stMenuCoord[7].fWidth;
//	m_iIndex[6]=m_pTextTeamBar.AddTextLabel("00",fXOffset,fYOffset,fWidth,2,False);
	fXOffset=m_stMenuCoord[8].fXPos;
	fWidth=m_stMenuCoord[8].fWidth;
//	m_iIndex[7]=m_pTextTeamBar.AddTextLabel("00",fXOffset,fYOffset,fWidth,2,False);
}

function AddItems (int _iTeam, int _iTotalOfPlayers)
{
	local R6WindowListIGPlayerInfoItem NewItem;
	local UWindowList CurItem;
	local UWindowList ParseItem;
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local R6WindowIGPlayerInfoListBox pListTemp;
	local int i;
	local int iIndex;
	local int j;
	local bool bAddItem;
	local PlayerMenuInfo _PlayerMenuInfo;
	local R6MenuMPInterWidget MpInter;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	if ( r6Root.m_R6GameMenuCom != None )
	{
		MpInter=R6MenuMPInterWidget(OwnerWindow);
		CurItem=m_IGPlayerInfoListBox.Items.Next;
		i=0;
JL0058:
		if ( i < r6Root.m_R6GameMenuCom.m_iLastValidIndex )
		{
			bAddItem=True;
			iIndex=r6Root.m_R6GameMenuCom.GeTTeamSelection(i);
//			GetLevel().GetFPlayerMenuInfo(i,_PlayerMenuInfo);
			if ( iIndex != _iTeam )
			{
				bAddItem=False;
/*				if ( iIndex == r6Root.m_R6GameMenuCom.4 )
				{
					if ( _iTeam == r6Root.m_R6GameMenuCom.2 )
					{
						if ( m_iTotalRoomTake < _iTotalOfPlayers )
						{
							bAddItem=True;
						}
					}
					else
					{
						if ( MpInter.m_pR6AlphaTeam.m_iTotalRoomTake == _iTotalOfPlayers )
						{
							bAddItem=True;
							pListTemp=MpInter.m_pR6AlphaTeam.m_IGPlayerInfoListBox;
							ParseItem=pListTemp.Items.Next;
							j=0;
JL0196:
							if ( j < _iTotalOfPlayers )
							{
								if ( Left(_PlayerMenuInfo.szPlayerName,15) ~= R6WindowListIGPlayerInfoItem(ParseItem).szPlName )
								{
									bAddItem=False;
								}
								else
								{
									ParseItem=ParseItem.Next;
									j++;
									goto JL0196;
								}
							}
						}
					}
				}*/
			}
			if ( bAddItem )
			{
				NewItem=R6WindowListIGPlayerInfoItem(CurItem);
//				iIndex=NewItem.0;
				NewItem.bReady=_PlayerMenuInfo.bPlayerReady;
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[0].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[0].fWidth;
//				iIndex=NewItem.1;
				if ( _PlayerMenuInfo.bSpectator )
				{
//					NewItem.eStatus=NewItem.4;
				}
				else
				{
					if ( _PlayerMenuInfo.bJoinedTeamLate )
					{
//						NewItem.eStatus=NewItem.5;
					}
					else
					{
						switch (_PlayerMenuInfo.iHealth)
						{
/*							case 0:
							NewItem.eStatus=NewItem.0;
							break;
							case 1:
							NewItem.eStatus=NewItem.1;
							break;
							case 2:
							default:*/
						}
//						NewItem.eStatus=NewItem.3;
						goto JL0369;
					}
				}
JL0369:
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[1].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[1].fWidth;
//				iIndex=NewItem.2;
				NewItem.szPlName=Left(_PlayerMenuInfo.szPlayerName,15);
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[2].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[2].fWidth;
//				iIndex=NewItem.3;
				NewItem.stTagCoord[iIndex].bDisplay= !m_bTeamMenuLayout;
				NewItem.szRoundsWon=string(_PlayerMenuInfo.iRoundsWon) $ "/" $ string(_PlayerMenuInfo.iRoundsPlayed);
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[3].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[3].fWidth;
//				iIndex=NewItem.4;
				NewItem.iKills=_PlayerMenuInfo.iKills;
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[4].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[4].fWidth;
//				iIndex=NewItem.5;
				NewItem.iMyDeadCounter=_PlayerMenuInfo.iDeathCount;
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[5].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[5].fWidth;
//				iIndex=NewItem.6;
				NewItem.iEfficiency=_PlayerMenuInfo.iEfficiency;
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[6].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[6].fWidth;
//				iIndex=NewItem.7;
				NewItem.iRoundsFired=_PlayerMenuInfo.iRoundsFired;
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[7].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[7].fWidth;
//				iIndex=NewItem.8;
				NewItem.iRoundsHit=_PlayerMenuInfo.iRoundsHit;
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[8].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[8].fWidth;
//				iIndex=NewItem.9;
				NewItem.szKillBy=_PlayerMenuInfo.szKilledBy;
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[9].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[9].fWidth;
//				iIndex=NewItem.10;
				NewItem.iPingTime=_PlayerMenuInfo.iPingTime;
				NewItem.stTagCoord[iIndex].fXPos=m_stMenuCoord[10].fXPos;
				NewItem.stTagCoord[iIndex].fWidth=m_stMenuCoord[10].fWidth;
				NewItem.bOwnPlayer=_PlayerMenuInfo.bOwnPlayer;
				m_iTotalKills += NewItem.iKills;
				m_iTotalNbOfDead += NewItem.iMyDeadCounter;
				m_iTotalEfficiency += NewItem.iEfficiency;
				m_iTotalRoundsFired += NewItem.iRoundsFired;
				m_iTotalRoundsTaken += NewItem.iRoundsHit;
				m_iTotalRoomTake += 1;
				NewItem.m_bShowThisItem=True;
				CurItem=CurItem.Next;
			}
			i++;
			goto JL0058;
		}
		if ( m_IGPlayerInfoListBox.Items.CountShown() > 0 )
		{
			m_iTotalEfficiency=m_iTotalEfficiency / m_IGPlayerInfoListBox.Items.CountShown();
		}
	}
}

function ClearListOfItem ()
{
	local R6WindowListIGPlayerInfoItem NewItem;
	local UWindowList CurItem;
	local int i;
	local bool bAlreadyCreate;

	if ( m_IGPlayerInfoListBox.Items.Next != None )
	{
		bAlreadyCreate=True;
		CurItem=m_IGPlayerInfoListBox.Items.Next;
	}
	i=0;
JL0049:
	if ( i < 16 )
	{
		if ( bAlreadyCreate )
		{
			CurItem.m_bShowThisItem=False;
			CurItem=CurItem.Next;
		}
		else
		{
			NewItem=R6WindowListIGPlayerInfoItem(m_IGPlayerInfoListBox.Items.Append(m_IGPlayerInfoListBox.ListClass));
			NewItem.m_bShowThisItem=False;
		}
		i++;
		goto JL0049;
	}
}

function float GetPlayerListBorderHeight ()
{
	return 15.00 + 12;
}

function DrawInGameTeamBar (Canvas C, float _fY, float _fHeight)
{
	local float fXOffset;
	local float fWidth;

	fXOffset=m_stMenuCoord[0].fXPos;
	fWidth=m_stMenuCoord[0].fWidth;
//	AddIcon(C,fXOffset,_fY,fWidth,_fHeight,0);
	fXOffset=m_stMenuCoord[1].fXPos;
	fWidth=m_stMenuCoord[1].fWidth;
//	AddIcon(C,fXOffset,_fY,fWidth,_fHeight,1);
	fXOffset=m_stMenuCoord[2].fXPos;
	fWidth=m_stMenuCoord[2].fWidth;
	fXOffset=fXOffset + fWidth;
	AddVerticalLine(C,fXOffset,_fY,m_BorderTextureRegion.W,WinHeight);
	if (  !m_bTeamMenuLayout )
	{
		fXOffset=m_stMenuCoord[3].fXPos;
		fWidth=m_stMenuCoord[3].fWidth;
//		AddIcon(C,fXOffset,_fY,fWidth,_fHeight,2);
		fXOffset=fXOffset + fWidth;
		AddVerticalLine(C,fXOffset,_fY,m_BorderTextureRegion.W,WinHeight);
	}
	fXOffset=m_stMenuCoord[4].fXPos;
	fWidth=m_stMenuCoord[4].fWidth;
//	AddIcon(C,fXOffset,_fY,fWidth,_fHeight,3);
	fXOffset=m_stMenuCoord[5].fXPos;
	fWidth=m_stMenuCoord[5].fWidth;
//	AddIcon(C,fXOffset,_fY,fWidth,_fHeight,4);
	fXOffset=fXOffset + fWidth;
	AddVerticalLine(C,fXOffset,_fY,m_BorderTextureRegion.W,WinHeight);
	fXOffset=m_stMenuCoord[6].fXPos;
	fWidth=m_stMenuCoord[6].fWidth;
//	AddIcon(C,fXOffset,_fY,fWidth,_fHeight,5);
	fXOffset=m_stMenuCoord[7].fXPos;
	fWidth=m_stMenuCoord[7].fWidth;
//	AddIcon(C,fXOffset,_fY,fWidth,_fHeight,6);
	fXOffset=m_stMenuCoord[8].fXPos;
	fWidth=m_stMenuCoord[8].fWidth;
//	AddIcon(C,fXOffset,_fY,fWidth,_fHeight,7);
	fXOffset=fXOffset + fWidth;
	AddVerticalLine(C,fXOffset,_fY,m_BorderTextureRegion.W,WinHeight);
	fXOffset=m_stMenuCoord[9].fXPos;
	fWidth=m_stMenuCoord[9].fWidth;
//	AddIcon(C,fXOffset,_fY,fWidth,_fHeight,8);
	fXOffset=fXOffset + fWidth;
	AddVerticalLine(C,fXOffset,_fY,m_BorderTextureRegion.W,WinHeight);
	fXOffset=m_stMenuCoord[10].fXPos;
	fWidth=m_stMenuCoord[10].fWidth;
//	AddIcon(C,fXOffset,_fY,fWidth,_fHeight,9);
}

function AddVerticalLine (Canvas C, float _fX, float _fY, float _fWidth, float _fHeight)
{
	DrawStretchedTextureSegment(C,_fX,_fY,_fWidth,_fHeight,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
}

function AddIcon (Canvas C, float _fX, float _fY, float _fWidth, float _fHeight, eIconType _eIconType)
{
	local Region RIconRegion;
	local Region RIconToDraw;
	local R6MenuRSLookAndFeel R6LAF;
	local float fY;

	R6LAF=R6MenuRSLookAndFeel(LookAndFeel);
	fY=_fY;
	switch (_eIconType)
	{
/*		case 0:
		RIconToDraw.X=18;
		RIconToDraw.Y=14;
		RIconToDraw.W=8;
		RIconToDraw.H=14;
		break;
		case 1:
		RIconToDraw.X=0;
		RIconToDraw.Y=28;
		RIconToDraw.W=13;
		RIconToDraw.H=14;
		break;
		case 2:
		RIconToDraw.X=27;
		RIconToDraw.Y=14;
		RIconToDraw.W=8;
		RIconToDraw.H=14;
		break;
		case 3:
		RIconToDraw.X=36;
		RIconToDraw.Y=14;
		RIconToDraw.W=12;
		RIconToDraw.H=14;
		break;
		case 4:
		RIconToDraw.X=14;
		RIconToDraw.Y=0;
		RIconToDraw.W=13;
		RIconToDraw.H=14;
		break;
		case 5:
		RIconToDraw.X=28;
		RIconToDraw.Y=0;
		RIconToDraw.W=14;
		RIconToDraw.H=14;
		break;
		case 6:
		RIconToDraw.X=49;
		RIconToDraw.Y=14;
		RIconToDraw.W=7;
		RIconToDraw.H=14;
		break;
		case 7:
		RIconToDraw.X=14;
		RIconToDraw.Y=28;
		RIconToDraw.W=16;
		RIconToDraw.H=14;
		break;
		case 8:
		RIconToDraw.X=0;
		RIconToDraw.Y=14;
		RIconToDraw.W=17;
		RIconToDraw.H=14;
		break;
		case 9:
		RIconToDraw.X=46;
		RIconToDraw.Y=0;
		RIconToDraw.W=13;
		RIconToDraw.H=14;
		break;
		default:*/
	}
	RIconRegion=R6LAF.CenterIconInBox(_fX,fY,_fWidth,_fHeight,RIconToDraw);
	DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
}

function DrawInGameTeamBarUpBorder (Canvas C, float _fX, float _fY, float _fWidth, float _fHeight)
{
	C.SetDrawColor(m_vTeamColor.R,m_vTeamColor.G,m_vTeamColor.B);
	DrawStretchedTextureSegment(C,_fX,_fY,_fWidth,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,_fX,_fY + _fHeight,_fWidth,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
}

function DrawInGameTeamBarDownBorder (Canvas C, float _fX, float _fY, float _fWidth, float _fHeight)
{
	C.SetDrawColor(m_vTeamColor.R,m_vTeamColor.G,m_vTeamColor.B);
	DrawStretchedTextureSegment(C,_fX,_fY,_fWidth,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
}

function InitTeamBar ()
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local Font ButtonFont;

	if ( m_pTextTeamBar == None )
	{
		m_pTextTeamBar=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',0.00,0.00,WinWidth,WinHeight,self));
		m_pTextTeamBar.bAlwaysBehind=True;
		m_pTextTeamBar.SetNoBorder();
		m_pTextTeamBar.m_Font=Root.Fonts[6];
		m_pTextTeamBar.m_vTextColor=m_vTeamColor;
		Refresh();
		InitIGPlayerInfoList();
	}
}

function InitIGPlayerInfoList ()
{
	m_IGPlayerInfoListBox=R6WindowIGPlayerInfoListBox(CreateWindow(Class'R6WindowIGPlayerInfoListBox',0.00,15.00,WinWidth,WinHeight - GetPlayerListBorderHeight(),self));
//	m_IGPlayerInfoListBox.SetCornerType(1);
	m_IGPlayerInfoListBox.m_Font=Root.Fonts[6];
}

function InitMissionWindows ()
{
	m_pTitleCoop=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,0.00,WinWidth,20.00,self));
	m_pTitleCoop.Text=Localize("MPInGame","Coop_MissionDebr","R6Menu");
	m_pTitleCoop.align=ta_center;
	m_pTitleCoop.m_Font=Root.Fonts[8];
	m_pTitleCoop.TextColor=Root.Colors.White;
	m_pTitleCoop.m_fHBorderPadding=2.00;
	m_pTitleCoop.m_VBorderTexture=None;
	m_pMissionObj=R6MenuMPInGameObj(CreateWindow(Class'R6MenuMPInGameObj',0.00,20.00,WinWidth,WinHeight - 20,self));
}

function InitMenuLayout (int _MenuToDisplay)
{
	m_bTeamMenuLayout=False;
	if ( _MenuToDisplay == 1 )
	{
		m_bTeamMenuLayout=True;
		m_stMenuCoord[0].fXPos=4.00;
		m_stMenuCoord[0].fWidth=15.00;
		m_stMenuCoord[1].fXPos=m_stMenuCoord[0].fXPos + m_stMenuCoord[0].fWidth;
		m_stMenuCoord[1].fWidth=21.00;
		m_stMenuCoord[2].fXPos=m_stMenuCoord[1].fXPos + m_stMenuCoord[1].fWidth;
		m_stMenuCoord[2].fWidth=153.00;
		m_stMenuCoord[3].fXPos=0.00;
		m_stMenuCoord[3].fWidth=0.00;
		m_stMenuCoord[4].fXPos=m_stMenuCoord[2].fXPos + m_stMenuCoord[2].fWidth;
		m_stMenuCoord[4].fWidth=42.00;
		m_stMenuCoord[5].fXPos=m_stMenuCoord[4].fXPos + m_stMenuCoord[4].fWidth;
		m_stMenuCoord[5].fWidth=41.00;
		m_stMenuCoord[6].fXPos=m_stMenuCoord[5].fXPos + m_stMenuCoord[5].fWidth;
		m_stMenuCoord[6].fWidth=40.00;
		m_stMenuCoord[7].fXPos=m_stMenuCoord[6].fXPos + m_stMenuCoord[6].fWidth;
		m_stMenuCoord[7].fWidth=40.00;
		m_stMenuCoord[8].fXPos=m_stMenuCoord[7].fXPos + m_stMenuCoord[7].fWidth;
		m_stMenuCoord[8].fWidth=40.00;
		m_stMenuCoord[9].fXPos=m_stMenuCoord[8].fXPos + m_stMenuCoord[8].fWidth;
		m_stMenuCoord[9].fWidth=m_stMenuCoord[2].fWidth;
		m_stMenuCoord[10].fXPos=m_stMenuCoord[9].fXPos + m_stMenuCoord[9].fWidth;
		m_stMenuCoord[10].fWidth=41.00;
	}
	else
	{
		m_stMenuCoord[0].fXPos=2.00;
		m_stMenuCoord[0].fWidth=15.00;
		m_stMenuCoord[1].fXPos=m_stMenuCoord[0].fXPos + m_stMenuCoord[0].fWidth;
		m_stMenuCoord[1].fWidth=15.00;
		m_stMenuCoord[2].fXPos=m_stMenuCoord[1].fXPos + m_stMenuCoord[1].fWidth;
		m_stMenuCoord[2].fWidth=153.00;
		m_stMenuCoord[3].fXPos=m_stMenuCoord[2].fXPos + m_stMenuCoord[2].fWidth;
		m_stMenuCoord[3].fWidth=37.00;
		m_stMenuCoord[4].fXPos=m_stMenuCoord[3].fXPos + m_stMenuCoord[3].fWidth;
		m_stMenuCoord[4].fWidth=36.00;
		m_stMenuCoord[5].fXPos=m_stMenuCoord[4].fXPos + m_stMenuCoord[4].fWidth;
		m_stMenuCoord[5].fWidth=36.00;
		m_stMenuCoord[6].fXPos=m_stMenuCoord[5].fXPos + m_stMenuCoord[5].fWidth;
		m_stMenuCoord[6].fWidth=36.00;
		m_stMenuCoord[7].fXPos=m_stMenuCoord[6].fXPos + m_stMenuCoord[6].fWidth;
		m_stMenuCoord[7].fWidth=36.00;
		m_stMenuCoord[8].fXPos=m_stMenuCoord[7].fXPos + m_stMenuCoord[7].fWidth;
		m_stMenuCoord[8].fWidth=36.00;
		m_stMenuCoord[9].fXPos=m_stMenuCoord[8].fXPos + m_stMenuCoord[8].fWidth;
		m_stMenuCoord[9].fWidth=m_stMenuCoord[2].fWidth;
		m_stMenuCoord[10].fXPos=m_stMenuCoord[9].fXPos + m_stMenuCoord[9].fWidth;
		m_stMenuCoord[10].fWidth=35.00;
	}
}

defaultproperties
{
}
/*
    m_TIcon=Texture'R6MenuTextures.TeamBarIcon'
*/

