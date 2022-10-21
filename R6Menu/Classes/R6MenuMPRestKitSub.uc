//================================================================================
// R6MenuMPRestKitSub.
//================================================================================
class R6MenuMPRestKitSub extends UWindowDialogClientWindow;

var bool m_bIsInGame;
var R6WindowButton m_pSelectAll;
var R6WindowButton m_pUnSelectAll;
var R6WindowButtonBox m_pSubMachineGuns[20];
var R6WindowButtonBox m_pShotguns[20];
var R6WindowButtonBox m_pAssaultRifle[20];
var R6WindowButtonBox m_pMachineGuns[20];
var R6WindowButtonBox m_pSniperRifle[20];
var R6WindowButtonBox m_pPistol[20];
var R6WindowButtonBox m_pMachinePistol[20];
var R6WindowButtonBox m_pPriWpnGadget[20];
var R6WindowButtonBox m_pSecWpnGadget[20];
var R6WindowButtonBox m_pMiscGadget[20];
var R6WindowListRestKit m_pRestKitButList;
var array<Class> m_ASubMachineGuns;
var array<Class> m_AShotguns;
var array<Class> m_AAssaultRifle;
var array<Class> m_AMachineGuns;
var array<Class> m_ASniperRifle;
var array<Class> m_APistol;
var array<Class> m_AMachinePistol;
var array<Class> m_APriWpnGadget;
var array<Class> m_ASecWpnGadget;
var array<Class> m_AMiscGadget;
var array<byte> m_ASelected;
const K_X_BUTTON_OFF= 30;
const K_Y_BUTTON_OFF= 4;
const K_Y_LIST_OFF= 23;
const K_MAX_WINDOWBUTTONBOX= 20;
const K_BOX_HEIGHT= 16;
const K_X_BORDER_OFF= 5;
const K_HALFWINDOWWIDTH= 310;

function Created ()
{
	m_pRestKitButList=R6WindowListRestKit(CreateWindow(Class'R6WindowListRestKit',0.00,23.00,310.00 - 1,WinHeight - 23,self));
	m_pRestKitButList.m_fXItemOffset=5.00;
	m_pRestKitButList.bAlwaysBehind=True;
}

function Paint (Canvas C, float fMouseX, float fMouseY)
{
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	DrawStretchedTextureSegment(C,0.00,23.00,310.00 - 1,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
}

function InitSelectButtons (bool _bInGame)
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local Font ButtonFont;
	local int i;

	m_bIsInGame=_bInGame;
	fYOffset=4.00;
	fWidth=100.00;
	fXOffset=(310.00 / 2 - fWidth) / 2;
	fHeight=16.00;
	ButtonFont=Root.Fonts[5];
	m_pSelectAll=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pSelectAll.m_vButtonColor=Root.Colors.White;
	m_pSelectAll.SetButtonBorderColor(Root.Colors.White);
	m_pSelectAll.m_bDrawBorders=True;
	m_pSelectAll.Align=TA_Center;
	m_pSelectAll.ImageX=2.00;
	m_pSelectAll.ImageY=2.00;
	m_pSelectAll.m_bDrawSimpleBorder=True;
	m_pSelectAll.bStretched=True;
	m_pSelectAll.SetText(Localize("MPCreateGame","Kit_SelectAll","R6Menu"));
	m_pSelectAll.SetFont(0);
	m_pSelectAll.TextColor=Root.Colors.White;
	m_pSelectAll.ToolTipString=Localize("Tip","Kit_SelectAll","R6Menu");
	fXOffset=310.00 / 2 + (310 / 2 - fWidth) / 2;
	m_pUnSelectAll=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pUnSelectAll.m_vButtonColor=Root.Colors.White;
	m_pUnSelectAll.SetButtonBorderColor(Root.Colors.White);
	m_pUnSelectAll.m_bDrawBorders=True;
	m_pUnSelectAll.Align=TA_Center;
	m_pUnSelectAll.ImageX=2.00;
	m_pUnSelectAll.ImageY=2.00;
	m_pUnSelectAll.m_bDrawSimpleBorder=True;
	m_pUnSelectAll.bStretched=True;
	m_pUnSelectAll.SetText(Localize("MPCreateGame","Kit_UnselectAll","R6Menu"));
	m_pUnSelectAll.SetFont(0);
	m_pUnSelectAll.TextColor=Root.Colors.White;
	m_pUnSelectAll.ToolTipString=Localize("Tip","Kit_UnselectAll","R6Menu");
}

function InitSubMachineGunsTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local int i;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASubMachineGuns.Remove (0,m_ASubMachineGuns.Length);
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_ASubMachineGuns=GetRestrictionKit(Class'R6SubGunDescription',pServerOptions.RestrictedSubMachineGuns,_pR6GameRepInfo);
	}
	else
	{
		m_ASubMachineGuns=GetRestrictionKit(Class'R6SubGunDescription',pServerOptions.RestrictedSubMachineGuns,_pR6GameRepInfo,_pR6GameRepInfo.m_szSubMachineGunsRes);
	}
	CreateRestKitButtons(m_ASubMachineGuns,m_ASelected,"R6Weapons",m_pSubMachineGuns);
	i=m_ASubMachineGuns.Length + 1;
JL00BF:
	if ( i < 20 )
	{
		m_pSubMachineGuns[i]=None;
		i++;
		goto JL00BF;
	}
}

function UpdateSubMachineGunsTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_ASubMachineGuns=GetRestrictionKit(Class'R6SubGunDescription',pServerOptions.RestrictedSubMachineGuns,_pR6GameRepInfo);
	}
	else
	{
		m_ASubMachineGuns=GetRestrictionKit(Class'R6SubGunDescription',pServerOptions.RestrictedSubMachineGuns,_pR6GameRepInfo,_pR6GameRepInfo.m_szSubMachineGunsRes);
	}
	UpdateRestKitButtonSel(m_ASelected,m_pSubMachineGuns);
}

function InitShotGunsTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local int i;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_AShotguns.Remove (0,m_AShotguns.Length);
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_AShotguns=GetRestrictionKit(Class'R6ShotgunDescription',pServerOptions.RestrictedShotGuns,_pR6GameRepInfo);
	}
	else
	{
		m_AShotguns=GetRestrictionKit(Class'R6ShotgunDescription',pServerOptions.RestrictedShotGuns,_pR6GameRepInfo,_pR6GameRepInfo.m_szShotGunRes);
	}
	CreateRestKitButtons(m_AShotguns,m_ASelected,"R6Weapons",m_pShotguns);
	i=m_AShotguns.Length + 1;
JL00BF:
	if ( i < 20 )
	{
		m_pShotguns[i]=None;
		i++;
		goto JL00BF;
	}
}

function UpdateShotGunsTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_AShotguns=GetRestrictionKit(Class'R6ShotgunDescription',pServerOptions.RestrictedShotGuns,_pR6GameRepInfo);
	}
	else
	{
		m_AShotguns=GetRestrictionKit(Class'R6ShotgunDescription',pServerOptions.RestrictedShotGuns,_pR6GameRepInfo,_pR6GameRepInfo.m_szShotGunRes);
	}
	UpdateRestKitButtonSel(m_ASelected,m_pShotguns);
}

function InitAssaultRifleTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local int i;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_AAssaultRifle.Remove (0,m_AAssaultRifle.Length);
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_AAssaultRifle=GetRestrictionKit(Class'R6AssaultDescription',pServerOptions.RestrictedAssultRifles,_pR6GameRepInfo);
	}
	else
	{
		m_AAssaultRifle=GetRestrictionKit(Class'R6AssaultDescription',pServerOptions.RestrictedAssultRifles,_pR6GameRepInfo,_pR6GameRepInfo.m_szAssRifleRes);
	}
	CreateRestKitButtons(m_AAssaultRifle,m_ASelected,"R6Weapons",m_pAssaultRifle);
	i=m_AAssaultRifle.Length + 1;
JL00BF:
	if ( i < 20 )
	{
		m_pAssaultRifle[i]=None;
		i++;
		goto JL00BF;
	}
}

function UpdateAssaultRifleTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_AAssaultRifle=GetRestrictionKit(Class'R6AssaultDescription',pServerOptions.RestrictedAssultRifles,_pR6GameRepInfo);
	}
	else
	{
		m_AAssaultRifle=GetRestrictionKit(Class'R6AssaultDescription',pServerOptions.RestrictedAssultRifles,_pR6GameRepInfo,_pR6GameRepInfo.m_szAssRifleRes);
	}
	UpdateRestKitButtonSel(m_ASelected,m_pAssaultRifle);
}

function InitMachineGunsTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local int i;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_AMachineGuns.Remove (0,m_AMachineGuns.Length);
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_AMachineGuns=GetRestrictionKit(Class'R6LMGDescription',pServerOptions.RestrictedMachineGuns,_pR6GameRepInfo);
	}
	else
	{
		m_AMachineGuns=GetRestrictionKit(Class'R6LMGDescription',pServerOptions.RestrictedMachineGuns,_pR6GameRepInfo,_pR6GameRepInfo.m_szMachGunRes);
	}
	CreateRestKitButtons(m_AMachineGuns,m_ASelected,"R6Weapons",m_pMachineGuns);
	i=m_AMachineGuns.Length + 1;
JL00BF:
	if ( i < 20 )
	{
		m_pMachineGuns[i]=None;
		i++;
		goto JL00BF;
	}
}

function UpdateMachineGunsTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_AMachineGuns=GetRestrictionKit(Class'R6LMGDescription',pServerOptions.RestrictedMachineGuns,_pR6GameRepInfo);
	}
	else
	{
		m_AMachineGuns=GetRestrictionKit(Class'R6LMGDescription',pServerOptions.RestrictedMachineGuns,_pR6GameRepInfo,_pR6GameRepInfo.m_szMachGunRes);
	}
	UpdateRestKitButtonSel(m_ASelected,m_pMachineGuns);
}

function InitSniperRifleTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local int i;
	local R6ServerInfo pServerOptions;

//	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASniperRifle.Remove (0,m_ASniperRifle.Length);
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_ASniperRifle=GetRestrictionKit(Class'R6SniperDescription',pServerOptions.RestrictedSniperRifles,_pR6GameRepInfo);
	}
	else
	{
		m_ASniperRifle=GetRestrictionKit(Class'R6SniperDescription',pServerOptions.RestrictedSniperRifles,_pR6GameRepInfo,_pR6GameRepInfo.m_szSnipRifleRes);
	}
	CreateRestKitButtons(m_ASniperRifle,m_ASelected,"R6Weapons",m_pSniperRifle);
	i=m_ASniperRifle.Length + 1;
JL00BF:
	if ( i < 20 )
	{
		m_pSniperRifle[i]=None;
		i++;
		goto JL00BF;
	}
}

function UpdateSniperRifleTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_ASniperRifle=GetRestrictionKit(Class'R6SniperDescription',pServerOptions.RestrictedSniperRifles,_pR6GameRepInfo);
	}
	else
	{
		m_ASniperRifle=GetRestrictionKit(Class'R6SniperDescription',pServerOptions.RestrictedSniperRifles,_pR6GameRepInfo,_pR6GameRepInfo.m_szSnipRifleRes);
	}
	UpdateRestKitButtonSel(m_ASelected,m_pSniperRifle);
}

function InitPistolTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local int i;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_APistol.Remove (0,m_APistol.Length);
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_APistol=GetRestrictionKit(Class'R6PistolsDescription',pServerOptions.RestrictedPistols,_pR6GameRepInfo);
	}
	else
	{
		m_APistol=GetRestrictionKit(Class'R6PistolsDescription',pServerOptions.RestrictedPistols,_pR6GameRepInfo,_pR6GameRepInfo.m_szPistolRes);
	}
	CreateRestKitButtons(m_APistol,m_ASelected,"R6Weapons",m_pPistol);
	m_pPistol[0].m_bSelected=False;
	m_pPistol[0].bDisabled=True;
	i=m_APistol.Length + 1;
JL00E5:
	if ( i < 20 )
	{
		m_pPistol[i]=None;
		i++;
		goto JL00E5;
	}
}

function UpdatePistolsTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_APistol=GetRestrictionKit(Class'R6PistolsDescription',pServerOptions.RestrictedPistols,_pR6GameRepInfo);
	}
	else
	{
		m_APistol=GetRestrictionKit(Class'R6PistolsDescription',pServerOptions.RestrictedPistols,_pR6GameRepInfo,_pR6GameRepInfo.m_szPistolRes);
	}
	UpdateRestKitButtonSel(m_ASelected,m_pPistol);
}

function InitMachinePistolTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local int i;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_AMachinePistol.Remove (0,m_AMachinePistol.Length);
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_AMachinePistol=GetRestrictionKit(Class'R6MachinePistolsDescription',pServerOptions.RestrictedMachinePistols,_pR6GameRepInfo);
	}
	else
	{
		m_AMachinePistol=GetRestrictionKit(Class'R6MachinePistolsDescription',pServerOptions.RestrictedMachinePistols,_pR6GameRepInfo,_pR6GameRepInfo.m_szMachPistolRes);
	}
	CreateRestKitButtons(m_AMachinePistol,m_ASelected,"R6Weapons",m_pMachinePistol);
	i=m_AMachinePistol.Length + 1;
JL00BF:
	if ( i < 20 )
	{
		m_pMachinePistol[i]=None;
		i++;
		goto JL00BF;
	}
}

function UpdateMachinePistolTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_AMachinePistol=GetRestrictionKit(Class'R6MachinePistolsDescription',pServerOptions.RestrictedMachinePistols,_pR6GameRepInfo);
	}
	else
	{
		m_AMachinePistol=GetRestrictionKit(Class'R6MachinePistolsDescription',pServerOptions.RestrictedMachinePistols,_pR6GameRepInfo,_pR6GameRepInfo.m_szMachPistolRes);
	}
	UpdateRestKitButtonSel(m_ASelected,m_pMachinePistol);
}

function InitPriWpnGadgetTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local Font ButtonFont;
	local int i;
	local int j;
	local int k;
	local Class<R6WeaponGadgetDescription> DescriptionClass;
	local bool bFound;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_APriWpnGadget.Remove (0,m_APriWpnGadget.Length);
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_APriWpnGadget=GetGadgetRestrictionKit(Class'R6WeaponGadgetDescription',pServerOptions.RestrictedPrimary,_pR6GameRepInfo);
	}
	else
	{
		m_APriWpnGadget=GetGadgetRestrictionKit(Class'R6WeaponGadgetDescription',pServerOptions.RestrictedPrimary,_pR6GameRepInfo,_pR6GameRepInfo.m_szGadgPrimaryRes);
	}
	CreateRestKitButtons(m_APriWpnGadget,m_ASelected,"R6WeaponGadgets",m_pPriWpnGadget);
	i=m_APriWpnGadget.Length + 1;
JL00C5:
	if ( i < 20 )
	{
		m_pPriWpnGadget[i]=None;
		i++;
		goto JL00C5;
	}
}

function UpdatePriWpnGadgetTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_APriWpnGadget=GetGadgetRestrictionKit(Class'R6WeaponGadgetDescription',pServerOptions.RestrictedPrimary,_pR6GameRepInfo);
	}
	else
	{
		m_APriWpnGadget=GetGadgetRestrictionKit(Class'R6WeaponGadgetDescription',pServerOptions.RestrictedPrimary,_pR6GameRepInfo,_pR6GameRepInfo.m_szGadgPrimaryRes);
	}
	UpdateRestKitButtonSel(m_ASelected,m_pPriWpnGadget);
}

function InitSecWpnGadgetTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local Font ButtonFont;
	local int i;
	local int j;
	local int k;
	local Class<R6WeaponGadgetDescription> DescriptionClass;
	local bool bFound;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASecWpnGadget.Remove (0,m_ASecWpnGadget.Length);
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_ASecWpnGadget=GetGadgetRestrictionKit(Class'R6WeaponGadgetDescription',pServerOptions.RestrictedSecondary,_pR6GameRepInfo,,True);
	}
	else
	{
		m_ASecWpnGadget=GetGadgetRestrictionKit(Class'R6WeaponGadgetDescription',pServerOptions.RestrictedSecondary,_pR6GameRepInfo,_pR6GameRepInfo.m_szGadgSecondayRes,True);
	}
	CreateRestKitButtons(m_ASecWpnGadget,m_ASelected,"R6WeaponGadgets",m_pSecWpnGadget);
	i=m_ASecWpnGadget.Length + 1;
