//================================================================================
// R6MenuMPRestKitMain.
//================================================================================
class R6MenuMPRestKitMain extends UWindowDialogClientWindow;

var bool m_bUpdateInBetRound;
var bool m_bUpdateGameProgress;
var bool m_bImAnAdmin;
var R6MenuButtonsDefines m_pButtonsDef;
var R6MenuSimpleWindow m_pRestKitOptFakeW;
var R6WindowTextLabelExt m_pKitText;
var R6WindowButtonBox m_pKitSubMachinesGuns;
var R6WindowButtonBox m_pKitShotGuns;
var R6WindowButtonBox m_pKitAssaultRifles;
var R6WindowButtonBox m_pKitMachinesGuns;
var R6WindowButtonBox m_pKitSniperRifles;
var R6WindowButtonBox m_pKitPistols;
var R6WindowButtonBox m_pKitMachinePistols;
var R6WindowButtonBox m_pKitPrimaryWeapon;
var R6WindowButtonBox m_pKitSecWeapon;
var R6WindowButtonBox m_pKitMisc;
var R6MenuMPRestKitSub m_pSubMachinesGunsTab;
var R6MenuMPRestKitSub m_pShotgunsTab;
var R6MenuMPRestKitSub m_pAssaultRifleTab;
var R6MenuMPRestKitSub m_pMachineGunsTab;
var R6MenuMPRestKitSub m_pSniperRifleTab;
var R6MenuMPRestKitSub m_pPistolTab;
var R6MenuMPRestKitSub m_pMachinePistolTab;
var R6MenuMPRestKitSub m_pPriWpnGadgetTab;
var R6MenuMPRestKitSub m_pSecWpnGadgetTab;
var R6MenuMPRestKitSub m_pMiscGadgetTab;
var R6MenuMPRestKitSub m_pCurrentSubKit;
var array<string> m_SrvRestSubMachineGunsACopy;
var array<string> m_SrvRestShotGunsACopy;
var array<string> m_SrvRestAssultRiflesACopy;
var array<string> m_SrvRestMachineGunsACopy;
var array<string> m_SrvRestSniperRiflesACopy;
var array<string> m_SrvRestPistolsACopy;
var array<string> m_SrvRestMachinePistolsACopy;
var array<string> m_SrvRestPrimaryACopy;
var array<string> m_SrvRestSecondaryACopy;
var array<string> m_SrvRestMiscGadgetsACopy;
var string m_ATextBoxLoc[2];
const K_HALFWINDOWWIDTH= 310;

