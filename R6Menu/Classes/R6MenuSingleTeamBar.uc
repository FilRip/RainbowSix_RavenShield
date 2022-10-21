//================================================================================
// R6MenuSingleTeamBar.
//================================================================================
class R6MenuSingleTeamBar extends UWindowDialogControl;

var int m_IBorderVOffset;
var int m_iTotalNeutralized;
var int m_iTotalEfficiency;
var int m_iTotalRoundsFired;
var int m_iTotalRoundsTaken;
var int m_INameTextPadding;
var int m_IFirstItempYOffset;
var bool m_bDrawBorders;
var bool m_bDrawTotalsShading;
var bool bShowLog;
var float m_fBottomTitleWidth;
var float m_fTeamcolorWidth;
var float m_fRainbowWidth;
var float m_fHealthWidth;
var float m_fSkullWidth;
var float m_fEfficiencyWidth;
var float m_fShotsWidth;
var float m_fHitsWidth;
var R6WindowTextLabel m_BottomTitle;
var R6WindowTextLabel m_TimeMissionTitle;
var R6WindowTextLabel m_TimeMissionValue;
var R6WindowTextLabel m_KillLabel;
var R6WindowTextLabel m_EfficiencyLabel;
var R6WindowTextLabel m_RoundsFiredLabel;
var R6WindowTextLabel m_RoundsTakenLabel;
var R6WindowSimpleIGPlayerListBox m_IGPlayerInfoListBox;
var Texture m_TIcon;
var Texture m_TBorder;
var Texture m_THighLight;
var Region m_RBorder;
var Region m_RHighLight;
const C_fXICONS_START_POS= 0;
const C_fTEAMBAR_TOTALS_HEIGHT= 15;
const C_fTEAMBAR_MISSIONTIME_HEIGHT= 14;
const C_fTEAMBAR_ICON_HEIGHT= 16;

function Paint (Canvas C, float X, float Y)
{
	local int IDblOffset;

	IDblOffset=2 * m_IBorderVOffset;
	if ( m_bDrawTotalsShading )
	{
		R6WindowLookAndFeel(LookAndFeel).DrawBGShading(self,C,0.00,16.00,WinWidth,WinHeight - 16);
	}
	C.Style=5;
	DrawInGameSingleTeamBar(C,0.00,1.00,16.00);
	DrawInGameSingleTeamBarUpBorder(C,m_IBorderVOffset,0.00,WinWidth - IDblOffset,16.00);
	DrawInGameSingleTeamBarMiddleBorder(C,m_IBorderVOffset,WinHeight - 15 - 14,WinWidth - IDblOffset,15.00);
	DrawInGameSingleTeamBarDownBorder(C,m_IBorderVOffset,WinHeight - 14,WinWidth - IDblOffset,14.00);
	if ( m_bDrawBorders )
	{
		DrawSimpleBorder(C);
	}
}

