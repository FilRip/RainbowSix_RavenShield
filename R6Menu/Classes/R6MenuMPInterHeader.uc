//================================================================================
// R6MenuMPInterHeader.
//================================================================================
class R6MenuMPInterHeader extends UWindowWindow;

var int m_iIndex[9];
var bool m_bDisplayTotVictory;
var bool m_bDisplayCoopStatus;
var bool m_bDisplayCoopBox;
var R6WindowTextLabelExt m_pTextHeader;
var string m_szGameResult[5];
const C_fYPOS_OF_TEAMSCORE= 48;
const C_fXTEXT_HEADER_OFFSET= 4;
const C_fXBORDER_OFFSET= 2;
const C_iMISSION_STATUS= 8;
const C_iTOT_RED_TEAM_VICTORY= 7;
const C_iTOT_GREEN_TEAM_VICTORY= 6;
const C_iTIME_PER_ROUND= 5;
const C_iROUND= 4;
const C_iGAME_TYPE= 3;
const C_iMAP_NAME= 2;
const C_iSERVER_IP= 1;
const C_iSERVER_NAME= 0;

function Created ()
{
	m_szGameResult[0]=Localize("MPInGame","AlphaTeamScore","R6Menu");
	m_szGameResult[1]=Localize("MPInGame","BravoTeamScore","R6Menu");
	m_szGameResult[2]=Localize("DebriefingMenu","SUCCESS","R6Menu");
	m_szGameResult[3]=Localize("DebriefingMenu","FAILED","R6Menu");
	m_szGameResult[4]=Localize("MPInGame","MissionInProgress","R6Menu");
	m_bDisplayCoopBox=False;
	InitTextHeader();
}

function Paint (Canvas C, float X, float Y)
{
	local float fX;

	fX=2.00 + 4;
	if ( m_bDisplayTotVictory )
	{
		DrawTeamScore(C,Root.Colors.TeamColor[1],Root.Colors.TeamColorDark[1],fX,48.00,WinWidth * 0.50 - 2 * fX,14.00);
		DrawTeamScore(C,Root.Colors.TeamColor[0],Root.Colors.TeamColorDark[0],WinWidth * 0.50 + fX,48.00,WinWidth * 0.50 - 2 * fX,14.00);
	}
	else
	{
		if ( m_bDisplayCoopBox )
		{
			DrawTeamScore(C,m_pTextHeader.GetTextColor(m_iIndex[8]),m_pTextHeader.GetTextColor(m_iIndex[8]),fX,48.00,WinWidth - 2 * fX,14.00);
		}
	}
}

