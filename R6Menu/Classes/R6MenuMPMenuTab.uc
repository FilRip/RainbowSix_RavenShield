//================================================================================
// R6MenuMPMenuTab.
//================================================================================
class R6MenuMPMenuTab extends UWindowDialogClientWindow;

var R6WindowTextLabelExt m_pGameModeText;
var R6WindowButtonBox m_pGameTypeDeadMatch;
var R6WindowButtonBox m_pGameTypeTDeadMatch;
var R6WindowButtonBox m_pGameTypeDisarmBomb;
var R6WindowButtonBox m_pGameTypeHostageAdv;
var R6WindowButtonBox m_pGameTypeEscort;
var R6WindowButtonBox m_pGameTypeMission;
var R6WindowButtonBox m_pGameTypeTerroHunt;
var R6WindowButtonBox m_pGameTypeHostageCoop;
var R6WindowTextLabelExt m_pFilterText;
var R6WindowButtonBox m_pFilterUnlock;
var R6WindowButtonBox m_pFilterFavorites;
var R6WindowButtonBox m_pFilterDedicated;
var R6WindowButtonBox m_pFilterNotEmpty;
var R6WindowButtonBox m_pFilterNotFull;
var R6WindowButtonBox m_pFilterResponding;
var R6WindowButtonBox m_pFilterSameVersion;
var R6WindowComboControl m_pFilterFasterThan;
var R6WindowTextLabelExt m_pServerInfo;
const C_fXPOS_LASTPOS= 419;
const C_fGM_COLUMNSWIDTH= 155;
const K_FSECOND_WINDOWHEIGHT= 90;
const K_HALFWINDOWWIDTH= 310;

function UpdateGameTypeFilter ()
{
	local R6MenuMultiPlayerWidget Menu;

	Menu=R6MenuMultiPlayerWidget(OwnerWindow);
	if ( m_pGameTypeDeadMatch != None )
	{
		m_pGameTypeDeadMatch.m_bSelected=Menu.m_LanServers.m_Filters.bDeathMatch;
		m_pGameTypeTDeadMatch.m_bSelected=Menu.m_LanServers.m_Filters.bTeamDeathMatch;
		m_pGameTypeDisarmBomb.m_bSelected=Menu.m_LanServers.m_Filters.bDisarmBomb;
		m_pGameTypeHostageAdv.m_bSelected=Menu.m_LanServers.m_Filters.bHostageRescueAdv;
		m_pGameTypeEscort.m_bSelected=Menu.m_LanServers.m_Filters.bEscortPilot;
		m_pGameTypeMission.m_bSelected=Menu.m_LanServers.m_Filters.bMission;
		m_pGameTypeTerroHunt.m_bSelected=Menu.m_LanServers.m_Filters.bTerroristHunt;
		m_pGameTypeHostageCoop.m_bSelected=Menu.m_LanServers.m_Filters.bHostageRescueCoop;
	}
	if ( m_pFilterResponding != None )
	{
		m_pFilterResponding.m_bSelected=Menu.m_LanServers.m_Filters.bResponding;
		m_pFilterUnlock.m_bSelected=Menu.m_LanServers.m_Filters.bUnlockedOnly;
		m_pFilterFavorites.m_bSelected=Menu.m_LanServers.m_Filters.bFavoritesOnly;
		m_pFilterDedicated.m_bSelected=Menu.m_LanServers.m_Filters.bDedicatedServersOnly;
		m_pFilterNotEmpty.m_bSelected=Menu.m_LanServers.m_Filters.bServersNotEmpty;
		m_pFilterNotFull.m_bSelected=Menu.m_LanServers.m_Filters.bServersNotFull;
		m_pFilterSameVersion.m_bSelected=Menu.m_LanServers.m_Filters.bSameVersion;
	}
}

