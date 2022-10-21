//================================================================================
// R6WindowSimpleFramedWindowExt.
//================================================================================
class R6WindowSimpleFramedWindowExt extends UWindowWindow;

struct stBorderForm
{
	var Color vColor;
	var float fXPos;
	var float fYPos;
	var float fWidth;
	var bool bActive;
};

enum eCornerType {
	No_Corners,
	Top_Corners,
	Bottom_Corners,
	All_Corners
};

enum eBorderType {
	Border_Top,
	Border_Bottom,
	Border_Left,
	Border_Right
};

var eCornerType m_eCornerType;
var int m_DrawStyle;
var bool m_bNoBorderToDraw;
var bool m_bDrawBackGround;
var float m_fHBorderHeight;
var float m_fVBorderWidth;
var float m_fHBorderPadding;
var float m_fVBorderPadding;
var float m_fHBorderOffset;
var float m_fVBorderOffset;
var Texture m_BGTexture;
var Texture m_HBorderTexture;
var Texture m_VBorderTexture;
var Texture m_topLeftCornerT;
var UWindowWindow m_ClientArea;
var Class<UWindowWindow> m_ClientClass;
var Region m_BGTextureRegion;
var Region m_HBorderTextureRegion;
var Region m_VBorderTextureRegion;
var Region m_topLeftCornerR;
var stBorderForm m_sBorderForm[4];
var Color m_eCornerColor[4];
var Color m_vBGColor;

function Created ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 4 )
	{
		m_sBorderForm[i].vColor=Root.Colors.BlueLight;
		m_sBorderForm[i].fXPos=0.00;
		m_sBorderForm[i].fYPos=0.00;
		m_sBorderForm[i].fWidth=1.00;
		m_sBorderForm[i].bActive=False;
		i++;
		goto JL0007;
	}
	m_eCornerColor[3]=Root.Colors.BlueLight;
	m_eCornerColor[1]=Root.Colors.BlueLight;
	m_eCornerColor[2]=Root.Colors.BlueLight;
}

function CreateClientWindow (Class<UWindowWindow> ClientClass)
{
	m_ClientClass=ClientClass;
	m_ClientArea=CreateWindow(m_ClientClass,0.00,0.00,WinWidth,WinHeight,OwnerWindow);
}

function Paint (Canvas C, float X, float Y)
{
	if ( m_bDrawBackGround )
	{
		C.Style=m_DrawStyle;
		C.SetDrawColor(m_vBGColor.R,m_vBGColor.G,m_vBGColor.B);
		DrawStretchedTextureSegment(C,0.00,1.00,WinWidth,WinHeight - 1,m_BGTextureRegion.X,m_BGTextureRegion.Y,m_BGTextureRegion.W,m_BGTextureRegion.H,m_BGTexture);
	}
}