function CreateKitRestriction ()
{
	local string szTemp;
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local Font ButtonFont;
	local bool bInGame;
	local R6GameReplicationInfo pGameRepInfo;

	GetR6GameReplicationInfo(pGameRepInfo);
	m_pKitText=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',0.00,0.00,2.00 * 310,WinHeight,self));
	m_pKitText.bAlwaysBehind=True;
	m_pKitText.ActiveBorder(0,False);
	m_pKitText.ActiveBorder(1,False);
	m_pKitText.SetBorderParam(2,310.00,1.00,1.00,Root.Colors.White);
	m_pKitText.ActiveBorder(3,False);
	m_pKitText.m_Font=Root.Fonts[5];
	m_pKitText.m_vTextColor=Root.Colors.White;
	fXOffset=3.00;
	fYOffset=5.00;
	fWidth=310.00;
//	m_pKitText.AddTextLabel(Localize("MPCreateGame","Kit_PrimaryWeapon","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fYOffset=125.00;
//	m_pKitText.AddTextLabel(Localize("MPCreateGame","Kit_SecWeapon","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fYOffset=200.00;
//	m_pKitText.AddTextLabel(Localize("MPCreateGame","Kit_Gadgets","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	ButtonFont=Root.Fonts[5];
	fXOffset=5.00;
	fYOffset=20.00;
	fWidth=310.00 - fXOffset - 10;
	fYStep=15.00;
	fHeight=15.00;
	m_ATextBoxLoc[0]=Localize("MultiPlayer","BoutonMsgBox","R6Menu");
	m_ATextBoxLoc[1]=Localize("MultiPlayer","BoutonMsgBoxInGame","R6Menu");
	bInGame=False;
	if ( pGameRepInfo != None )
	{
		bInGame=True;
	}
	m_pKitSubMachinesGuns=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pKitSubMachinesGuns.m_TextFont=ButtonFont;
	m_pKitSubMachinesGuns.m_vTextColor=Root.Colors.White;
	m_pKitSubMachinesGuns.m_vBorder=Root.Colors.White;
//	m_pKitSubMachinesGuns.m_eButtonType=2;
	szTemp=Localize("Tip","Kit_SubMachGuns","R6Menu");
	if ( pGameRepInfo != None )
	{
		szTemp="";
	}
	m_pKitSubMachinesGuns.CreateTextAndMsgBox(Localize("MPCreateGame","Kit_SubMachGuns","R6Menu"),szTemp,m_ATextBoxLoc[0],0.00,0);
	fYOffset += fYStep;
	m_pKitShotGuns=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pKitShotGuns.m_TextFont=ButtonFont;
	m_pKitShotGuns.m_vTextColor=Root.Colors.White;
	m_pKitShotGuns.m_vBorder=Root.Colors.White;
//	m_pKitShotGuns.m_eButtonType=2;
	szTemp=Localize("Tip","Kit_ShotGun","R6Menu");
	if ( pGameRepInfo != None )
	{
		szTemp="";
	}
	m_pKitShotGuns.CreateTextAndMsgBox(Localize("MPCreateGame","Kit_ShotGun","R6Menu"),szTemp,m_ATextBoxLoc[0],0.00,1);
	fYOffset += fYStep;
	m_pKitAssaultRifles=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pKitAssaultRifles.m_TextFont=ButtonFont;
	m_pKitAssaultRifles.m_vTextColor=Root.Colors.White;
	m_pKitAssaultRifles.m_vBorder=Root.Colors.White;
//	m_pKitAssaultRifles.m_eButtonType=2;
	szTemp=Localize("Tip","Kit_Assault","R6Menu");
	if ( pGameRepInfo != None )
	{
		szTemp="";
	}
	m_pKitAssaultRifles.CreateTextAndMsgBox(Localize("MPCreateGame","Kit_Assault","R6Menu"),szTemp,m_ATextBoxLoc[0],0.00,2);
	fYOffset += fYStep;
	m_pKitMachinesGuns=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pKitMachinesGuns.m_TextFont=ButtonFont;
	m_pKitMachinesGuns.m_vTextColor=Root.Colors.White;
	m_pKitMachinesGuns.m_vBorder=Root.Colors.White;
//	m_pKitMachinesGuns.m_eButtonType=2;
	szTemp=Localize("Tip","Kit_MachGuns","R6Menu");
	if ( pGameRepInfo != None )
	{
		szTemp="";
	}
	m_pKitMachinesGuns.CreateTextAndMsgBox(Localize("MPCreateGame","Kit_MachGuns","R6Menu"),szTemp,m_ATextBoxLoc[0],0.00,3);
	fYOffset += fYStep;
	m_pKitSniperRifles=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pKitSniperRifles.m_TextFont=ButtonFont;
	m_pKitSniperRifles.m_vTextColor=Root.Colors.White;
	m_pKitSniperRifles.m_vBorder=Root.Colors.White;
//	m_pKitSniperRifles.m_eButtonType=2;
	szTemp=Localize("Tip","Kit_Sniper","R6Menu");
	if ( pGameRepInfo != None )
	{
		szTemp="";
	}
	m_pKitSniperRifles.CreateTextAndMsgBox(Localize("MPCreateGame","Kit_Sniper","R6Menu"),szTemp,m_ATextBoxLoc[0],0.00,4);
	fYOffset=140.00;
	m_pKitPistols=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pKitPistols.m_TextFont=ButtonFont;
	m_pKitPistols.m_vTextColor=Root.Colors.White;
	m_pKitPistols.m_vBorder=Root.Colors.White;
//	m_pKitPistols.m_eButtonType=2;
	szTemp=Localize("Tip","Kit_Pistols","R6Menu");
	if ( pGameRepInfo != None )
	{
		szTemp="";
	}
	m_pKitPistols.CreateTextAndMsgBox(Localize("MPCreateGame","Kit_Pistols","R6Menu"),szTemp,m_ATextBoxLoc[0],0.00,5);
	fYOffset += fYStep;
	m_pKitMachinePistols=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pKitMachinePistols.m_TextFont=ButtonFont;
	m_pKitMachinePistols.m_vTextColor=Root.Colors.White;
	m_pKitMachinePistols.m_vBorder=Root.Colors.White;
//	m_pKitMachinePistols.m_eButtonType=2;
	szTemp=Localize("Tip","Kit_MachPistols","R6Menu");
	if ( pGameRepInfo != None )
	{
		szTemp="";
	}
	m_pKitMachinePistols.CreateTextAndMsgBox(Localize("MPCreateGame","Kit_MachPistols","R6Menu"),szTemp,m_ATextBoxLoc[0],0.00,6);
	fYOffset=215.00;
	m_pKitPrimaryWeapon=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pKitPrimaryWeapon.m_TextFont=ButtonFont;
	m_pKitPrimaryWeapon.m_vTextColor=Root.Colors.White;
	m_pKitPrimaryWeapon.m_vBorder=Root.Colors.White;
//	m_pKitPrimaryWeapon.m_eButtonType=2;
	szTemp=Localize("Tip","Kit_PrimaryWeaponMin","R6Menu");
	if ( pGameRepInfo != None )
	{
		szTemp="";
	}
	m_pKitPrimaryWeapon.CreateTextAndMsgBox(Localize("MPCreateGame","Kit_PrimaryWeaponMin","R6Menu"),szTemp,m_ATextBoxLoc[0],0.00,7);
	fYOffset += fYStep;
	m_pKitSecWeapon=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pKitSecWeapon.m_TextFont=ButtonFont;
	m_pKitSecWeapon.m_vTextColor=Root.Colors.White;
	m_pKitSecWeapon.m_vBorder=Root.Colors.White;
//	m_pKitSecWeapon.m_eButtonType=2;
	szTemp=Localize("Tip","Kit_SecWeaponMin","R6Menu");
	if ( pGameRepInfo != None )
	{
		szTemp="";
	}
	m_pKitSecWeapon.CreateTextAndMsgBox(Localize("MPCreateGame","Kit_SecWeaponMin","R6Menu"),szTemp,m_ATextBoxLoc[0],0.00,8);
	fYOffset += fYStep;
	m_pKitMisc=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pKitMisc.m_TextFont=ButtonFont;
	m_pKitMisc.m_vTextColor=Root.Colors.White;
	m_pKitMisc.m_vBorder=Root.Colors.White;
//	m_pKitMisc.m_eButtonType=2;
	szTemp=Localize("Tip","Kit_Misc","R6Menu");
	if ( pGameRepInfo != None )
	{
		szTemp="";
	}
	m_pKitMisc.CreateTextAndMsgBox(Localize("MPCreateGame","Kit_Misc","R6Menu"),szTemp,m_ATextBoxLoc[0],0.00,9);
	if (  !bInGame )
	{
		Class'Actor'.static.GetModMgr().RegisterObject(self);
	}
	InitMod();
}