function InitGameModeTab ()
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local Font ButtonFont;

	Class'Actor'.static.GetModMgr().RegisterObject(self);
	m_pGameModeText=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',0.00,0.00,2.00 * 310,90.00,self));
	m_pGameModeText.bAlwaysBehind=True;
	m_pGameModeText.ActiveBorder(0,False);
	m_pGameModeText.ActiveBorder(1,False);
	m_pGameModeText.SetBorderParam(2,155.00 * 2,1.00,1.00,Root.Colors.White);
	m_pGameModeText.m_Font=Root.Fonts[5];
	m_pGameModeText.m_vTextColor=Root.Colors.BlueLight;
//	m_pGameModeText.AddTextLabel(Caps(Localize("MultiPlayer","GameMode_Adversarial","R6Menu")),5.00,3.00,155.00 * 2,0,False);
//	m_pGameModeText.AddTextLabel(Caps(Localize("MultiPlayer","GameMode_Cooperative","R6Menu")),5.00 + 155 * 2,3.00,155.00 * 2,0,False);
	fXOffset=5.00;
	fYOffset=20.00;
	fYStep=25.00;
	fWidth=155.00;
	fHeight=14.00;
	ButtonFont=Root.Fonts[17];
	m_pGameTypeDeadMatch=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pGameTypeDeadMatch.m_TextFont=ButtonFont;
	m_pGameTypeDeadMatch.m_vTextColor=Root.Colors.White;
	m_pGameTypeDeadMatch.m_vBorder=Root.Colors.White;
//	m_pGameTypeDeadMatch.CreateTextAndBox(Localize("MultiPlayer","GameType_Death","R6Menu"),Localize("Tip","SrvGameType_Death","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).0);
	fYOffset += fYStep;
	m_pGameTypeTDeadMatch=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pGameTypeTDeadMatch.m_TextFont=ButtonFont;
	m_pGameTypeTDeadMatch.m_vTextColor=Root.Colors.White;
	m_pGameTypeTDeadMatch.m_vBorder=Root.Colors.White;
//	m_pGameTypeTDeadMatch.CreateTextAndBox(Localize("MultiPlayer","GameType_TeamDeath","R6Menu"),Localize("Tip","SrvGameType_TeamDeath","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).1);
	fYOffset += fYStep;
	m_pGameTypeDisarmBomb=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pGameTypeDisarmBomb.m_TextFont=ButtonFont;
	m_pGameTypeDisarmBomb.m_vTextColor=Root.Colors.White;
	m_pGameTypeDisarmBomb.m_vBorder=Root.Colors.White;
//	m_pGameTypeDisarmBomb.CreateTextAndBox(Localize("MultiPlayer","GameType_DisarmBomb","R6Menu"),Localize("Tip","SrvGameType_DisarmBomb","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).2);
	fXOffset=10.00 + 155;
	fYOffset=20.00;
	fWidth -= 20;
	m_pGameTypeHostageAdv=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pGameTypeHostageAdv.m_TextFont=ButtonFont;
	m_pGameTypeHostageAdv.m_vTextColor=Root.Colors.White;
	m_pGameTypeHostageAdv.m_vBorder=Root.Colors.White;
//	m_pGameTypeHostageAdv.CreateTextAndBox(Localize("MultiPlayer","GameType_HostageAdv","R6Menu"),Localize("Tip","SrvGameType_HostageAdv","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).3);
	fYOffset += fYStep;
	m_pGameTypeEscort=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pGameTypeEscort.m_TextFont=ButtonFont;
	m_pGameTypeEscort.m_vTextColor=Root.Colors.White;
	m_pGameTypeEscort.m_vBorder=Root.Colors.White;
//	m_pGameTypeEscort.CreateTextAndBox(Localize("MultiPlayer","GameType_EscortGeneral","R6Menu"),Localize("Tip","SrvGameType_EscortGeneral","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).4);
	fXOffset=5.00 + 155 * 2;
	fYOffset=20.00;
	m_pGameTypeMission=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pGameTypeMission.m_TextFont=ButtonFont;
	m_pGameTypeMission.m_vTextColor=Root.Colors.White;
	m_pGameTypeMission.m_vBorder=Root.Colors.White;
