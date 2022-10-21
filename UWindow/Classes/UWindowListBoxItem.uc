//================================================================================
// UWindowListBoxItem.
//================================================================================
class UWindowListBoxItem extends UWindowList;

struct stItemProperties
{
	var string szText;
	var Font TextFont;
	var float fXPos;
	var float fYPos;
	var float fWidth;
	var float fHeigth;
	var int iLineNumber;
	var TextAlign eAlignment;
};

struct stCoordItem
{
	var float fXPos;
	var float fWidth;
};

struct stSubTextBox
{
	var string szGameTypeSelect;
	var float fXOffset;
	var float fHeight;
	var Font FontSubText;
};

var int m_iFontIndex;
var int m_iItemID;
var int m_iItemGameType;
var bool bSelected;
var bool m_bUseSubText;
var bool m_bImALine;
var bool m_bNotAffectByNotify;
var bool m_bDisabled;
var float m_fXFakeEditBox;
var float m_fWFakeEditBox;
var array<stItemProperties> m_AItemProperties;
var stSubTextBox m_stSubText;
var Color m_vItemColor;
var string HelpText;
var string m_szToolTip;
var string m_szFakeEditBoxValue;
var string m_szActionKey;

function int Compare (UWindowList t, UWindowList B)
{
	local string TS;
	local string BS;

	TS=UWindowListBoxItem(t).HelpText;
	BS=UWindowListBoxItem(B).HelpText;
	if ( TS == "NONE" )
	{
		return -1;
	}
	else
	{
		if ( BS == "NONE" )
		{
			return 1;
		}
	}
	if ( TS == BS )
	{
		return 0;
	}
	if ( TS < BS )
	{
		return -1;
	}
	return 1;
}

function ClearItem ()
{
	bSelected=False;
	m_bShowThisItem=False;
}

function SetItemParameters (int _index, string _szText, Font _TextFont, float _fX, float _fY, float _fW, float _fH, int _iLineNumber, optional TextAlign _eAlignement)
{
	local stItemProperties stItemParam;

	if ( _index <= m_AItemProperties.Length )
	{
		stItemParam.szText=_szText;
		stItemParam.TextFont=_TextFont;
		stItemParam.fXPos=_fX;
		stItemParam.fYPos=_fY;
		stItemParam.fWidth=_fW;
		stItemParam.fHeigth=_fH;
		stItemParam.iLineNumber=_iLineNumber;
		stItemParam.eAlignment=_eAlignement;
		m_AItemProperties[_index]=stItemParam;
	}
}
