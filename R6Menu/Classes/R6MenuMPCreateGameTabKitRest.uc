//================================================================================
// R6MenuMPCreateGameTabKitRest.
//================================================================================
class R6MenuMPCreateGameTabKitRest extends R6MenuMPCreateGameTab;

var R6MenuMPRestKitMain m_pMainRestriction;

function Created ()
{
	Super.Created();
}

function InitKitTab ()
{
	m_pMainRestriction=R6MenuMPRestKitMain(CreateWindow(Class'R6MenuMPRestKitMain',0.00,0.00,WinWidth,WinHeight,self));
	m_pMainRestriction.bAlwaysBehind=True;
	m_pMainRestriction.CreateKitRestriction();
}

function SetServerOptions ()
{
	local int iCounter;
	local int jCounter;
	local R6ServerInfo _ServerSettings;

	_ServerSettings=Class'Actor'.static.GetServerOptions();
	_ServerSettings.ClearSettings();
	jCounter=0;
	iCounter=0;
JL002F:
	if ( iCounter < m_pMainRestriction.m_pSubMachinesGunsTab.m_ASubMachineGuns.Length )
	{
		if ( m_pMainRestriction.m_pSubMachinesGunsTab.m_pSubMachineGuns[iCounter].m_bSelected )
		{
			_ServerSettings.RestrictedSubMachineGuns[jCounter]=m_pMainRestriction.m_pSubMachinesGunsTab.m_ASubMachineGuns[iCounter];
			jCounter++;
		}
		iCounter++;
		goto JL002F;
	}
	jCounter=0;
	iCounter=0;
JL00CC:
	if ( iCounter < m_pMainRestriction.m_pShotgunsTab.m_AShotguns.Length )
	{
		if ( m_pMainRestriction.m_pShotgunsTab.m_pShotguns[iCounter].m_bSelected )
		{
			_ServerSettings.RestrictedShotGuns[jCounter]=m_pMainRestriction.m_pShotgunsTab.m_AShotguns[iCounter];
			jCounter++;
		}
		iCounter++;
		goto JL00CC;
	}
	jCounter=0;
	iCounter=0;
JL0169:
	if ( iCounter < m_pMainRestriction.m_pAssaultRifleTab.m_AAssaultRifle.Length )
	{
		if ( m_pMainRestriction.m_pAssaultRifleTab.m_pAssaultRifle[iCounter].m_bSelected )
		{
			_ServerSettings.RestrictedAssultRifles[jCounter]=m_pMainRestriction.m_pAssaultRifleTab.m_AAssaultRifle[iCounter];
			jCounter++;
		}
		iCounter++;
		goto JL0169;
	}
	jCounter=0;
	iCounter=0;
JL0206:
	if ( iCounter < m_pMainRestriction.m_pMachineGunsTab.m_AMachineGuns.Length )
	{
		if ( m_pMainRestriction.m_pMachineGunsTab.m_pMachineGuns[iCounter].m_bSelected )
		{
			_ServerSettings.RestrictedMachineGuns[jCounter]=m_pMainRestriction.m_pMachineGunsTab.m_AMachineGuns[iCounter];
			jCounter++;
		}
		iCounter++;
		goto JL0206;
	}
	jCounter=0;
	iCounter=0;
JL02A3:
	if ( iCounter < m_pMainRestriction.m_pSniperRifleTab.m_ASniperRifle.Length )
	{
		if ( m_pMainRestriction.m_pSniperRifleTab.m_pSniperRifle[iCounter].m_bSelected )
		{
			_ServerSettings.RestrictedSniperRifles[jCounter]=m_pMainRestriction.m_pSniperRifleTab.m_ASniperRifle[iCounter];
			jCounter++;
		}
		iCounter++;
		goto JL02A3;
	}
	jCounter=0;
	iCounter=0;
JL0340:
	if ( iCounter < m_pMainRestriction.m_pPistolTab.m_APistol.Length )
	{
		if ( m_pMainRestriction.m_pPistolTab.m_pPistol[iCounter].m_bSelected )
		{
			_ServerSettings.RestrictedPistols[jCounter]=m_pMainRestriction.m_pPistolTab.m_APistol[iCounter];
			jCounter++;
		}
		iCounter++;
		goto JL0340;
	}
	jCounter=0;
	iCounter=0;
JL03DD:
	if ( iCounter < m_pMainRestriction.m_pMachinePistolTab.m_AMachinePistol.Length )
	{
		if ( m_pMainRestriction.m_pMachinePistolTab.m_pMachinePistol[iCounter].m_bSelected )
		{
			_ServerSettings.RestrictedMachinePistols[jCounter]=m_pMainRestriction.m_pMachinePistolTab.m_AMachinePistol[iCounter];
			jCounter++;
		}
		iCounter++;
		goto JL03DD;
	}
	jCounter=0;
	iCounter=0;
JL047A:
	if ( iCounter < m_pMainRestriction.m_pPriWpnGadgetTab.m_APriWpnGadget.Length )
	{
		if ( m_pMainRestriction.m_pPriWpnGadgetTab.m_pPriWpnGadget[iCounter].m_bSelected )
		{
			_ServerSettings.RestrictedPrimary[jCounter]=m_pMainRestriction.m_pPriWpnGadgetTab.m_pPriWpnGadget[iCounter].m_szMiscText;
			jCounter++;
		}
		iCounter++;
		goto JL047A;
	}
	jCounter=0;
	iCounter=0;
JL0520:
	if ( iCounter < m_pMainRestriction.m_pSecWpnGadgetTab.m_ASecWpnGadget.Length )
	{
		if ( m_pMainRestriction.m_pSecWpnGadgetTab.m_pSecWpnGadget[iCounter].m_bSelected )
		{
			_ServerSettings.RestrictedSecondary[jCounter]=m_pMainRestriction.m_pSecWpnGadgetTab.m_pSecWpnGadget[iCounter].m_szMiscText;
			jCounter++;
		}
		iCounter++;
		goto JL0520;
	}
	jCounter=0;
	iCounter=0;
JL05C6:
	if ( iCounter < m_pMainRestriction.m_pMiscGadgetTab.m_AMiscGadget.Length )
	{
		if ( m_pMainRestriction.m_pMiscGadgetTab.m_pMiscGadget[iCounter].m_bSelected )
		{
			_ServerSettings.RestrictedMiscGadgets[jCounter]=m_pMainRestriction.m_pMiscGadgetTab.m_pMiscGadget[iCounter].m_szMiscText;
			jCounter++;
		}
		iCounter++;
		goto JL05C6;
	}
}