//	m_pGameTypeMission.CreateTextAndBox(Localize("MultiPlayer","GameType_Mission","R6Menu"),Localize("Tip","SrvGameType_Mission","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).5);
	fYOffset += fYStep;
	m_pGameTypeTerroHunt=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pGameTypeTerroHunt.m_TextFont=ButtonFont;
	m_pGameTypeTerroHunt.m_vTextColor=Root.Colors.White;
	m_pGameTypeTerroHunt.m_vBorder=Root.Colors.White;
//	m_pGameTypeTerroHunt.CreateTextAndBox(Localize("MultiPlayer","GameType_Terrorist","R6Menu"),Localize("Tip","SrvGameType_Terrorist","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).6);
	fXOffset=5.00 + 155 * 3;
	fYOffset=20.00;
	m_pGameTypeHostageCoop=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pGameTypeHostageCoop.m_TextFont=ButtonFont;
	m_pGameTypeHostageCoop.m_vTextColor=Root.Colors.White;
	m_pGameTypeHostageCoop.m_vBorder=Root.Colors.White;
//	m_pGameTypeHostageCoop.CreateTextAndBox(Localize("MultiPlayer","GameType_HostageCoop","R6Menu"),Localize("Tip","SrvGameType_HostageCoop","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).7);
	UpdateGameTypeFilter();
}

function InitFilterTab ()
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local Font ButtonFont;

	m_pFilterText=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',0.00,0.00,2.00 * 310,90.00,self));
	m_pFilterText.bAlwaysBehind=True;
	m_pFilterText.ActiveBorder(0,False);
	m_pFilterText.ActiveBorder(1,False);
	m_pFilterText.SetBorderParam(2,310.00,1.00,1.00,Root.Colors.GrayLight);
	m_pFilterText.ActiveBorder(3,False);
	fXOffset=5.00;
	fYOffset=7.00;
	fYStep=16.00;
	fWidth=310.00 - fXOffset - 30;
	fHeight=14.00;
	ButtonFont=Root.Fonts[17];
	m_pFilterText.m_Font=ButtonFont;
	m_pFilterText.m_vTextColor=Root.Colors.White;
	m_pFilterFavorites=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pFilterFavorites.m_TextFont=ButtonFont;
	m_pFilterFavorites.m_vTextColor=Root.Colors.White;
	m_pFilterFavorites.m_vBorder=Root.Colors.White;
//	m_pFilterFavorites.CreateTextAndBox(Localize("MultiPlayer","FilterMode_Favorites","R6Menu"),Localize("Tip","FilterMode_Favorites","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).11);
	fYOffset += fYStep;
	m_pFilterUnlock=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pFilterUnlock.m_TextFont=ButtonFont;
	m_pFilterUnlock.m_vTextColor=Root.Colors.White;
	m_pFilterUnlock.m_vBorder=Root.Colors.White;
//	m_pFilterUnlock.CreateTextAndBox(Localize("MultiPlayer","FilterMode_Unlocked","R6Menu"),Localize("Tip","FilterMode_Unlocked","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).10);
	fYOffset += fYStep;
	m_pFilterDedicated=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pFilterDedicated.m_TextFont=ButtonFont;
	m_pFilterDedicated.m_vTextColor=Root.Colors.White;
	m_pFilterDedicated.m_vBorder=Root.Colors.White;
//	m_pFilterDedicated.CreateTextAndBox(Localize("MultiPlayer","FilterMode_Dedicate","R6Menu"),Localize("Tip","FilterMode_Dedicate","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).12);
	fYOffset += fYStep;
	m_pFilterNotEmpty=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pFilterNotEmpty.m_TextFont=ButtonFont;
	m_pFilterNotEmpty.m_vTextColor=Root.Colors.White;
	m_pFilterNotEmpty.m_vBorder=Root.Colors.White;
//	m_pFilterNotEmpty.CreateTextAndBox(Localize("MultiPlayer","FilterMode_NotEmpty","R6Menu"),Localize("Tip","FilterMode_NotEmpty","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).13);
	fYOffset += fYStep;
	m_pFilterNotFull=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pFilterNotFull.m_TextFont=ButtonFont;
	m_pFilterNotFull.m_vTextColor=Root.Colors.White;
	m_pFilterNotFull.m_vBorder=Root.Colors.White;
