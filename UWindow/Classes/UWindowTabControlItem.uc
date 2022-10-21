//================================================================================
// UWindowTabControlItem.
//================================================================================
class UWindowTabControlItem extends UWindowList;

var int RowNumber;
var int m_iItemID;
var bool bFlash;
var bool m_bMouseOverItem;
var float TabTop;
var float TabLeft;
var float TabWidth;
var float TabHeight;
var float m_fFixWidth;
var UWindowTabControl Owner;
var Color m_vSelectedColor;
var Color m_vNormalColor;
var string Caption;
var string HelpText;

function SetCaption (string NewCaption)
{
	Caption=NewCaption;
}

function RightClickTab ()
{
}

function SetFixTabSize (float _fFixTabWidth)
{
	m_fFixWidth=_fFixTabWidth;
}

function SetItemColor (Color _vSelected, Color _vNormal)
{
	m_vSelectedColor=_vSelected;
	m_vNormalColor=_vNormal;
}