JL00C8:
	if ( i < 20 )
	{
		m_pSecWpnGadget[i]=None;
		i++;
		goto JL00C8;
	}
}

function UpdateSecWpnGadgetTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_ASecWpnGadget=GetGadgetRestrictionKit(Class'R6WeaponGadgetDescription',pServerOptions.RestrictedSecondary,_pR6GameRepInfo,,True);
	}
	else
	{
		m_ASecWpnGadget=GetGadgetRestrictionKit(Class'R6WeaponGadgetDescription',pServerOptions.RestrictedSecondary,_pR6GameRepInfo,_pR6GameRepInfo.m_szGadgSecondayRes,True);
	}
	UpdateRestKitButtonSel(m_ASelected,m_pSecWpnGadget);
}

function InitMiscGadgetTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local int i;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_AMiscGadget.Remove (0,m_AMiscGadget.Length);
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_AMiscGadget=GetGadgetRestrictionKit(Class'R6GadgetDescription',pServerOptions.RestrictedMiscGadgets,_pR6GameRepInfo);
	}
	else
	{
		m_AMiscGadget=GetGadgetRestrictionKit(Class'R6GadgetDescription',pServerOptions.RestrictedMiscGadgets,_pR6GameRepInfo,_pR6GameRepInfo.m_szGadgMiscRes);
	}
	CreateRestKitButtons(m_AMiscGadget,m_ASelected,"R6Gadgets",m_pMiscGadget);
	i=m_AMiscGadget.Length + 1;
JL00BF:
	if ( i < 20 )
	{
		m_pMiscGadget[i]=None;
		i++;
		goto JL00BF;
	}
}

function UpdateMiscGadgetTab (R6GameReplicationInfo _pR6GameRepInfo)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	m_ASelected.Remove (0,m_ASelected.Length);
	if ( _pR6GameRepInfo == None )
	{
		m_AMiscGadget=GetGadgetRestrictionKit(Class'R6GadgetDescription',pServerOptions.RestrictedMiscGadgets,_pR6GameRepInfo);
	}
	else
	{
		m_AMiscGadget=GetGadgetRestrictionKit(Class'R6GadgetDescription',pServerOptions.RestrictedMiscGadgets,_pR6GameRepInfo,_pR6GameRepInfo.m_szGadgMiscRes);
	}
	UpdateRestKitButtonSel(m_ASelected,m_pMiscGadget);
}

function array<Class> GetRestrictionKit (Class pClassRestriction, array<Class> _pInitialRest, R6GameReplicationInfo _pR6GameRepInfo, optional string _szInGameRestriction[32])
{
	local array<Class> m_AOfRestrictions;
	local Class<R6Description> DescriptionClass;
	local int i;
	local int j;
	local int iNbOfRest;
	local bool bFindRes;
	local int k;
	local R6Mod pCurrentMod;

	pCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod;
	if ( pCurrentMod == None )
	{
		Log("pCurrentMod == None");
		return m_AOfRestrictions;
	}
	k=0;
JL004A:
	if ( k < pCurrentMod.m_aDescriptionPackage.Length )
	{
		DescriptionClass=Class<R6Description>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[k] $ ".u",pClassRestriction));
JL0090:
		if ( DescriptionClass != None )
		{
			bFindRes=False;
			if ( DescriptionClass.Default.m_NameID != "NONE" )
			{
				bFindRes=True;
			}
			if ( bFindRes )
			{
				m_AOfRestrictions[i]=DescriptionClass;
				i++;
			}
			DescriptionClass=Class<R6Description>(GetNextClass());
			goto JL0090;
		}
		iNbOfRest=i;
		FreePackageObjects();
		k++;
		goto JL004A;
	}
	m_AOfRestrictions=SortRestrictionKit(m_AOfRestrictions);
	i=0;