function DrawTeamScore (Canvas C, Color _cTeamColor, Color _cBGColor, float _fX, float _fY, float _fW, float _fH)
{
	DrawSimpleBackGround(C,_fX,_fY,_fW,_fH,_cBGColor);
	C.SetDrawColor(_cTeamColor.R,_cTeamColor.G,_cTeamColor.B);
	DrawStretchedTextureSegment(C,_fX,_fY,_fW,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,_fX,_fY + _fH - m_BorderTextureRegion.H,_fW,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,_fX,_fY + m_BorderTextureRegion.H,m_BorderTextureRegion.W,_fH - 2 * m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,_fX + _fW - m_BorderTextureRegion.W,_fY + m_BorderTextureRegion.H,m_BorderTextureRegion.W,_fH - 2 * m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
}

function InitTextHeader ()
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local float fTemp;
	local float fSizeOfCounter;
	local Font ButtonFont;

	m_pTextHeader=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',0.00,0.00,WinWidth,WinHeight,self));
	m_pTextHeader.bAlwaysBehind=True;
	m_pTextHeader.SetNoBorder();
	m_pTextHeader.m_Font=Root.Fonts[6];
	m_pTextHeader.m_vTextColor=Root.Colors.White;
	fXOffset=4.00;
	fYOffset=4.00;
	fWidth=WinWidth * 0.50;
	fYStep=14.00;
//	m_pTextHeader.AddTextLabel(Localize("MPInGame","ServerName","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fYOffset += fYStep;
//	m_pTextHeader.AddTextLabel(Localize("MPInGame","ServerIP","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fYOffset += fYStep;
//	m_pTextHeader.AddTextLabel(Localize("MPInGame","MapName","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fXOffset=fWidth + 4;
	fYOffset=4.00;
//	m_pTextHeader.AddTextLabel(Localize("MPInGame","GameType","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fYOffset += fYStep;
//	m_pTextHeader.AddTextLabel(Localize("MPInGame","Round","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fYOffset += fYStep;
//	m_pTextHeader.AddTextLabel(Localize("MPInGame","TimePerRound","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fWidth=WinWidth * 0.25;
	fXOffset=WinWidth * 0.20;
	fYOffset=4.00;
	m_pTextHeader.m_vTextColor=Root.Colors.BlueLight;
	m_pTextHeader.m_bUpDownBG=True;
//	m_iIndex[0]=m_pTextHeader.AddTextLabel("",fXOffset,fYOffset,fWidth,2,False,12.00);
	fYOffset += fYStep;
//	m_iIndex[1]=m_pTextHeader.AddTextLabel("",fXOffset,fYOffset,fWidth,2,False,12.00);
	fYOffset += fYStep;
//	m_iIndex[2]=m_pTextHeader.AddTextLabel("",fXOffset,fYOffset,fWidth,2,False,12.00);
	fXOffset=WinWidth * 0.50 + fXOffset;
	fYOffset=4.00;
//	m_iIndex[3]=m_pTextHeader.AddTextLabel("",fXOffset,fYOffset,fWidth,2,False,12.00);
	fYOffset += fYStep;
//	m_iIndex[4]=m_pTextHeader.AddTextLabel("",fXOffset,fYOffset,fWidth,2,False,12.00);
	fYOffset += fYStep;
//	m_iIndex[5]=m_pTextHeader.AddTextLabel("",fXOffset,fYOffset,fWidth,2,False,12.00);
	fXOffset=4.00;
	fYOffset=48.00 + 1;
	fWidth=WinWidth * 0.50 - 2 * fXOffset;
	m_pTextHeader.m_bUpDownBG=False;
	m_pTextHeader.m_vTextColor=Root.Colors.TeamColorLight[1];
//	m_iIndex[6]=m_pTextHeader.AddTextLabel("",fXOffset,fYOffset,fWidth,2,False,14.00);
	fXOffset=fWidth + 4;
	m_pTextHeader.m_vTextColor=Root.Colors.TeamColorLight[0];
//	m_iIndex[7]=m_pTextHeader.AddTextLabel("",fXOffset,fYOffset,fWidth,2,False,14.00);
	fXOffset=2.00 + 4;
	fWidth=WinWidth - 2 * fXOffset;
	m_pTextHeader.m_vTextColor=Root.Colors.White;
//	m_iIndex[8]=m_pTextHeader.AddTextLabel("",fXOffset,fYOffset,fWidth,2,False,14.00);
}

function RefreshInterHeaderInfo ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local string szIP;
	local string szGameType;
	local string szTemp;
	local float fCurrentTime;
	local R6GameReplicationInfo r6GameRep;
	local R6MenuMPInterWidget MpInter;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	if ( r6Root.m_R6GameMenuCom != None )
	{
		r6GameRep=R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo);
		if ( r6GameRep == None )
		{
			return;
		}
		szIP=R6Console(Root.Console).szStoreIP;
		m_pTextHeader.ChangeTextLabel(r6GameRep.ServerName,m_iIndex[0]);
		m_pTextHeader.ChangeTextLabel(szIP,m_iIndex[1]);
		if (  !Root.GetMapNameLocalisation(GetLevel().GetURLMap(),szTemp) )
		{
			szTemp=GetLevel().GetURLMap();
		}
		m_pTextHeader.ChangeTextLabel(szTemp,m_iIndex[2]);
