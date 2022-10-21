//================================================================================
// R6MenuMPCreateGameTabAdvOptions.
//================================================================================
class R6MenuMPCreateGameTabAdvOptions extends R6MenuMPCreateGameTab;

var R6WindowTextLabelExt m_pAdvOptionsLineW;

function Created ()
{
	Super.Created();
}

function InitMod ()
{
}

function InitAdvOptionsTab (optional bool _bInGame)
{
	local float fXOffset;
	local float fYOffset;
	local float fWidth;
	local float fHeight;
	local int i;

	m_pAdvOptionsLineW=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',0.00,0.00,2.00 * 310,WinHeight,self));
	m_pAdvOptionsLineW.bAlwaysBehind=True;
	m_pAdvOptionsLineW.ActiveBorder(0,False);
	m_pAdvOptionsLineW.ActiveBorder(1,False);
	m_pAdvOptionsLineW.SetBorderParam(2,310.00,1.00,1.00,Root.Colors.White);
	m_pAdvOptionsLineW.ActiveBorder(3,False);
	fXOffset=5.00;
	fYOffset=5.00;
	fWidth=310.00 - fXOffset - 10;
	fHeight=WinHeight - fYOffset;
	m_bInitComplete=True;
}

function UpdateButtons (EGameModeInfo _eGameMode, eCreateGameWindow_ID _eCGWindowID, optional bool _bUpdateValue)
{
	local R6WindowListGeneral pTempList;
	local R6ServerInfo pServerInfo;

	pTempList=R6WindowListGeneral(GetList(_eGameMode,_eCGWindowID));
}

function SetServerOptions ()
{
	local R6ServerInfo _ServerSettings;
	local R6WindowListGeneral pListGen;

	_ServerSettings=Class'Actor'.static.GetServerOptions();
//	pListGen=R6WindowListGeneral(GetList(GetCurrentGameMode(),6));
	if ( pListGen == None )
	{
		return;
	}
}