JL0126:
	if ( i < iNbOfRest )
	{
		m_ASelected[i]=0;
		if ( _pR6GameRepInfo == None )
		{
			j=0;
JL0155:
			if ( j < _pInitialRest.Length )
			{
				if ( _pInitialRest[j] == m_AOfRestrictions[i] )
				{
					m_ASelected[i]=1;
				}
				else
				{
					j++;
					goto JL0155;
				}
			}
		}
		else
		{
			j=0;
JL01A5:
			if ( j < 32 )
			{
				if ( _szInGameRestriction[j] == Class<R6Description>(m_AOfRestrictions[i]).Default.m_NameID )
				{
					m_ASelected[i]=1;
				}
				else
				{
					j++;
					goto JL01A5;
				}
			}
		}
		i++;
		goto JL0126;
	}
	return m_AOfRestrictions;
}

function array<Class> GetGadgetRestrictionKit (Class pClassRestriction, array<string> _pInitialRest, R6GameReplicationInfo _pR6GameRepInfo, optional string _szInGameRestriction[32], optional bool _bSecWeaponGadget)
{
	local array<Class> m_AOfRestrictions;
	local Class<R6Description> DescriptionClass;
	local int i;
	local int j;
	local int k;
	local int iNbOfRest;
	local bool bFindRes;
	local int L;
	local R6Mod pCurrentMod;

	pCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod;
	L=0;
JL0022:
	if ( L < pCurrentMod.m_aDescriptionPackage.Length )
	{
		DescriptionClass=Class<R6Description>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[L] $ ".u",pClassRestriction));
JL0068:
		if ( DescriptionClass != None )
		{
			bFindRes=False;
			if ( DescriptionClass.Default.m_NameID != "NONE" )
			{
				if ( _bSecWeaponGadget )
				{
					if ( Class<R6WeaponGadgetDescription>(DescriptionClass).Default.m_bSecGadgetWAvailable )
					{
						bFindRes=True;
					}
				}
				else
				{
					bFindRes=True;
				}
			}
			if ( bFindRes )
			{
				k=m_AOfRestrictions.Length;
				j=0;
JL00E3:
				if ( j < k )
				{
					if ( Class<R6Description>(m_AOfRestrictions[j]).Default.m_NameID == DescriptionClass.Default.m_NameID )
					{
						bFindRes=False;
					}
					else
					{
						j++;
						goto JL00E3;
					}
				}
				if ( bFindRes )
				{
					m_AOfRestrictions[i]=DescriptionClass;
					i++;
				}
			}
			DescriptionClass=Class<R6Description>(GetNextClass());
			goto JL0068;
		}
		iNbOfRest=i;
		FreePackageObjects();
		L++;
		goto JL0022;
	}
	m_AOfRestrictions=SortRestrictionKit(m_AOfRestrictions);
	i=0;
JL0195:
	if ( i < iNbOfRest )
	{
		m_ASelected[i]=0;
		if ( _pR6GameRepInfo == None )
		{
			j=0;
JL01C4:
			if ( j < _pInitialRest.Length )
			{
				if ( _pInitialRest[j] == Class<R6Description>(m_AOfRestrictions[i]).Default.m_NameID )
				{
					m_ASelected[i]=1;
				}
				else
				{
					j++;
					goto JL01C4;
				}
			}
		}
		else
		{
			j=0;
JL0222:
			if ( j < 32 )
			{
				if ( _szInGameRestriction[j] == Class<R6Description>(m_AOfRestrictions[i]).Default.m_NameID )
				{
					m_ASelected[i]=1;
				}
				else
				{
					j++;
					goto JL0222;
				}
			}
		}
		i++;
		goto JL0195;
	}
	return m_AOfRestrictions;
}

