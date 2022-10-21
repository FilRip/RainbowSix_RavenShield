//================================================================================
// R6WindowListAreaItem.
//================================================================================
class R6WindowListAreaItem extends UWindowListBoxItem;

var R6WindowArea m_Area;

function SetFront ()
{
	if ( m_Area != None )
	{
		m_Area.BringToFront();
	}
}

function SetBack ()
{
	if ( m_Area != None )
	{
		m_Area.SendToBack();
	}
}