//	m_pFilterNotFull.CreateTextAndBox(Localize("MultiPlayer","FilterMode_NotFull","R6Menu"),Localize("Tip","FilterMode_NotFull","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).14);
	fXOffset=5.00 + 310;
	fYOffset=7.00;
	fYStep=16.00;
	m_pFilterSameVersion=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pFilterSameVersion.m_TextFont=ButtonFont;
	m_pFilterSameVersion.m_vTextColor=Root.Colors.White;
	m_pFilterSameVersion.m_vBorder=Root.Colors.White;
//	m_pFilterSameVersion.CreateTextAndBox(Localize("MultiPlayer","FilterMode_SameVersion","R6Menu"),Localize("Tip","FilterMode_SameVersion","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).17);
	fYOffset += fYStep;
	m_pFilterResponding=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pFilterResponding.m_TextFont=ButtonFont;
	m_pFilterResponding.m_vTextColor=Root.Colors.White;
	m_pFilterResponding.m_vBorder=Root.Colors.White;
//	m_pFilterResponding.CreateTextAndBox(Localize("MultiPlayer","FilterMode_Respond","R6Menu"),Localize("Tip","FilterMode_Respond","R6Menu"),0.00,R6MenuMultiPlayerWidget(OwnerWindow).15);
	fYOffset += fYStep;
//	m_pFilterText.AddTextLabel(Localize("MultiPlayer","FilterMode_FasterThan","R6Menu"),fXOffset,fYOffset + 2,150.00,0,False);
	fXOffset=310.00 + 115;
	fWidth=165.00;
	m_pFilterFasterThan=R6WindowComboControl(CreateControl(Class'R6WindowComboControl',fXOffset,fYOffset,fWidth,fHeight));
	m_pFilterFasterThan.SetEditBoxTip(Localize("Tip","FilterMode_FasterThan","R6Menu"));
	m_pFilterFasterThan.EditBoxWidth=m_pFilterFasterThan.WinWidth;
	m_pFilterFasterThan.SetFont(6);
	m_pFilterFasterThan.List.MaxVisible=4;
	m_pFilterFasterThan.AddItem(Caps(Localize("MultiPlayer","FilterMode_FasterThanNone","R6Menu")));
	m_pFilterFasterThan.AddItem(Caps(Localize("MultiPlayer","FilterMode_FasterThan75","R6Menu")));
	m_pFilterFasterThan.AddItem(Caps(Localize("MultiPlayer","FilterMode_FasterThan100","R6Menu")));
	m_pFilterFasterThan.AddItem(Caps(Localize("MultiPlayer","FilterMode_FasterThan250","R6Menu")));
	m_pFilterFasterThan.AddItem(Caps(Localize("MultiPlayer","FilterMode_FasterThan350","R6Menu")));
	m_pFilterFasterThan.AddItem(Caps(Localize("MultiPlayer","FilterMode_FasterThan500","R6Menu")));
	m_pFilterFasterThan.AddItem(Caps(Localize("MultiPlayer","FilterMode_FasterThan1000","R6Menu")));
	switch (R6MenuMultiPlayerWidget(OwnerWindow).m_LanServers.m_Filters.iFasterThan)
	{
		case 75:
		m_pFilterFasterThan.SetValue(Caps(Localize("MultiPlayer","FilterMode_FasterThan75","R6Menu")));
		break;
		case 100:
		m_pFilterFasterThan.SetValue(Caps(Localize("MultiPlayer","FilterMode_FasterThan100","R6Menu")));
		break;
		case 250:
		m_pFilterFasterThan.SetValue(Caps(Localize("MultiPlayer","FilterMode_FasterThan250","R6Menu")));
		break;
		case 350:
		m_pFilterFasterThan.SetValue(Caps(Localize("MultiPlayer","FilterMode_FasterThan350","R6Menu")));
		break;
		case 500:
		m_pFilterFasterThan.SetValue(Caps(Localize("MultiPlayer","FilterMode_FasterThan500","R6Menu")));
		break;
		case 1000:
		m_pFilterFasterThan.SetValue(Caps(Localize("MultiPlayer","FilterMode_FasterThan1000","R6Menu")));
		break;
		default:
		R6MenuMultiPlayerWidget(OwnerWindow).m_LanServers.m_Filters.iFasterThan=0;
		m_pFilterFasterThan.SetValue(Caps(Localize("MultiPlayer","FilterMode_FasterThanNone","R6Menu")));
	}
}