function AfterPaint (Canvas C, float X, float Y)
{
	local Color vBorderColor;
	local Color vCornerColor;

	C.Style=m_DrawStyle;
	vBorderColor=Root.Colors.BlueLight;
	C.SetDrawColor(vBorderColor.R,vBorderColor.G,vBorderColor.B);
	if ( m_sBorderForm[0].bActive )
	{
		if ( m_sBorderForm[0].vColor!=vBorderColor )
		{
			vBorderColor=m_sBorderForm[0].vColor;
			C.SetDrawColor(vBorderColor.R,vBorderColor.G,vBorderColor.B);
		}
		DrawStretchedTextureSegment(C,m_sBorderForm[0].fXPos,m_sBorderForm[0].fYPos,WinWidth - 2 * m_sBorderForm[0].fXPos,m_sBorderForm[0].fWidth,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
	}
	if ( m_sBorderForm[1].bActive )
	{
		if ( m_sBorderForm[1].vColor!=vBorderColor )
		{
			vBorderColor=m_sBorderForm[1].vColor;
			C.SetDrawColor(vBorderColor.R,vBorderColor.G,vBorderColor.B);
		}
		DrawStretchedTextureSegment(C,m_sBorderForm[1].fXPos,WinHeight - m_sBorderForm[1].fWidth - m_sBorderForm[1].fYPos,WinWidth - 2 * m_sBorderForm[1].fXPos,m_sBorderForm[1].fWidth,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
	}
	if ( m_sBorderForm[2].bActive )
	{
		if ( m_sBorderForm[2].vColor!=vBorderColor )
		{
			vBorderColor=m_sBorderForm[2].vColor;
			C.SetDrawColor(vBorderColor.R,vBorderColor.G,vBorderColor.B);
		}
		DrawStretchedTextureSegment(C,m_sBorderForm[2].fXPos,m_sBorderForm[2].fYPos,m_sBorderForm[2].fWidth,WinHeight - 2 * m_sBorderForm[2].fYPos,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
	}
	if ( m_sBorderForm[3].bActive )
	{
		if ( m_sBorderForm[3].vColor!=vBorderColor )
		{
			vBorderColor=m_sBorderForm[3].vColor;
			C.SetDrawColor(vBorderColor.R,vBorderColor.G,vBorderColor.B);
		}
		DrawStretchedTextureSegment(C,WinWidth - m_sBorderForm[3].fWidth - m_sBorderForm[3].fXPos,m_sBorderForm[3].fYPos,m_sBorderForm[3].fWidth,WinHeight - 2 * m_sBorderForm[3].fYPos,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
	}
	vCornerColor=Root.Colors.BlueLight;
	if ( m_eCornerType != 0 )
	{
		switch (m_eCornerType)
		{
/*			case 3:
			if ( m_eCornerColor[3]!=vCornerColor )
			{
				vCornerColor=m_eCornerColor[3];
				C.SetDrawColor(vCornerColor.R,vCornerColor.G,vCornerColor.B);
			}
			case 1:
			if ( m_eCornerColor[1]!=vCornerColor )
			{
				vCornerColor=m_eCornerColor[1];
				C.SetDrawColor(vCornerColor.R,vCornerColor.G,vCornerColor.B);
			}
			if ( m_topLeftCornerT != None )
			{
				DrawStretchedTextureSegment(C,0.00,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerT);
				DrawStretchedTextureSegment(C,WinWidth - m_topLeftCornerR.W,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y, -m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerT);
			}
			if ( m_eCornerType != 3 )
			{
				goto JL07C9;
			}
			case 2:
			if ( m_eCornerColor[2]!=vCornerColor )
			{
				vCornerColor=m_eCornerColor[2];
				C.SetDrawColor(vCornerColor.R,vCornerColor.G,vCornerColor.B);
			}
			if ( m_topLeftCornerT != None )
			{
				DrawStretchedTextureSegment(C,0.00,WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y + m_topLeftCornerR.H,m_topLeftCornerR.W, -m_topLeftCornerR.H,m_topLeftCornerT);
				DrawStretchedTextureSegment(C,WinWidth - m_topLeftCornerR.W,WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y + m_topLeftCornerR.H, -m_topLeftCornerR.W, -m_topLeftCornerR.H,m_topLeftCornerT);
			}
			break;
			default:*/
		}
	}
	else
	{
	}
JL07C9:
}

function SetBorderParam (int _iBorderType, float _X, float _Y, float _fWidth, Color _vColor)
{
	m_sBorderForm[_iBorderType].fXPos=_X;
	m_sBorderForm[_iBorderType].fYPos=_Y;
	m_sBorderForm[_iBorderType].vColor=_vColor;
	m_sBorderForm[_iBorderType].fWidth=_fWidth;
	m_sBorderForm[_iBorderType].bActive=True;
	m_bNoBorderToDraw=False;
}

function ActiveBorder (int _iBorderType, bool _Active)
{
	local int i;
	local bool bNoBorderToDraw;

	m_sBorderForm[_iBorderType].bActive=_Active;
	bNoBorderToDraw=True;
	i=0;
JL0027:
	if ( i < 4 )
	{
		if ( m_sBorderForm[i].bActive )
		{
			bNoBorderToDraw=False;
		}
		i++;
		goto JL0027;
	}
	m_bNoBorderToDraw=bNoBorderToDraw;
}

function SetNoBorder ()
{
	m_bNoBorderToDraw=True;
}

function ActiveBackGround (bool _bActivate, Color _vBGColor)
{
	m_bDrawBackGround=_bActivate;
	m_vBGColor=_vBGColor;
}

function SetCornerColor (int _iCornerType, Color _Color)
{
	if ( _iCornerType == 3 )
	{
		m_eCornerColor[1]=_Color;
		m_eCornerColor[2]=_Color;
	}
	m_eCornerColor[_iCornerType]=_Color;
}

function bool GetActivateBorder ()
{
	return m_bNoBorderToDraw;
}

defaultproperties
{
    m_DrawStyle=5
    m_fHBorderHeight=2.00
    m_fVBorderWidth=2.00
    m_fHBorderPadding=7.00
    m_fVBorderPadding=2.00
    m_fVBorderOffset=1.00
    m_ClientClass=Class'UWindow.UWindowClientWindow'
    m_BGTextureRegion=(X=5054987,Y=571277312,W=31,H=533001)
    m_HBorderTextureRegion=(X=4203019,Y=571277312,W=56,H=74249)
    m_VBorderTextureRegion=(X=4203019,Y=571277312,W=56,H=74249)
    m_topLeftCornerR=(X=795147,Y=571277312,W=56,H=401929)
}
/*
    m_BGTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_HBorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_VBorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_topLeftCornerT=Texture'R6MenuTextures.Gui_BoxScroll'
*/

