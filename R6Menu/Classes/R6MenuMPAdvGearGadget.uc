//================================================================================
// R6MenuMPAdvGearGadget.
//================================================================================
class R6MenuMPAdvGearGadget extends R6MenuGearGadget;

function Created ()
{
	m_2DGadgetWidth=WinWidth;
	Super.Created();
}

function SetBorderColor (Color _NewColor)
{
	m_BorderColor=_NewColor;
}

defaultproperties
{
    m_bAssignAllButton=False
    m_bCenterTexture=True
}