function Created ()
{
	local float YLabelPos;
	local float fXOffset;

	m_BorderColor=Root.Colors.GrayLight;
	fXOffset=4.00;
	YLabelPos=WinHeight - 14;
	m_TimeMissionTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,YLabelPos,m_fBottomTitleWidth,14.00,self));
	m_TimeMissionTitle.Align=TA_Center;
	m_TimeMissionTitle.m_Font=Root.Fonts[5];
	m_TimeMissionTitle.TextColor=Root.Colors.BlueLight;
	m_TimeMissionTitle.m_fLMarge=fXOffset;
	m_TimeMissionTitle.SetNewText(Localize("DebriefingMenu","MissionTime","R6Menu"),True);
	m_TimeMissionTitle.m_bDrawBorders=False;
	m_TimeMissionValue=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_TimeMissionTitle.WinWidth,YLabelPos,WinWidth - m_TimeMissionTitle.WinWidth,14.00,self));
	m_TimeMissionValue.Align=TA_Center;
	m_TimeMissionValue.m_Font=Root.Fonts[5];
	m_TimeMissionValue.TextColor=Root.Colors.White;
	m_TimeMissionValue.m_bDrawBorders=False;
	YLabelPos -= 15;
	m_BottomTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,YLabelPos,m_fBottomTitleWidth,15.00,self));
	m_BottomTitle.Align=TA_Center;
	m_BottomTitle.m_Font=Root.Fonts[5];
	m_BottomTitle.TextColor=Root.Colors.BlueLight;
	m_BottomTitle.m_fLMarge=fXOffset;
	m_BottomTitle.SetNewText(Localize("MPInGame","TotalTeamStatus","R6Menu"),True);
	m_BottomTitle.m_bDrawBorders=False;
	m_KillLabel=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fBottomTitleWidth,YLabelPos,m_fSkullWidth,15.00,self));
	m_KillLabel.Text="00";
	m_KillLabel.Align=TA_Center;
	m_KillLabel.m_Font=Root.Fonts[5];
	m_KillLabel.TextColor=Root.Colors.White;
	m_KillLabel.m_bDrawBorders=False;
	m_EfficiencyLabel=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_KillLabel.WinLeft + m_KillLabel.WinWidth,YLabelPos,m_fEfficiencyWidth,15.00,self));
	m_EfficiencyLabel.Text="00";
	m_EfficiencyLabel.Align=TA_Center;
	m_EfficiencyLabel.m_Font=Root.Fonts[5];
	m_EfficiencyLabel.TextColor=Root.Colors.White;
	m_EfficiencyLabel.m_bDrawBorders=False;
	m_RoundsFiredLabel=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_EfficiencyLabel.WinLeft + m_EfficiencyLabel.WinWidth,YLabelPos,m_fShotsWidth,15.00,self));
	m_RoundsFiredLabel.Text="00";
	m_RoundsFiredLabel.Align=TA_Center;
	m_RoundsFiredLabel.m_Font=Root.Fonts[5];
	m_RoundsFiredLabel.TextColor=Root.Colors.White;
	m_RoundsFiredLabel.m_bDrawBorders=False;
	m_RoundsTakenLabel=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_RoundsFiredLabel.WinLeft + m_RoundsFiredLabel.WinWidth,YLabelPos,m_fHitsWidth,15.00,self));
	m_RoundsTakenLabel.Text="00";
	m_RoundsTakenLabel.Align=TA_Center;
	m_RoundsTakenLabel.m_Font=Root.Fonts[5];
	m_RoundsTakenLabel.TextColor=Root.Colors.White;
	m_RoundsTakenLabel.m_bDrawBorders=False;
	CreateIGPListBox();
}

