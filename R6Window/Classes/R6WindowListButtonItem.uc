//================================================================================
// R6WindowListButtonItem.
//================================================================================
class R6WindowListButtonItem extends UWindowListBoxItem;

var R6WindowButton m_Button;

function SetFront ()
{
	if ( m_Button != None )
	{
		m_Button.BringToFront();
	}
}

function SetBack ()
{
	if ( m_Button != None )
	{
		m_Button.SendToBack();
	}
}