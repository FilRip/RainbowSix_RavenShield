//================================================================================
// R6MenuDiffCustomMissionSelect.
//================================================================================
class R6MenuDiffCustomMissionSelect extends UWindowDialogClientWindow
	Config(User);

var config int CustomMissionDifficultyLevel;
var bool m_bAutoSave;
var R6WindowButtonBox m_pButLevel1;
var R6WindowButtonBox m_pButLevel2;
var R6WindowButtonBox m_pButLevel3;
var R6WindowButtonBox m_pButLastSel;

function Created ()
{
	local R6MenuButtonsDefines pButtonsDef;
	local float fXOffset;
	local float fYOffset;
	local float fWidth;
	local float fHeight;
	local float fYStep;

	pButtonsDef=R6MenuButtonsDefines(GetButtonsDefinesUnique(Root.MenuClassDefines.ClassButtonsDefines));
	fXOffset=5.00;
	fYOffset=5.00;
	fWidth=WinWidth - 20;
	fHeight=15.00;
	fYStep=fHeight + 16;
	m_pButLevel1=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pButLevel1.SetButtonBox(False);
	m_pButLevel1.CreateTextAndBox(pButtonsDef.GetButtonLoc(19),pButtonsDef.GetButtonLoc(19,True),0.00,19);
	fYOffset += fYStep;
	m_pButLevel2=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pButLevel2.SetButtonBox(False);
	m_pButLevel2.CreateTextAndBox(pButtonsDef.GetButtonLoc(20),pButtonsDef.GetButtonLoc(20,True),0.00,20);
	fYOffset += fYStep;
	m_pButLevel3=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pButLevel3.SetButtonBox(False);
	m_pButLevel3.CreateTextAndBox(pButtonsDef.GetButtonLoc(21),pButtonsDef.GetButtonLoc(21,True),0.00,21);
	switch (19 - 1 + CustomMissionDifficultyLevel)
	{
		case m_pButLevel1.m_iButtonID:
		m_pButLastSel=m_pButLevel1;
		break;
		case m_pButLevel2.m_iButtonID:
		m_pButLastSel=m_pButLevel2;
		break;
		case m_pButLevel3.m_iButtonID:
		m_pButLastSel=m_pButLevel3;
		break;
		default:
		m_pButLastSel=m_pButLevel2;
		break;
	}
	m_pButLastSel.SetButtonBox(True);
}

function SetDifficulty (int iDifficulty_)
{
	switch (19 - 1 + iDifficulty_)
	{
		case m_pButLevel1.m_iButtonID:
		m_pButLastSel.SetButtonBox(False);
		m_pButLevel1.SetButtonBox(True);
		m_pButLastSel=m_pButLevel1;
		break;
		case m_pButLevel2.m_iButtonID:
		m_pButLastSel.SetButtonBox(False);
		m_pButLevel2.SetButtonBox(True);
		m_pButLastSel=m_pButLevel2;
		break;
		case m_pButLevel3.m_iButtonID:
		m_pButLastSel.SetButtonBox(False);
		m_pButLevel3.SetButtonBox(True);
		m_pButLastSel=m_pButLevel3;
		break;
		default:
	}
}

function int GetDifficulty ()
{
	CustomMissionDifficultyLevel=m_pButLastSel.m_iButtonID - 19 + 1;
	if ( m_bAutoSave )
	{
		SaveConfig();
	}
	return CustomMissionDifficultyLevel;
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		if ( R6WindowButtonBox(C).GetSelectStatus() )
		{
			m_pButLastSel.SetButtonBox(False);
			R6WindowButtonBox(C).SetButtonBox(True);
			m_pButLastSel=R6WindowButtonBox(C);
		}
	}
}

defaultproperties
{
    CustomMissionDifficultyLevel=2
    m_bAutoSave=True
}