//		szGameType=GetLevel().GetGameNameLocalization(r6Root.m_R6GameMenuCom.GetGameType());
		m_pTextHeader.ChangeTextLabel(szGameType,m_iIndex[3]);
		RefreshRoundInfo();
		MpInter=R6MenuMPInterWidget(OwnerWindow);
		if ( r6Root.m_R6GameMenuCom.IsInBetweenRoundMenu() )
		{
			fCurrentTime=r6GameRep.TimeLimit;
		}
		else
		{
			fCurrentTime=r6GameRep.GetRoundTime();
		}
		m_pTextHeader.ChangeTextLabel(Class'Actor'.static.ConvertIntTimeToString(fCurrentTime) @ "/" @ Class'Actor'.static.ConvertIntTimeToString(r6GameRep.TimeLimit),m_iIndex[5]);
		if ( m_bDisplayTotVictory )
		{
			m_pTextHeader.ChangeTextLabel(m_szGameResult[0] $ " " $ string(r6GameRep.m_aTeamScore[0]),m_iIndex[6]);
			m_pTextHeader.ChangeTextLabel(m_szGameResult[1] $ " " $ string(r6GameRep.m_aTeamScore[1]),m_iIndex[7]);
		}
		else
		{
			if ( m_bDisplayCoopStatus )
			{
				if ( MpInter.IsMissionInProgress() )
				{
					if (  !r6Root.m_R6GameMenuCom.IsInBetweenRoundMenu(True) )
					{
						m_pTextHeader.ChangeColorLabel(Root.Colors.White,m_iIndex[8]);
						m_pTextHeader.ChangeTextLabel(m_szGameResult[4],m_iIndex[8]);
					}
					else
					{
						if ( MpInter.GetLastMissionSuccess() == 0 )
						{
							m_pTextHeader.ChangeTextLabel("",m_iIndex[8]);
						}
						else
						{
							if ( R6MenuMPInterWidget(OwnerWindow).GetLastMissionSuccess() == 1 )
							{
								m_pTextHeader.ChangeColorLabel(Root.Colors.TeamColorLight[1],m_iIndex[8]);
								m_pTextHeader.ChangeTextLabel(m_szGameResult[2],m_iIndex[8]);
							}
							else
							{
								m_pTextHeader.ChangeColorLabel(Root.Colors.TeamColorLight[0],m_iIndex[8]);
								m_pTextHeader.ChangeTextLabel(m_szGameResult[3],m_iIndex[8]);
							}
						}
					}
				}
				else
				{
					if ( MpInter.IsMissionSuccess() )
					{
						m_pTextHeader.ChangeColorLabel(Root.Colors.TeamColorLight[1],m_iIndex[8]);
						m_pTextHeader.ChangeTextLabel(m_szGameResult[2],m_iIndex[8]);
					}
					else
					{
						m_pTextHeader.ChangeColorLabel(Root.Colors.TeamColorLight[0],m_iIndex[8]);
						m_pTextHeader.ChangeTextLabel(m_szGameResult[3],m_iIndex[8]);
					}
				}
				m_bDisplayCoopBox=m_pTextHeader.GetTextLabel(m_iIndex[8]) != "";
			}
			else
			{
				ResetDisplayInfo();
			}
		}
		if ( r6Root.m_R6GameMenuCom.IsInBetweenRoundMenu() )
		{
			if ( r6GameRep.m_bRepMenuCountDownTimePaused )
			{
				r6Root.UpdateTimeInBetRound(0,Localize("MPInGame","PausedMessage","R6Menu"));
			}
			else
			{
				if ( r6GameRep.m_bRepMenuCountDownTimeUnlimited )
				{
					r6Root.UpdateTimeInBetRound(0,Localize("MPInGame","WaitMessage","R6Menu"));
				}
				else
				{
					r6Root.UpdateTimeInBetRound(r6GameRep.GetRoundTime());
				}
			}
		}
		else
		{
			r6Root.UpdateTimeInBetRound(-1);
		}
	}
}

function RefreshRoundInfo ()
{
	local R6GameReplicationInfo r6GameRep;
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	r6GameRep=R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo);
	if ( r6GameRep == None )
	{
		return;
	}
/*	if ( GetLevel().IsGameTypeCooperative(r6Root.m_eCurrentGameType) )
	{
		if ( r6GameRep.m_bRotateMap )
		{
			m_pTextHeader.ChangeTextLabel(string(r6GameRep.m_iCurrentRound + 1) @ "/ --",m_iIndex[4]);
			return;
		}
	}
	if ( r6Root.m_R6GameMenuCom.m_GameRepInfo.m_eCurrectServerState == r6Root.m_R6GameMenuCom.m_GameRepInfo.4 )
	{
		m_pTextHeader.ChangeTextLabel(Localize("MPInGame","MatchCompleted","R6Menu"),m_iIndex[4]);
	}
	else
	{
		m_pTextHeader.ChangeTextLabel(string(r6GameRep.m_iCurrentRound + 1) @ "/" @ string(r6GameRep.m_iRoundsPerMatch),m_iIndex[4]);
	}*/
}

function ResetDisplayInfo ()
{
	m_pTextHeader.ChangeTextLabel("",m_iIndex[6]);
	m_pTextHeader.ChangeTextLabel("",m_iIndex[7]);
	m_pTextHeader.ChangeTextLabel("",m_iIndex[8]);
}

function Reset ()
{
	m_bDisplayTotVictory=False;
	m_bDisplayCoopStatus=False;
	m_bDisplayCoopBox=False;
	ResetDisplayInfo();
}