function DrawInGameSingleTeamBarMiddleBorder (Canvas C, float _fX, float _fY, float _fWidth, float _fHeight)
{
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTextureSegment(C,_fX,_fY,_fWidth,m_RBorder.H,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
	DrawStretchedTextureSegment(C,m_fBottomTitleWidth,_fY,m_RBorder.W,_fHeight,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
	DrawStretchedTextureSegment(C,_fX,_fY + _fHeight - m_RBorder.H,_fWidth,m_RBorder.H,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
}

function DrawInGameSingleTeamBarDownBorder (Canvas C, float _fX, float _fY, float _fWidth, float _fHeight)
{
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTextureSegment(C,m_fBottomTitleWidth,_fY,m_RBorder.W,_fHeight,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
	if (  !m_bDrawBorders )
	{
		DrawStretchedTextureSegment(C,_fX,_fY + _fHeight - m_RBorder.H,_fWidth,m_RBorder.H,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
	}
}

function DrawInGameSingleTeamBarUpBorder (Canvas C, float _fX, float _fY, float _fWidth, float _fHeight)
{
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTextureSegment(C,_fX,_fY,_fWidth,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,_fX,_fY + _fHeight,_fWidth,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
}

function DrawInGameSingleTeamBar (Canvas C, float _fX, float _fY, float _fHeight)
{
	local float fXOffset;
	local float fWidth;
	local Region RIconRegion;
	local Region RIconToDraw;
	local R6MenuRSLookAndFeel R6LAF;

	R6LAF=R6MenuRSLookAndFeel(LookAndFeel);
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	RIconToDraw.X=52;
	RIconToDraw.Y=52;
	RIconToDraw.W=12;
	RIconToDraw.H=12;
	fXOffset=_fX;
	fWidth=m_fTeamcolorWidth;
	RIconRegion=R6LAF.CenterIconInBox(fXOffset,_fY,fWidth,_fHeight,RIconToDraw);
	DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTextureSegment(C,fXOffset + fWidth,_fY,m_RBorder.W,_fHeight,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	RIconToDraw.X=0;
	RIconToDraw.Y=0;
	RIconToDraw.W=13;
	RIconToDraw.H=14;
	fXOffset=fXOffset + fWidth;
	fWidth=m_fRainbowWidth;
	RIconRegion=R6LAF.CenterIconInBox(fXOffset,_fY,fWidth,_fHeight,RIconToDraw);
	DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTextureSegment(C,fXOffset + fWidth,_fY,m_RBorder.W,_fHeight,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	RIconToDraw.X=0;
	RIconToDraw.Y=28;
	RIconToDraw.W=13;
	RIconToDraw.H=14;
	fXOffset=fXOffset + fWidth;
	fWidth=m_fHealthWidth;
	RIconRegion=R6LAF.CenterIconInBox(fXOffset,_fY,fWidth,_fHeight,RIconToDraw);
	DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTextureSegment(C,fXOffset + fWidth,_fY,m_RBorder.W,_fHeight,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	RIconToDraw.X=14;
	RIconToDraw.Y=0;
	RIconToDraw.W=13;
	RIconToDraw.H=14;
	fXOffset=fXOffset + fWidth;
	fWidth=m_fSkullWidth;
	RIconRegion=R6LAF.CenterIconInBox(fXOffset,_fY,fWidth,_fHeight,RIconToDraw);
	DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTextureSegment(C,fXOffset + fWidth,_fY,m_RBorder.W,_fHeight,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	RIconToDraw.X=28;
	RIconToDraw.Y=0;
	RIconToDraw.W=14;
	RIconToDraw.H=14;
	fXOffset=fXOffset + fWidth;
	fWidth=m_fEfficiencyWidth;
	RIconRegion=R6LAF.CenterIconInBox(fXOffset,_fY,fWidth,_fHeight,RIconToDraw);
	DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTextureSegment(C,fXOffset + fWidth,_fY,m_RBorder.W,_fHeight,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	RIconToDraw.X=49;
	RIconToDraw.Y=14;
	RIconToDraw.W=7;
	RIconToDraw.H=14;
	fXOffset=fXOffset + fWidth;
	fWidth=m_fShotsWidth;
	RIconRegion=R6LAF.CenterIconInBox(fXOffset,_fY,fWidth,_fHeight,RIconToDraw);
	DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTextureSegment(C,fXOffset + fWidth,_fY,m_RBorder.W,_fHeight,m_RBorder.X,m_RBorder.Y,m_RBorder.W,m_RBorder.H,m_TBorder);
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	RIconToDraw.X=14;
	RIconToDraw.Y=28;
	RIconToDraw.W=16;
	RIconToDraw.H=14;
	fXOffset=fXOffset + fWidth;
	fWidth=m_fHitsWidth;
	RIconRegion=R6LAF.CenterIconInBox(fXOffset,_fY,fWidth,_fHeight,RIconToDraw);
	DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
}

function RefreshTeamBarInfo ()
{
	local R6MissionObjectiveMgr moMgr;
	local float fMissionTime;
	local bool bPlayTestLog;
	local int i;
	local int iRainbowDead;
	local int iTerroNeutralized;
	local R6RainbowTeam CurrentTeam;
	local R6GameInfo GameInfo;

	m_iTotalNeutralized=0;
	m_iTotalEfficiency=0;
	m_iTotalRoundsFired=0;
	m_iTotalRoundsTaken=0;
	ClearListOfItem();
	AddItems();
	moMgr=R6AbstractGameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_missionMgr;
	if ( moMgr.m_eMissionObjectiveStatus == 0 )
	{
		fMissionTime=GetLevel().Level.TimeSeconds - R6GameInfo(GetLevel().Game).m_fRoundStartTime;
	}
	else
	{
		bPlayTestLog=True;
		fMissionTime=R6GameInfo(GetLevel().Game).m_fRoundEndTime - R6GameInfo(GetLevel().Game).m_fRoundStartTime;
	}
	m_TimeMissionValue.SetNewText(Class'Actor'.static.ConvertIntTimeToString(fMissionTime),True);
	m_KillLabel.SetNewText(string(m_iTotalNeutralized),True);
	m_EfficiencyLabel.SetNewText(string(m_iTotalEfficiency),True);
	m_RoundsFiredLabel.SetNewText(string(m_iTotalRoundsFired),True);
	m_RoundsTakenLabel.SetNewText(string(m_iTotalRoundsTaken),True);
	if ( bPlayTestLog )
	{
		GameInfo=R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game);
		i=0;
JL01DD:
		if ( i < 3 )
		{
			CurrentTeam=R6RainbowTeam(GameInfo.GetRainbowTeam(i));
			if ( CurrentTeam != None )
			{
				iRainbowDead += CurrentTeam.m_iMembersLost;
			}
			i++;
			goto JL01DD;
		}
		Log("-PLAYTEST- " $ R6Console(Root.Console).Master.m_StartGameInfo.m_MapName);
		Log("-PLAYTEST- mode                 =" $ Root.Console.ViewportOwner.Actor.Level.GetGameTypeClassName(GameInfo.m_eGameTypeFlag));
		Log("-PLAYTEST- difficulty level     =" $ string(GameInfo.m_iDiffLevel));
		Log("-PLAYTEST- mission time length  =" $ m_TimeMissionValue.Text);
		Log("-PLAYTEST- terro neutralized    =" $ string(m_iTotalNeutralized));
		Log("-PLAYTEST- rainbow killed       =" $ string(iRainbowDead));
		Log("-PLAYTEST- nb of retries        =" $ string(R6GameInfo(GetLevel().Game).m_iNbOfRestart));
	}
}

function AddItems ()
{
	local R6WindowListIGPlayerInfoItem NewItem;
	local int i;
	local int Y;
	local R6RainbowTeam CurrentTeam;
	local R6GameInfo GameInfo;

	GameInfo=R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game);
	m_iTotalNeutralized=GameInfo.GetNbTerroNeutralized();
	i=0;
JL0059:
	if ( i < 3 )
	{
		CurrentTeam=R6RainbowTeam(GameInfo.GetRainbowTeam(i));
		if ( CurrentTeam != None )
		{
			Y=0;
JL0096:
			if ( Y < CurrentTeam.m_iMemberCount + CurrentTeam.m_iMembersLost )
			{
				NewItem=R6WindowListIGPlayerInfoItem(m_IGPlayerInfoListBox.Items.Append(m_IGPlayerInfoListBox.ListClass));
				NewItem.m_iRainbowTeam=i;
				NewItem.stTagCoord[0].fXPos=0.00;
				NewItem.stTagCoord[0].fWidth=m_fTeamcolorWidth;
				NewItem.szPlName=CurrentTeam.m_Team[Y].m_CharacterName;
				NewItem.stTagCoord[1].fXPos=NewItem.stTagCoord[0].fXPos + NewItem.stTagCoord[0].fWidth + m_INameTextPadding;
				NewItem.stTagCoord[1].fWidth=m_fRainbowWidth - m_INameTextPadding;
				switch (CurrentTeam.m_Team[Y].m_eHealth)
				{
/*					case 0:
					NewItem.eStatus=NewItem.0;
					break;
					case 1:
					NewItem.eStatus=NewItem.1;
					break;
					case 2:
					NewItem.eStatus=NewItem.2;
					break;
					case 3:
					NewItem.eStatus=NewItem.3;
					break;
					default:*/
				}
				NewItem.stTagCoord[2].fXPos=NewItem.stTagCoord[1].fXPos + NewItem.stTagCoord[1].fWidth;
				NewItem.stTagCoord[2].fWidth=m_fHealthWidth;
				NewItem.iKills=CurrentTeam.m_Team[Y].m_iKills;
				NewItem.stTagCoord[3].fXPos=NewItem.stTagCoord[2].fXPos + NewItem.stTagCoord[2].fWidth;
				NewItem.stTagCoord[3].fWidth=m_fSkullWidth;
				if ( CurrentTeam.m_Team[Y].m_iBulletsFired > 0 )
				{
					NewItem.iEfficiency=Min(CurrentTeam.m_Team[Y].m_iBulletsHit / CurrentTeam.m_Team[Y].m_iBulletsFired * 100,100);
				}
				else
				{
					NewItem.iEfficiency=0;
				}
				NewItem.stTagCoord[4].fXPos=NewItem.stTagCoord[3].fXPos + NewItem.stTagCoord[3].fWidth;
				NewItem.stTagCoord[4].fWidth=m_fEfficiencyWidth;
				NewItem.iRoundsFired=CurrentTeam.m_Team[Y].m_iBulletsFired;
				NewItem.stTagCoord[5].fXPos=NewItem.stTagCoord[4].fXPos + NewItem.stTagCoord[4].fWidth;
				NewItem.stTagCoord[5].fWidth=m_fShotsWidth;
				NewItem.iRoundsHit=CurrentTeam.m_Team[Y].m_iBulletsHit;
				NewItem.stTagCoord[6].fXPos=NewItem.stTagCoord[5].fXPos + NewItem.stTagCoord[5].fWidth;
				NewItem.stTagCoord[6].fWidth=m_fHitsWidth;
				NewItem.m_iOperativeID=CurrentTeam.m_Team[Y].m_iOperativeID;
				m_iTotalRoundsFired += NewItem.iRoundsFired;
				m_iTotalRoundsTaken += NewItem.iRoundsHit;
				if ( bShowLog )
				{
					Log("CurrentTeam = " $ string(CurrentTeam) $ " y = " $ string(Y));
					Log("currentTeam.m_Team[y].m_CharacterName" @ CurrentTeam.m_Team[Y].m_CharacterName);
					Log("currentTeam.m_Team[y].m_eHealth" @ string(CurrentTeam.m_Team[Y].m_eHealth));
					Log("currentTeam.m_Team[y]. m_iKills" @ string(CurrentTeam.m_Team[Y].m_iKills));
					Log("currentTeam.m_Team[y].m_iBulletsFired" @ string(CurrentTeam.m_Team[Y].m_iBulletsFired));
					Log("currentTeam.m_Team[y].m_iBulletsHit" @ string(CurrentTeam.m_Team[Y].m_iBulletsHit));
					Log("NewItem.iEfficiency" @ string(NewItem.iEfficiency));
				}
				Y++;
				goto JL0096;
			}
		}
		i++;
		goto JL0059;
	}
	if ( m_iTotalRoundsFired == 0 )
	{
		m_iTotalEfficiency=0;
	}
	else
	{
		m_iTotalEfficiency=Min(m_iTotalRoundsTaken / m_iTotalRoundsFired * 100,100);
	}
}

function Register (UWindowDialogClientWindow W)
{
	NotifyWindow=W;
	Notify(0);
	m_IGPlayerInfoListBox.Register(W);
}

function ClearListOfItem ()
{
	m_IGPlayerInfoListBox.Items.Clear();
}

function float GetPlayerListBorderHeight ()
{
	return 16.00 + m_IFirstItempYOffset + 14 + 15;
}

function CreateIGPListBox ()
{
	m_IGPlayerInfoListBox=R6WindowSimpleIGPlayerListBox(CreateWindow(Class'R6WindowSimpleIGPlayerListBox',0.00,16.00 + m_IFirstItempYOffset,WinWidth,WinHeight - GetPlayerListBorderHeight(),self));
//	m_IGPlayerInfoListBox.SetCornerType(1);
	m_IGPlayerInfoListBox.m_Font=Root.Fonts[11];
}

function Resize ()
{
	m_IGPlayerInfoListBox.WinTop=16.00 + m_IFirstItempYOffset;
	m_IGPlayerInfoListBox.SetSize(WinWidth,WinHeight - GetPlayerListBorderHeight());
	m_TimeMissionTitle.WinWidth=m_fBottomTitleWidth;
	m_TimeMissionValue.WinLeft=m_TimeMissionTitle.WinWidth;
	m_TimeMissionValue.WinWidth=WinWidth - m_TimeMissionTitle.WinWidth;
	m_BottomTitle.WinWidth=m_fBottomTitleWidth;
	m_KillLabel.WinWidth=m_fSkullWidth;
	m_KillLabel.WinLeft=m_BottomTitle.WinLeft + m_BottomTitle.WinWidth;
	m_EfficiencyLabel.WinWidth=m_fEfficiencyWidth;
	m_EfficiencyLabel.WinLeft=m_KillLabel.WinLeft + m_KillLabel.WinWidth;
	m_RoundsFiredLabel.WinWidth=m_fShotsWidth;
	m_RoundsFiredLabel.WinLeft=m_EfficiencyLabel.WinLeft + m_EfficiencyLabel.WinWidth;
	m_RoundsTakenLabel.WinWidth=m_fHitsWidth;
	m_RoundsTakenLabel.WinLeft=m_RoundsFiredLabel.WinLeft + m_RoundsFiredLabel.WinWidth;
	m_TimeMissionTitle.WinWidth=m_fBottomTitleWidth;
	m_TimeMissionTitle.m_bRefresh=True;
	m_BottomTitle.WinWidth=m_fBottomTitleWidth;
	m_BottomTitle.m_bRefresh=True;
}

defaultproperties
{
    m_IBorderVOffset=2
    m_INameTextPadding=2
    m_fBottomTitleWidth=210.00
    m_fTeamcolorWidth=30.00
    m_fRainbowWidth=145.00
    m_fHealthWidth=35.00
    m_fSkullWidth=50.00
    m_fEfficiencyWidth=50.00
    m_fShotsWidth=50.00
    m_fHitsWidth=50.00
    m_RBorder=(X=74244,Y=570621952,W=1,H=0)
    m_RHighLight=(X=4923910,Y=570753024,W=35,H=74244)
}
/*
    m_TIcon=Texture'R6MenuTextures.TeamBarIcon'
    m_TBorder=Texture'UWindow.WhiteTexture'
    m_THighLight=Texture'R6MenuTextures.Gui_BoxScroll'
*/