function array<Class> SortRestrictionKit (array<Class> _pAToSort)
{
	local int i;
	local int j;
	local Class sTemp;
	local bool bSwap;

	i=0;
JL0007:
	if ( i < _pAToSort.Length - 1 )
	{
		j=0;
JL0021:
		if ( j < _pAToSort.Length - 1 - i )
		{
			bSwap=Class<R6Description>(_pAToSort[j]).Default.m_NameID > Class<R6Description>(_pAToSort[j + 1]).Default.m_NameID;
			if ( bSwap )
			{
				sTemp=_pAToSort[j];
				_pAToSort[j]=_pAToSort[j + 1];
				_pAToSort[j + 1]=sTemp;
			}
			j++;
			goto JL0021;
		}
		i++;
		goto JL0007;
	}
	return _pAToSort;
}

function CreateRestKitButtons (array<Class> pRestKitClass, array<byte> pRestKitSelect, string _szLocFile, out R6WindowButtonBox _ButtonsBox[20])
{
	local R6WindowListGeneralItem NewItem;
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local Font ButtonFont;
	local int i;
	local int j;
	local string ButtonTag;

	fXOffset=5.00;
	fYOffset=23.00;
	fWidth=310.00 - 2 * fXOffset - 15;
	fHeight=16.00;
	ButtonFont=Root.Fonts[5];
	i=0;
JL005D:
	if ( i < pRestKitClass.Length )
	{
		NewItem=R6WindowListGeneralItem(m_pRestKitButList.GetItemAtIndex(i));
		NewItem.m_pR6WindowButtonBox=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
		NewItem.m_pR6WindowButtonBox.m_TextFont=ButtonFont;
		NewItem.m_pR6WindowButtonBox.m_vTextColor=Root.Colors.White;
		NewItem.m_pR6WindowButtonBox.m_vBorder=Root.Colors.White;
//		NewItem.m_pR6WindowButtonBox.m_bSelected=pRestKitSelect[i];
		NewItem.m_pR6WindowButtonBox.m_szMiscText=Class<R6Description>(pRestKitClass[i]).Default.m_NameID;
		NewItem.m_pR6WindowButtonBox.m_AdviceWindow=m_pRestKitButList;
		NewItem.m_pR6WindowButtonBox.CreateTextAndBox(Localize(Class<R6Description>(pRestKitClass[i]).Default.m_NameID,"ID_NAME",_szLocFile),Localize("Tip","Kit_Restriction","R6Menu"),0.00,i);
		_ButtonsBox[i]=NewItem.m_pR6WindowButtonBox;
		i++;
		goto JL005D;
	}
}

function UpdateRestKitButtonSel (array<byte> pRestKitSelect, out R6WindowButtonBox _ButtonsBox[20])
{
	local int i;

	i=0;
JL0007:
	if ( i < pRestKitSelect.Length )
	{
		if ( _ButtonsBox[i] == None )
		{
			goto JL0058;
		}
//		_ButtonsBox[i].m_bSelected=pRestKitSelect[i];
		i++;
		goto JL0007;
	}
JL0058:
}

function SelectAllSubMachineGuns (bool bSelected)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_ASubMachineGuns.Length )
	{
		m_pSubMachineGuns[i].m_bSelected=bSelected;
		i++;
		goto JL0007;
	}
}

function SelectAllShotguns (bool bSelected)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_AShotguns.Length )
	{
		m_pShotguns[i].m_bSelected=bSelected;
		i++;
		goto JL0007;
	}
}

function SelectAllAssaultRifle (bool bSelected)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_AAssaultRifle.Length )
	{
		m_pAssaultRifle[i].m_bSelected=bSelected;
		i++;
		goto JL0007;
	}
}

function SelectAllMachineGuns (bool bSelected)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_AMachineGuns.Length )
	{
		m_pMachineGuns[i].m_bSelected=bSelected;
		i++;
		goto JL0007;
	}
}

function SelectAllSniperRifle (bool bSelected)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_ASniperRifle.Length )
	{
		m_pSniperRifle[i].m_bSelected=bSelected;
		i++;
		goto JL0007;
	}
}

function SelectAllPistol (bool bSelected)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_APistol.Length )
	{
		if (  !m_pPistol[i].bDisabled )
		{
			m_pPistol[i].m_bSelected=bSelected;
		}
		i++;
		goto JL0007;
	}
}