function InitServerTab ()
{
	local float fWidth;
	local float fPreviousPos;

	fWidth=91.00;
	fPreviousPos=0.00;
	m_pServerInfo=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',0.00,0.00,WinWidth,12.00,self));
	m_pServerInfo.ActiveBorder(0,False);
	m_pServerInfo.SetBorderParam(1,2.00,0.00,1.00,Root.Colors.White);
	m_pServerInfo.ActiveBorder(2,False);
	m_pServerInfo.ActiveBorder(3,False);
//	m_pServerInfo.m_eCornerType=0;
	m_pServerInfo.m_Font=Root.Fonts[6];
	m_pServerInfo.m_vTextColor=Root.Colors.BlueLight;
	m_pServerInfo.m_vLineColor=Root.Colors.White;
//	m_pServerInfo.AddTextLabel(Localize("MultiPlayer","InfoBar_Name","R6Menu"),fPreviousPos,0.00,fWidth,2,True);
	fPreviousPos += fWidth;
	fWidth=40.00;
//	m_pServerInfo.AddTextLabel(Localize("MultiPlayer","InfoBar_Kills","R6Menu"),fPreviousPos,0.00,fWidth,2,True);
	fPreviousPos += fWidth;
	fWidth=50.00;
//	m_pServerInfo.AddTextLabel(Localize("MultiPlayer","InfoBar_Time","R6Menu"),fPreviousPos,0.00,fWidth,2,True);
	fPreviousPos += fWidth;
	fWidth=50.00;
//	m_pServerInfo.AddTextLabel(Localize("MultiPlayer","InfoBar_Ping","R6Menu"),fPreviousPos,0.00,fWidth,2,True);
	fPreviousPos += fWidth;
	fWidth=82.00;
//	m_pServerInfo.AddTextLabel(Localize("MultiPlayer","InfoBar_MapList","R6Menu"),fPreviousPos,0.00,fWidth,2,True);
	fPreviousPos += fWidth;
	fWidth=92.00;
//	m_pServerInfo.AddTextLabel(Localize("MultiPlayer","InfoBar_Type","R6Menu"),fPreviousPos,0.00,fWidth,2,True);
	fPreviousPos += fWidth;
	fWidth=150.00;
//	m_pServerInfo.AddTextLabel(Localize("MultiPlayer","InfoBar_ServerOptions","R6Menu"),fPreviousPos,0.00,fWidth,2,True);
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( C.IsA('R6WindowComboControl') )
	{
		ManageR6ComboControlNotify(C,E);
	}
	else
	{
		if ( C.IsA('R6WindowButtonBox') )
		{
			ManageR6ButtonBoxNotify(C,E);
		}
	}
}

function ManageR6ComboControlNotify (UWindowDialogControl C, byte E)
{
	if ( E == 1 )
	{
		R6MenuMultiPlayerWidget(OwnerWindow).SetServerFilterFasterThan(int(R6WindowComboControl(C).GetValue()));
	}
}

function ManageR6ButtonBoxNotify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		if ( R6WindowButtonBox(C).GetSelectStatus() )
		{
			R6WindowButtonBox(C).m_bSelected= !R6WindowButtonBox(C).m_bSelected;
			if ( R6MenuMultiPlayerWidget(OwnerWindow) != None )
			{
				R6MenuMultiPlayerWidget(OwnerWindow).SetServerFilterBooleans(R6WindowButtonBox(C).m_iButtonID,R6WindowButtonBox(C).m_bSelected);
			}
		}
	}
}
