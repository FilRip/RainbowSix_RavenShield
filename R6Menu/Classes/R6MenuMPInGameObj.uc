//================================================================================
// R6MenuMPInGameObj.
//================================================================================
class R6MenuMPInGameObj extends R6MenuEscObjectives;

var R6WindowWrappedTextArea m_pGreenTeam;
var R6WindowWrappedTextArea m_pRedTeam;
var array<R6MenuObjectiveLabel> m_AObjectives;
var string m_AAdvLoc[2];

function Created ()
{
	local int ITemp;

	m_Title=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fXTitleOffset,m_fYTitleOffset,WinWidth - m_fXTitleOffset,m_fLabelHeight,self));
//	m_Title.SetProperties(Localize("Briefing","Objectives","R6Menu"),0,Root.Fonts[5],Root.Colors.BlueLight,False);
	ITemp=m_Title.WinTop + m_Title.WinHeight + m_fObjYOffset;
	ITemp=(WinHeight - ITemp) * 0.50;
	m_pGreenTeam=R6WindowWrappedTextArea(CreateWindow(Class'R6WindowWrappedTextArea',m_fXTitleOffset,m_Title.WinTop + m_Title.WinHeight + m_fObjYOffset,WinWidth - m_fXTitleOffset,ITemp,self));
	m_pGreenTeam.m_HBorderTexture=None;
	m_pGreenTeam.m_VBorderTexture=None;
	m_pGreenTeam.SetScrollable(False);
	m_pGreenTeam.HideWindow();
	m_pRedTeam=R6WindowWrappedTextArea(CreateWindow(Class'R6WindowWrappedTextArea',m_fXTitleOffset,m_pGreenTeam.WinTop + m_pGreenTeam.WinHeight,WinWidth - m_fXTitleOffset,ITemp,self));
	m_pRedTeam.m_HBorderTexture=None;
	m_pRedTeam.m_VBorderTexture=None;
	m_pRedTeam.SetScrollable(False);
	m_pRedTeam.HideWindow();
	m_AAdvLoc[0]=Localize("MPInGame","AlphaTeam","R6Menu") $ " : ";
	m_AAdvLoc[1]=Localize("MPInGame","BravoTeam","R6Menu") $ " : ";
}

function CreateObjWindow ()
{
	local int Y;
	local int iNbOfObj;

	iNbOfObj=m_AObjectives.Length;
	Y=m_Title.WinTop + m_Title.WinHeight + m_fObjYOffset + m_fObjHeight * iNbOfObj;
	m_AObjectives[iNbOfObj]=R6MenuObjectiveLabel(CreateWindow(Class'R6MenuObjectiveLabel',m_fXTitleOffset,Y,WinWidth - m_fXTitleOffset,m_fObjHeight,self));
	m_AObjectives[iNbOfObj].HideWindow();
}

function SetNewObjWindowSizes (float _X, float _Y, float _W, float _H, bool _bCoopType)
{
	local int i;
	local int iNbOfObj;

	m_Title.WinLeft=m_fXTitleOffset;
	m_Title.WinTop=m_fYTitleOffset;
	m_Title.WinWidth=_W;
	if ( _bCoopType )
	{
		iNbOfObj=m_AObjectives.Length;
		i=0;
JL0058:
		if ( i < iNbOfObj )
		{
			m_AObjectives[i].WinLeft=m_fXTitleOffset;
			m_AObjectives[i].WinWidth=_W;
			m_AObjectives[i].WinHeight=_H;
			m_AObjectives[i].SetNewLabelWindowSizes(m_fXTitleOffset,_Y,_W,_H);
			i++;
			goto JL0058;
		}
	}
}

function UpdateObjectives ()
{
	local string szObjectiveDesc;
	local string szLocalization;
	local int i;
	local GameReplicationInfo repInfo;
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
/*	if ( r6Root.m_eCurrentGameMode == GetLevel().3 )
	{
		m_pGreenTeam.Clear();
		m_pRedTeam.HideWindow();
		m_pGreenTeam.m_fXOffSet=10.00;
		if ( GetLevel().IsGameTypeTeamAdversarial(r6Root.m_eCurrentGameType) )
		{
			m_pGreenTeam.AddText(m_AAdvLoc[0] $ GetLevel().GetGreenTeamObjective(r6Root.m_eCurrentGameType),Root.Colors.White,Root.Fonts[5]);
			m_pRedTeam.Clear();
			m_pRedTeam.m_fXOffSet=10.00;
			m_pRedTeam.AddText(m_AAdvLoc[1] $ GetLevel().GetRedTeamObjective(r6Root.m_eCurrentGameType),Root.Colors.White,Root.Fonts[5]);
			m_pRedTeam.ShowWindow();
		}
		else
		{
			m_pGreenTeam.AddText(GetLevel().GetGreenTeamObjective(r6Root.m_eCurrentGameType),Root.Colors.White,Root.Fonts[5]);
		}
		m_pGreenTeam.ShowWindow();
	}
	else
	{
		repInfo=Root.Console.ViewportOwner.Actor.GameReplicationInfo;
		i=0;
JL0214:
		if ( i < m_AObjectives.Length )
		{
			m_AObjectives[i].HideWindow();
			i++;
			goto JL0214;
		}
		i=0;
JL024A:
		if ( i < repInfo.GetRepMObjInfoArraySize() )
		{
			szObjectiveDesc=repInfo.GetRepMObjString(i);
			if ( szObjectiveDesc == "" )
			{
				goto JL031A;
			}
			szObjectiveDesc=Localize("Game",szObjectiveDesc,repInfo.GetRepMObjStringLocFile(i));
			if ( i == m_AObjectives.Length )
			{
				CreateObjWindow();
			}
			m_AObjectives[i].SetProperties(szObjectiveDesc,repInfo.IsRepMObjCompleted(i));
			m_AObjectives[i].ShowWindow();
			++i;
			goto JL024A;
		}
	}*/
JL031A:
}

defaultproperties
{
    m_fYTitleOffset=3.00
}
