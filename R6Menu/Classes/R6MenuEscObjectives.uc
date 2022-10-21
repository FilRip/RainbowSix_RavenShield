//================================================================================
// R6MenuEscObjectives.
//================================================================================
class R6MenuEscObjectives extends UWindowWindow;

var float m_fXTitleOffset;
var float m_fYTitleOffset;
var float m_fLabelHeight;
var float m_fObjHeight;
var float m_fObjYOffset;
var R6WindowTextLabel m_Title;
var R6WindowTextLabel m_NoObj;
var R6MenuObjectiveLabel m_Objectives[8];
var string m_szTextFailed;
const C_MAXOBJ= 8;

function Created ()
{
	local int i;
	local int Y;

	m_Title=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fXTitleOffset,m_fYTitleOffset,WinWidth - m_fXTitleOffset,m_fLabelHeight,self));
//	m_Title.SetProperties(Localize("ESCMENUS","MISSIONOBJ","R6Menu"),0,Root.Fonts[5],Root.Colors.BlueLight,False);
	Y=m_Title.WinTop + m_Title.WinHeight + m_fObjYOffset;
	m_NoObj=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fXTitleOffset,Y,WinWidth - m_fXTitleOffset,m_fObjHeight,self));
//	m_NoObj.SetProperties(Localize("ESCMENUS","NOMISSIONOBJ","R6Menu"),0,Root.Fonts[0],Root.Colors.White,False);
	m_NoObj.HideWindow();
	i=0;
JL0166:
	if ( i < 8 )
	{
		m_Objectives[i]=R6MenuObjectiveLabel(CreateWindow(Class'R6MenuObjectiveLabel',m_fXTitleOffset,Y,WinWidth - m_fXTitleOffset,m_fObjHeight,self));
		m_Objectives[i].HideWindow();
		Y += m_fObjHeight;
		i++;
		goto JL0166;
	}
	m_szTextFailed=" (" $ Localize("OBJECTIVES","FAILED","R6Menu") $ ")";
}

function UpdateObjectives ()
{
	local R6MissionObjectiveMgr moMgr;
	local R6GameOptions pGameOptions;
	local string szTemp;
	local int i;
	local int j;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	moMgr=R6AbstractGameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_missionMgr;
	i=0;
JL005F:
	if ( i < 8 )
	{
		m_Objectives[i].HideWindow();
		i++;
		goto JL005F;
	}
	if ( moMgr.m_aMissionObjectives.Length <= 0 )
	{
		m_NoObj.ShowWindow();
	}
	else
	{
		m_NoObj.HideWindow();
		j=0;
		i=0;
JL00CE:
		if ( (i < moMgr.m_aMissionObjectives.Length) && (i < 8) )
		{
			if (  !moMgr.m_aMissionObjectives[i].m_bMoralityObjective && moMgr.m_aMissionObjectives[i].m_bVisibleInMenu )
			{
				szTemp=Localize("Game",moMgr.m_aMissionObjectives[i].m_szDescriptionInMenu,moMgr.Level.GetMissionObjLocFile(moMgr.m_aMissionObjectives[i]));
				if ( pGameOptions.UnlimitedPractice && moMgr.m_aMissionObjectives[i].isFailed() )
				{
					m_Objectives[j].SetProperties(szTemp,False,m_szTextFailed);
				}
				else
				{
					m_Objectives[j].SetProperties(szTemp,moMgr.m_aMissionObjectives[i].isCompleted());
				}
				m_Objectives[j].ShowWindow();
				j++;
			}
			++i;
			goto JL00CE;
		}
	}
}

defaultproperties
{
    m_fXTitleOffset=10.00
    m_fYTitleOffset=10.00
    m_fLabelHeight=15.00
    m_fObjHeight=15.00
    m_fObjYOffset=2.00
}
