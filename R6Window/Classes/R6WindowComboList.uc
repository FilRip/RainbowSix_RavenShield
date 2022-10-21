//================================================================================
// R6WindowComboList.
//================================================================================
class R6WindowComboList extends UWindowComboList;

var ERenderStyle m_BGRenderStyle;
var ERenderStyle m_BGSelRenderStyle;
var Texture m_BGSelTexture;
var Class<UWindowVScrollbar> m_SBClass;
var Color m_BGColor;
var Color m_BGSelColor;
var Region m_BGSelRegion;
var Color m_SelTextColor;
var Color m_DisableTextColor;

function Created ()
{
	Super.Created();
	TextColor=Root.Colors.m_LisBoxNormalTextColor;
	m_SelTextColor=Root.Colors.m_LisBoxSelectedTextColor;
	m_DisableTextColor=Root.Colors.m_LisBoxDisabledTextColor;
	m_BGSelColor=Root.Colors.m_LisBoxSelectionColor;
//	m_BGRenderStyle=1;
//	m_BGSelRenderStyle=5;
	m_BGColor=Root.Colors.m_ComboBGColor;
}

function Setup ()
{
	VertSB=UWindowVScrollbar(CreateWindow(m_SBClass,WinWidth - LookAndFeel.Size_ScrollbarWidth,0.00,LookAndFeel.Size_ScrollbarWidth,WinHeight));
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local int Count;
	local UWindowComboListItem i;
	local float ListX;
	local float ListY;

	Count=Items.Count();
	if ( Count > MaxVisible )
	{
		WinHeight=ItemHeight * MaxVisible + VBorder * 2;
	}
	else
	{
		VertSB.pos=0.00;
		WinHeight=ItemHeight * Count + VBorder * 2;
	}
	ListX=Owner.EditBox.WinLeft;
	ListY=Owner.Button.WinTop + Owner.Button.WinHeight - 1;
	if ( Count > MaxVisible )
	{
		VertSB.ShowWindow();
		VertSB.SetRange(0.00,Count,MaxVisible);
		VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinTop=0.00;
		VertSB.SetSize(LookAndFeel.Size_ScrollbarWidth,WinHeight);
	}
	else
	{
		VertSB.HideWindow();
	}
	Owner.WindowToGlobal(ListX,ListY,WinLeft,WinTop);
}

function Paint (Canvas C, float X, float Y)
{
	local int Count;
	local UWindowComboListItem i;

	DrawMenuBackground(C);
	Count=0;
	C.Font=Root.Fonts[Font];
	i=UWindowComboListItem(Items.Next);
	while ( i != None )
	{
		if ( VertSB.bWindowVisible )
		{
			if ( (Count >= VertSB.pos) && (Count - VertSB.pos < MaxVisible) )
			{
				DrawItem(C,i,HBorder,VBorder + ItemHeight * (Count - VertSB.pos),WinWidth - 2 * HBorder - VertSB.WinWidth,ItemHeight);
			}
		}
		else
		{
			DrawItem(C,i,HBorder,VBorder + ItemHeight * Count,WinWidth - 2 * HBorder,ItemHeight);
		}
		Count++;
		i=UWindowComboListItem(i.Next);
	}
}

function DrawMenuBackground (Canvas C)
{
	C.Style=m_BGRenderStyle;
	C.SetDrawColor(m_BGColor.R,m_BGColor.G,m_BGColor.B);
	DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawSimpleBorder(C);
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local UWindowComboListItem pComboListItem;

	pComboListItem=UWindowComboListItem(Item);
	if ( Selected == Item )
	{
		C.Style=m_BGSelRenderStyle;
		C.SetDrawColor(m_BGSelColor.R,m_BGSelColor.G,m_BGSelColor.B);
		DrawStretchedTextureSegment(C,X,Y,W,H,m_BGSelRegion.X,m_BGSelRegion.Y,m_BGSelRegion.W,m_BGSelRegion.H,m_BGSelTexture);
		C.SetDrawColor(m_SelTextColor.R,m_SelTextColor.G,m_SelTextColor.B);
	}
	else
	{
		if ( pComboListItem.bDisabled )
		{
			C.SetDrawColor(m_DisableTextColor.R,m_DisableTextColor.G,m_DisableTextColor.B);
		}
		else
		{
			C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
		}
	}
	ClipText(C,X + TextBorder + 2,Y + 3,pComboListItem.Value);
}

defaultproperties
{
    m_SBClass=Class'R6WindowVScrollbar'
    m_BGSelRegion=(X=16589323,Y=571015168,W=2,H=860680)
}
/*
    m_BGSelTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

