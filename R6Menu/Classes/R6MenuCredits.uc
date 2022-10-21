//================================================================================
// R6MenuCredits.
//================================================================================
class R6MenuCredits extends UWindowListControl;

var int m_iScrollIndex;
var int m_iScrollStep;
var bool m_bStopScroll;
var float m_fScrollSpeed;
var float m_fTexScrollSpeed;
var float m_fScrollIndex;
var float m_fYScrollEffect;
var float m_fDelta;
var UWindowList m_FirstItemOnScreen;

function Tick (float fDelta)
{
	m_fDelta=fDelta;
}

function Paint (Canvas C, float X, float Y)
{
	PaintCredits(C);
	PaintTexEffect(C);
}

function PaintTexEffect (Canvas C)
{
	local Texture TexScrollEffect;

	C.Style=7;
//	TexScrollEffect=Texture'Line';
	if (  !m_bStopScroll )
	{
		m_fYScrollEffect -= m_fDelta * m_fScrollSpeed * 2;
		if ( m_fYScrollEffect <  -TexScrollEffect.VSize )
		{
			m_fYScrollEffect += TexScrollEffect.VSize;
		}
	}
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	C.SetPos(0.00,0.00);
	C.DrawTile(TexScrollEffect,WinWidth,WinHeight,0.00,m_fYScrollEffect,TexScrollEffect.USize,TexScrollEffect.VSize);
}

function PaintCredits (Canvas C)
{
	local UWindowList CurItem;
	local R6WindowListBoxCreditsItem R6CurItem;
	local float y1;
	local float iCurrentYPos;
	local bool bStopNextTime;

	if ( m_FirstItemOnScreen == None )
	{
		m_FirstItemOnScreen=Items.Next;
		m_iScrollIndex=0;
	}
	else
	{
		if (  !m_bStopScroll )
		{
			m_fScrollIndex += m_fDelta * m_fScrollSpeed;
			m_iScrollIndex -= m_fScrollIndex;
			if ( m_fScrollIndex > m_iScrollStep )
			{
				m_fScrollIndex=0.00;
			}
			if ( Abs(m_iScrollIndex) > R6WindowListBoxCreditsItem(m_FirstItemOnScreen).m_fHeight )
			{
				m_FirstItemOnScreen=m_FirstItemOnScreen.Next;
				m_iScrollIndex=-1;
			}
		}
	}
	CurItem=m_FirstItemOnScreen;
	R6CurItem=R6WindowListBoxCreditsItem(CurItem);
	y1=m_iScrollIndex;
JL00D9:
	if ( CurItem != None )
	{
		DrawItem(C,CurItem,0.00,y1,WinWidth,R6CurItem.m_fHeight);
		y1=y1 + R6CurItem.m_fHeight;
		CurItem=CurItem.Next;
		if ( (CurItem == None) || bStopNextTime )
		{
			goto JL0193;
		}
		R6CurItem=R6WindowListBoxCreditsItem(CurItem);
		if ( y1 + R6CurItem.m_fHeight > WinHeight )
		{
			bStopNextTime=True;
		}
		goto JL00D9;
	}
JL0193:
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local float fXPos;
	local float fYPos;
	local float fW;
	local float fH;
	local R6WindowListBoxCreditsItem pItem;

	pItem=R6WindowListBoxCreditsItem(Item);
	if (  !pItem.m_bConvertItemValue )
	{
		if (  !ConvertItemValue(C,pItem) )
		{
			return;
		}
		pItem.m_bConvertItemValue=True;
	}
	C.Style=5;
	C.Font=pItem.m_Font;
	C.SetDrawColor(pItem.m_TextColor.R,pItem.m_TextColor.G,pItem.m_TextColor.B,225);
	fXPos=X + pItem.m_iXPosOffset;
	fYPos=Y + pItem.m_iYPosOffset;
	ClipText(C,fXPos,fYPos,pItem.m_szName);
	if ( pItem.m_bDrawALineUnderText )
	{
		TextSize(C,pItem.m_szName,fW,fH);
		fYPos += fH;
		if ( (fYPos > 0) && (fYPos < WinHeight) )
		{
			DrawStretchedTextureSegment(C,fXPos,fYPos,fW,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
		}
	}
}

function bool ConvertItemValue (Canvas C, out R6WindowListBoxCreditsItem _pItemToConvert)
{
	local string szTemp;
	local float fTemp;
	local float fTextW;
	local float fTextH;

	if ( _pItemToConvert == None )
	{
		return False;
	}
	_pItemToConvert.m_Font=Root.Fonts[_pItemToConvert.m_iFont];
	switch (_pItemToConvert.m_iColor)
	{
		case 0:
		_pItemToConvert.m_TextColor=Root.Colors.BlueLight;
		break;
		case 1:
		_pItemToConvert.m_TextColor=Root.Colors.White;
		break;
		default:
		_pItemToConvert.m_TextColor=Root.Colors.White;
		break;
	}
	C.Font=_pItemToConvert.m_Font;
	szTemp=_pItemToConvert.m_szName;
	szTemp=TextSize(C,szTemp,fTextW,fTextH,WinWidth);
	_pItemToConvert.m_szName=szTemp;
	fTemp=(WinWidth - fTextW) / 2;
	_pItemToConvert.m_iXPosOffset=fTemp + 0.50;
	fTemp=(_pItemToConvert.m_fHeight - fTextH) / 2;
	_pItemToConvert.m_iYPosOffset=fTemp + 0.50;
	return True;
}

function ResetCredits ()
{
	m_FirstItemOnScreen=None;
	m_fScrollIndex=0.00;
	m_fYScrollEffect=0.00;
	m_bStopScroll=False;
}

defaultproperties
{
    m_iScrollStep=1
    m_fScrollSpeed=25.00
    m_fTexScrollSpeed=1.00
    ListClass=Class'R6Window.R6WindowListBoxCreditsItem'
}