function SelectAllMachinePistol (bool bSelected)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_AMachinePistol.Length )
	{
		m_pMachinePistol[i].m_bSelected=bSelected;
		i++;
		goto JL0007;
	}
}

function SelectAllPriWpnGadget (bool bSelected)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_APriWpnGadget.Length )
	{
		m_pPriWpnGadget[i].m_bSelected=bSelected;
		i++;
		goto JL0007;
	}
}

function SelectAllSecWpnGadget (bool bSelected)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_ASecWpnGadget.Length )
	{
		m_pSecWpnGadget[i].m_bSelected=bSelected;
		i++;
		goto JL0007;
	}
}

function SelectAllMiscGadget (bool bSelected)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_AMiscGadget.Length )
	{
		m_pMiscGadget[i].m_bSelected=bSelected;
		i++;
		goto JL0007;
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	local bool bSelect;
	local R6MenuMPRestKitMain R6RestKit;

	if ( m_bIsInGame )
	{
/*		if (  !R6PlayerController(GetPlayerOwner()).CheckAuthority(R6PlayerController(GetPlayerOwner()).1) )
		{
			return;
		}*/
	}
	if ( C.IsA('R6WindowButton') )
	{
		bSelect=C == m_pSelectAll;
		switch (E)
		{
			case 2:
			R6RestKit=R6MenuMPRestKitMain(OwnerWindow);
			if ( self == R6RestKit.m_pSubMachinesGunsTab )
			{
				SelectAllSubMachineGuns(bSelect);
			}
			else
			{
				if ( self == R6RestKit.m_pShotgunsTab )
				{
					SelectAllShotguns(bSelect);
				}
				else
				{
					if ( self == R6RestKit.m_pAssaultRifleTab )
					{
						SelectAllAssaultRifle(bSelect);
					}
					else
					{
						if ( self == R6RestKit.m_pMachineGunsTab )
						{
							SelectAllMachineGuns(bSelect);
						}
						else
						{
							if ( self == R6RestKit.m_pSniperRifleTab )
							{
								SelectAllSniperRifle(bSelect);
							}
							else
							{
								if ( self == R6RestKit.m_pPistolTab )
								{
									SelectAllPistol(bSelect);
								}
								else
								{
									if ( self == R6RestKit.m_pMachinePistolTab )
									{
										SelectAllMachinePistol(bSelect);
									}
									else
									{
										if ( self == R6RestKit.m_pPriWpnGadgetTab )
										{
											SelectAllPriWpnGadget(bSelect);
										}
										else
										{
											if ( self == R6RestKit.m_pSecWpnGadgetTab )
											{
												SelectAllSecWpnGadget(bSelect);
											}
											else
											{
												if ( self == R6RestKit.m_pMiscGadgetTab )
												{
													SelectAllMiscGadget(bSelect);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			if (  !m_bIsInGame )
			{
				R6MenuMPCreateGameTabKitRest(R6RestKit.OwnerWindow).SetServerOptions();
			}
			break;
			case 9:
			R6WindowButton(C).SetButtonBorderColor(Root.Colors.White);
			R6WindowButton(C).TextColor=Root.Colors.White;
			break;
			case 12:
			R6WindowButton(C).SetButtonBorderColor(Root.Colors.BlueLight);
			R6WindowButton(C).TextColor=Root.Colors.BlueLight;
			break;
			default:
		}
	}
	else
	{
		if ( C.IsA('R6WindowButtonBox') )
		{
			if ( E == 2 )
			{
				if ( R6WindowButtonBox(C).GetSelectStatus() )
				{
					R6WindowButtonBox(C).m_bSelected= !R6WindowButtonBox(C).m_bSelected;
					if (  !m_bIsInGame )
					{
						R6MenuMPCreateGameTabKitRest(R6RestKit.OwnerWindow).SetServerOptions();
					}
				}
			}
		}
	}
}

function RefreshSubKit (bool _bAdmin)
{
	if ( _bAdmin )
	{
		m_pSelectAll.bDisabled=False;
		m_pUnSelectAll.bDisabled=False;
	}
	else
	{
		m_pSelectAll.bDisabled=True;
		m_pUnSelectAll.bDisabled=True;
	}
}