function InitMod ()
{
	local R6GameReplicationInfo pGameRepInfo;
	local float fXOffset;
	local float fYOffset;
	local float fWidth;
	local float fHeight;
	local bool bInGame;

	fXOffset=310.00;
	fYOffset=0.00;
	fWidth=310.00;
	fHeight=WinHeight;
	GetR6GameReplicationInfo(pGameRepInfo);
	bInGame=False;
	if ( pGameRepInfo != None )
	{
		bInGame=True;
	}
	m_pSubMachinesGunsTab=R6MenuMPRestKitSub(CreateWindow(Class'R6MenuMPRestKitSub',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pSubMachinesGunsTab.InitSelectButtons(bInGame);
	m_pSubMachinesGunsTab.InitSubMachineGunsTab(pGameRepInfo);
	m_pSubMachinesGunsTab.HideWindow();
	m_pShotgunsTab=R6MenuMPRestKitSub(CreateWindow(Class'R6MenuMPRestKitSub',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pShotgunsTab.InitSelectButtons(bInGame);
	m_pShotgunsTab.InitShotGunsTab(pGameRepInfo);
	m_pShotgunsTab.HideWindow();
	m_pAssaultRifleTab=R6MenuMPRestKitSub(CreateWindow(Class'R6MenuMPRestKitSub',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pAssaultRifleTab.InitSelectButtons(bInGame);
	m_pAssaultRifleTab.InitAssaultRifleTab(pGameRepInfo);
	m_pAssaultRifleTab.HideWindow();
	m_pMachineGunsTab=R6MenuMPRestKitSub(CreateWindow(Class'R6MenuMPRestKitSub',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pMachineGunsTab.InitSelectButtons(bInGame);
	m_pMachineGunsTab.InitMachineGunsTab(pGameRepInfo);
	m_pMachineGunsTab.HideWindow();
	m_pSniperRifleTab=R6MenuMPRestKitSub(CreateWindow(Class'R6MenuMPRestKitSub',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pSniperRifleTab.InitSelectButtons(bInGame);
	m_pSniperRifleTab.InitSniperRifleTab(pGameRepInfo);
	m_pSniperRifleTab.HideWindow();
	m_pPistolTab=R6MenuMPRestKitSub(CreateWindow(Class'R6MenuMPRestKitSub',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pPistolTab.InitSelectButtons(bInGame);
	m_pPistolTab.InitPistolTab(pGameRepInfo);
	m_pPistolTab.HideWindow();
	m_pMachinePistolTab=R6MenuMPRestKitSub(CreateWindow(Class'R6MenuMPRestKitSub',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pMachinePistolTab.InitSelectButtons(bInGame);
	m_pMachinePistolTab.InitMachinePistolTab(pGameRepInfo);
	m_pMachinePistolTab.HideWindow();
	m_pPriWpnGadgetTab=R6MenuMPRestKitSub(CreateWindow(Class'R6MenuMPRestKitSub',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pPriWpnGadgetTab.InitSelectButtons(bInGame);
	m_pPriWpnGadgetTab.InitPriWpnGadgetTab(pGameRepInfo);
	m_pPriWpnGadgetTab.HideWindow();
	m_pSecWpnGadgetTab=R6MenuMPRestKitSub(CreateWindow(Class'R6MenuMPRestKitSub',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pSecWpnGadgetTab.InitSelectButtons(bInGame);
	m_pSecWpnGadgetTab.InitSecWpnGadgetTab(pGameRepInfo);
	m_pSecWpnGadgetTab.HideWindow();
	m_pMiscGadgetTab=R6MenuMPRestKitSub(CreateWindow(Class'R6MenuMPRestKitSub',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pMiscGadgetTab.InitSelectButtons(bInGame);
	m_pMiscGadgetTab.InitMiscGadgetTab(pGameRepInfo);
	m_pMiscGadgetTab.HideWindow();
	m_pRestKitOptFakeW=R6MenuSimpleWindow(CreateWindow(Class'R6MenuSimpleWindow',WinWidth * 0.50,0.00,WinWidth * 0.50,WinHeight,self));
	m_pRestKitOptFakeW.bAlwaysOnTop=True;
	m_pRestKitOptFakeW.m_bDrawSimpleBorder=False;
	m_pRestKitOptFakeW.pAdviceParent=self;
	if ( bInGame )
	{
		Refresh();
		m_pSubMachinesGunsTab.m_pRestKitButList.m_VertSB.WinLeft -= 1;
		m_pShotgunsTab.m_pRestKitButList.m_VertSB.WinLeft -= 1;
		m_pAssaultRifleTab.m_pRestKitButList.m_VertSB.WinLeft -= 1;
		m_pMachineGunsTab.m_pRestKitButList.m_VertSB.WinLeft -= 1;
		m_pSniperRifleTab.m_pRestKitButList.m_VertSB.WinLeft -= 1;
		m_pPistolTab.m_pRestKitButList.m_VertSB.WinLeft -= 1;
		m_pMachinePistolTab.m_pRestKitButList.m_VertSB.WinLeft -= 1;
		m_pPriWpnGadgetTab.m_pRestKitButList.m_VertSB.WinLeft -= 1;
		m_pSecWpnGadgetTab.m_pRestKitButList.m_VertSB.WinLeft -= 1;
		m_pMiscGadgetTab.m_pRestKitButList.m_VertSB.WinLeft -= 1;
	}
	else
	{
		m_pRestKitOptFakeW.HideWindow();
		RefreshCreateGameKitRest();
		if ( m_pCurrentSubKit != None )
		{
			m_pCurrentSubKit.HideWindow();
		}
	}
}

function RefreshCreateGameKitRest ()
{
	m_pSubMachinesGunsTab.UpdateSubMachineGunsTab(None);
	m_pShotgunsTab.UpdateShotGunsTab(None);
	m_pAssaultRifleTab.UpdateAssaultRifleTab(None);
	m_pMachineGunsTab.UpdateMachineGunsTab(None);
	m_pSniperRifleTab.UpdateSniperRifleTab(None);
	m_pPistolTab.UpdatePistolsTab(None);
	m_pMachinePistolTab.UpdateMachinePistolTab(None);
	m_pPriWpnGadgetTab.UpdatePriWpnGadgetTab(None);
	m_pSecWpnGadgetTab.UpdateSecWpnGadgetTab(None);
	m_pMiscGadgetTab.UpdateMiscGadgetTab(None);
}

function Refresh ()
{
	local string szTextBox;

/*	if ( R6PlayerController(GetPlayerOwner()).CheckAuthority(R6PlayerController(GetPlayerOwner()).1) )
	{
		if ( m_bImAnAdmin == False )
		{
			m_bImAnAdmin=True;
			R6PlayerController(GetPlayerOwner()).ServerPausePreGameRoundTime();
		}
		szTextBox=m_ATextBoxLoc[0];
		m_pRestKitOptFakeW.HideWindow();
	}
	else
	{
		m_bImAnAdmin=False;
		szTextBox=m_ATextBoxLoc[1];
		m_pRestKitOptFakeW.ShowWindow();
	}*/
	m_pKitSubMachinesGuns.ModifyMsgBox(szTextBox);
	m_pKitShotGuns.ModifyMsgBox(szTextBox);
	m_pKitAssaultRifles.ModifyMsgBox(szTextBox);
	m_pKitMachinesGuns.ModifyMsgBox(szTextBox);
	m_pKitSniperRifles.ModifyMsgBox(szTextBox);
	m_pKitPistols.ModifyMsgBox(szTextBox);
	m_pKitMachinePistols.ModifyMsgBox(szTextBox);
	m_pKitPrimaryWeapon.ModifyMsgBox(szTextBox);
	m_pKitSecWeapon.ModifyMsgBox(szTextBox);
	m_pKitMisc.ModifyMsgBox(szTextBox);
	m_pSubMachinesGunsTab.RefreshSubKit(m_bImAnAdmin);
	m_pShotgunsTab.RefreshSubKit(m_bImAnAdmin);
	m_pAssaultRifleTab.RefreshSubKit(m_bImAnAdmin);
	m_pMachineGunsTab.RefreshSubKit(m_bImAnAdmin);
	m_pSniperRifleTab.RefreshSubKit(m_bImAnAdmin);
	m_pPistolTab.RefreshSubKit(m_bImAnAdmin);
	m_pMachinePistolTab.RefreshSubKit(m_bImAnAdmin);
	m_pPriWpnGadgetTab.RefreshSubKit(m_bImAnAdmin);
	m_pSecWpnGadgetTab.RefreshSubKit(m_bImAnAdmin);
	m_pMiscGadgetTab.RefreshSubKit(m_bImAnAdmin);
}

function RefreshKitRest ()
{
	local R6GameReplicationInfo pGameRepInfo;
	local R6MenuInGameMultiPlayerRootWindow R6CurrentRoot;

	R6CurrentRoot=R6MenuInGameMultiPlayerRootWindow(Root);
	pGameRepInfo=R6GameReplicationInfo(R6MenuInGameMultiPlayerRootWindow(Root).m_R6GameMenuCom.m_GameRepInfo);
	m_pSubMachinesGunsTab.UpdateSubMachineGunsTab(pGameRepInfo);
	m_pShotgunsTab.UpdateShotGunsTab(pGameRepInfo);
	m_pAssaultRifleTab.UpdateAssaultRifleTab(pGameRepInfo);
	m_pMachineGunsTab.UpdateMachineGunsTab(pGameRepInfo);
	m_pSniperRifleTab.UpdateSniperRifleTab(pGameRepInfo);
	m_pPistolTab.UpdatePistolsTab(pGameRepInfo);
	m_pMachinePistolTab.UpdateMachinePistolTab(pGameRepInfo);
	m_pPriWpnGadgetTab.UpdatePriWpnGadgetTab(pGameRepInfo);
	m_pSecWpnGadgetTab.UpdateSecWpnGadgetTab(pGameRepInfo);
	m_pMiscGadgetTab.UpdateMiscGadgetTab(pGameRepInfo);
	CopyStaticAToDynA(pGameRepInfo.m_szSubMachineGunsRes,m_SrvRestSubMachineGunsACopy);
	CopyStaticAToDynA(pGameRepInfo.m_szShotGunRes,m_SrvRestShotGunsACopy);
	CopyStaticAToDynA(pGameRepInfo.m_szAssRifleRes,m_SrvRestAssultRiflesACopy);
	CopyStaticAToDynA(pGameRepInfo.m_szMachGunRes,m_SrvRestMachineGunsACopy);
	CopyStaticAToDynA(pGameRepInfo.m_szSnipRifleRes,m_SrvRestSniperRiflesACopy);
	CopyStaticAToDynA(pGameRepInfo.m_szPistolRes,m_SrvRestPistolsACopy);
	CopyStaticAToDynA(pGameRepInfo.m_szMachPistolRes,m_SrvRestMachinePistolsACopy);
	CopyStaticAToDynA(pGameRepInfo.m_szGadgPrimaryRes,m_SrvRestPrimaryACopy);
	CopyStaticAToDynA(pGameRepInfo.m_szGadgSecondayRes,m_SrvRestSecondaryACopy);
	CopyStaticAToDynA(pGameRepInfo.m_szGadgMiscRes,m_SrvRestMiscGadgetsACopy);
}

function CopyStaticAToDynA (string _ASrvRest[32], out array<string> _ASrvRestCopy)
{
	local int i;

	_ASrvRestCopy.Remove (0,_ASrvRestCopy.Length);
	i=0;
JL0014:
	if ( (_ASrvRest[i] != "") && (i < 32) )
	{
		_ASrvRestCopy[i]=_ASrvRest[i];
		i++;
		goto JL0014;
	}
}

function bool SendNewRestrictionsKit ()
{
	local R6GameReplicationInfo R6GameRepInfo;
	local bool bSettingsChange;

	R6GameRepInfo=R6GameReplicationInfo(R6MenuInGameMultiPlayerRootWindow(Root).m_R6GameMenuCom.m_GameRepInfo);
/*	bSettingsChange=CompareARestKit(0,m_SrvRestSubMachineGunsACopy,m_pSubMachinesGunsTab.m_ASubMachineGuns,m_pSubMachinesGunsTab.m_pSubMachineGuns);
	bSettingsChange=CompareARestKit(1,m_SrvRestShotGunsACopy,m_pShotgunsTab.m_AShotguns,m_pShotgunsTab.m_pShotguns) || bSettingsChange;
	bSettingsChange=CompareARestKit(2,m_SrvRestAssultRiflesACopy,m_pAssaultRifleTab.m_AAssaultRifle,m_pAssaultRifleTab.m_pAssaultRifle) || bSettingsChange;
	bSettingsChange=CompareARestKit(3,m_SrvRestMachineGunsACopy,m_pMachineGunsTab.m_AMachineGuns,m_pMachineGunsTab.m_pMachineGuns) || bSettingsChange;
	bSettingsChange=CompareARestKit(4,m_SrvRestSniperRiflesACopy,m_pSniperRifleTab.m_ASniperRifle,m_pSniperRifleTab.m_pSniperRifle) || bSettingsChange;
	bSettingsChange=CompareARestKit(5,m_SrvRestPistolsACopy,m_pPistolTab.m_APistol,m_pPistolTab.m_pPistol) || bSettingsChange;
	bSettingsChange=CompareARestKit(6,m_SrvRestMachinePistolsACopy,m_pMachinePistolTab.m_AMachinePistol,m_pMachinePistolTab.m_pMachinePistol) || bSettingsChange;
	bSettingsChange=CompareARestKit(7,m_SrvRestPrimaryACopy,m_pPriWpnGadgetTab.m_APriWpnGadget,m_pPriWpnGadgetTab.m_pPriWpnGadget,True) || bSettingsChange;
	bSettingsChange=CompareARestKit(8,m_SrvRestSecondaryACopy,m_pSecWpnGadgetTab.m_ASecWpnGadget,m_pSecWpnGadgetTab.m_pSecWpnGadget,True) || bSettingsChange;
	bSettingsChange=CompareARestKit(9,m_SrvRestMiscGadgetsACopy,m_pMiscGadgetTab.m_AMiscGadget,m_pMiscGadgetTab.m_pMiscGadget,True) || bSettingsChange;*/
	Log("SendNewRestrictionsKit --> bSettingsChange: " $ string(bSettingsChange));
	return bSettingsChange;
}

function bool CompareARestKit (ERestKitID _eRestKitID, out array<string> _ANextSrvRestriction, array<Class> _ACurServerRestKit, R6WindowButtonBox _pAButtonBox[20], optional bool _bStringArray)
{
	local array<Class> ARestToRemove;
	local array<Class> ARestToAdd;
	local array<string> szAOldCopyOfSrvRest;
	local int i;
	local int j;
	local int iTotOldMenuRest;
	local int iRestToRemove;
	local int iRestToAdd;
	local bool bSettingsChange;
	local bool bFindRes;

	i=0;
JL0007:
	if ( i < _ANextSrvRestriction.Length )
	{
		szAOldCopyOfSrvRest[i]=_ANextSrvRestriction[i];
		i++;
		goto JL0007;
	}
	iTotOldMenuRest=i;
	_ANextSrvRestriction.Remove (0,_ANextSrvRestriction.Length);
	iRestToRemove=0;
	iRestToAdd=0;
	i=0;
JL0065:
	if ( i < 20 )
	{
		if ( _pAButtonBox[i] == None )
		{
			goto JL01CA;
		}
		if ( _pAButtonBox[i].m_bSelected )
		{
			_ANextSrvRestriction[iRestToAdd]=Class<R6Description>(_ACurServerRestKit[i]).Default.m_NameID;
			bFindRes=False;
			j=0;
JL00D1:
			if ( j < iTotOldMenuRest )
			{
				if ( _ANextSrvRestriction[iRestToAdd] == szAOldCopyOfSrvRest[j] )
				{
					szAOldCopyOfSrvRest.Remove (j,1);
					iTotOldMenuRest--;
					bFindRes=True;
				}
				else
				{
					j++;
					goto JL00D1;
				}
			}
			iRestToAdd++;
			if (  !bFindRes )
			{
				bSettingsChange=True;
				if ( _bStringArray )
				{
//					R6PlayerController(GetPlayerOwner()).ServerNewKitRestSettings(_eRestKitID,False,,_pAButtonBox[i].m_szMiscText);
				}
				else
				{
//					R6PlayerController(GetPlayerOwner()).ServerNewKitRestSettings(_eRestKitID,False,_ACurServerRestKit[i]);
				}
			}
		}
		else
		{
			ARestToRemove[iRestToRemove]=_ACurServerRestKit[i];
			iRestToRemove++;
		}
		i++;
		goto JL0065;
	}
JL01CA:
	if ( iTotOldMenuRest > 0 )
	{
		i=0;
JL01DC:
		if ( i < ARestToRemove.Length )
		{
			bSettingsChange=True;
			if ( _bStringArray )
			{
//				R6PlayerController(GetPlayerOwner()).ServerNewKitRestSettings(_eRestKitID,True,,Class<R6Description>(ARestToRemove[i]).Default.m_NameID);
			}
			else
			{
//				R6PlayerController(GetPlayerOwner()).ServerNewKitRestSettings(_eRestKitID,True,ARestToRemove[i]);
			}
			i++;
			goto JL01DC;
		}
	}
	return bSettingsChange;
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		if ( C.IsA('R6WindowButtonBox') )
		{
			ManageR6ButtonBoxNotify(C);
		}
	}
}

function ManageR6ButtonBoxNotify (UWindowDialogControl C)
{
	local R6GameReplicationInfo pGameRepInfo;

	if ( m_pSubMachinesGunsTab != None )
	{
		GetR6GameReplicationInfo(pGameRepInfo);
		if ( m_pCurrentSubKit != None )
		{
			m_pCurrentSubKit.HideWindow();
		}
		switch (R6WindowButtonBox(C))
		{
			case m_pKitSubMachinesGuns:
			m_pCurrentSubKit=m_pSubMachinesGunsTab;
			break;
			case m_pKitShotGuns:
			m_pCurrentSubKit=m_pShotgunsTab;
			break;
			case m_pKitAssaultRifles:
			m_pCurrentSubKit=m_pAssaultRifleTab;
			break;
			case m_pKitMachinesGuns:
			m_pCurrentSubKit=m_pMachineGunsTab;
			break;
			case m_pKitSniperRifles:
			m_pCurrentSubKit=m_pSniperRifleTab;
			break;
			case m_pKitPistols:
			m_pCurrentSubKit=m_pPistolTab;
			break;
			case m_pKitMachinePistols:
			m_pCurrentSubKit=m_pMachinePistolTab;
			break;
			case m_pKitPrimaryWeapon:
			m_pCurrentSubKit=m_pPriWpnGadgetTab;
			break;
			case m_pKitSecWeapon:
			m_pCurrentSubKit=m_pSecWpnGadgetTab;
			break;
			case m_pKitMisc:
			m_pCurrentSubKit=m_pMiscGadgetTab;
			break;
			default:
		}
	}
	if ( m_pCurrentSubKit != None )
	{
		m_pCurrentSubKit.ShowWindow();
	}
}

function GetR6GameReplicationInfo (out R6GameReplicationInfo pGameRepInfo)
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	if ( (r6Root != None) && (r6Root.m_R6GameMenuCom != None) && (R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo) != None) )
	{
		pGameRepInfo=R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo);
	}
	else
	{
		pGameRepInfo=None;
	}
}

function Tick (float _fDelta)
{
	if ( m_pCurrentSubKit != None )
	{
		if ( m_pRestKitOptFakeW.bWindowVisible )
		{
			if ( m_pCurrentSubKit.m_pRestKitButList.m_VertSB.isHidden() )
			{
				m_pRestKitOptFakeW.WinWidth=WinWidth * 0.50;
			}
			else
			{
				m_pRestKitOptFakeW.WinWidth=WinWidth * 0.50 - LookAndFeel.Size_ScrollbarWidth;
			}
		}
	}
}

function MouseWheelDown (float X, float Y)
{
	if ( m_pCurrentSubKit != None )
	{
		m_pCurrentSubKit.m_pRestKitButList.MouseWheelDown(X,Y);
	}
}

function MouseWheelUp (float X, float Y)
{
	if ( m_pCurrentSubKit != None )
	{
		m_pCurrentSubKit.m_pRestKitButList.MouseWheelUp(X,Y);
	}
}
