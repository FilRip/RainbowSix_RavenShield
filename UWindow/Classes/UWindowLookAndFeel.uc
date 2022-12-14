//================================================================================
// UWindowLookAndFeel.
//================================================================================
class UWindowLookAndFeel extends UWindowBase;

var() int FrameTitleX;
var() int FrameTitleY;
var() int ColumnHeadingHeight;
var() int EditBoxBevel;
var() float Size_ComboHeight;
var() float Size_ComboButtonWidth;
var() float Size_ScrollbarWidth;
var() float Size_ScrollbarButtonHeight;
var() float Size_MinScrollbarHeight;
var() float Size_TabAreaHeight;
var() float Size_TabAreaOverhangHeight;
var() float Size_TabSpacing;
var() float Size_TabXOffset;
var() float Size_TabTextOffset;
var() float Pulldown_ItemHeight;
var() float Pulldown_VBorder;
var() float Pulldown_HBorder;
var() float Pulldown_TextBorder;
var() Texture Active;
var() Texture Inactive;
var() Texture ActiveS;
var() Texture InactiveS;
var() Texture Misc;
var() Region FrameTL;
var() Region FrameT;
var() Region FrameTR;
var() Region FrameL;
var() Region FrameR;
var() Region FrameBL;
var() Region FrameB;
var() Region FrameBR;
var() Color FrameActiveTitleColor;
var() Color FrameInactiveTitleColor;
var() Color HeadingActiveTitleColor;
var() Color HeadingInActiveTitleColor;
var() Region BevelUpTL;
var() Region BevelUpT;
var() Region BevelUpTR;
var() Region BevelUpL;
var() Region BevelUpR;
var() Region BevelUpBL;
var() Region BevelUpB;
var() Region BevelUpBR;
var() Region BevelUpArea;
var() Region MiscBevelTL[4];
var() Region MiscBevelT[4];
var() Region MiscBevelTR[4];
var() Region MiscBevelL[4];
var() Region MiscBevelR[4];
var() Region MiscBevelBL[4];
var() Region MiscBevelB[4];
var() Region MiscBevelBR[4];
var() Region MiscBevelArea[4];
var() Region ComboBtnUp;
var() Region ComboBtnDown;
var() Region ComboBtnDisabled;
var() Region ComboBtnOver;
var() Region HLine;
var() Color EditBoxTextColor;
var() Region TabSelectedL;
var() Region TabSelectedM;
var() Region TabSelectedR;
var() Region TabUnselectedL;
var() Region TabUnselectedM;
var() Region TabUnselectedR;
var() Region TabBackground;

function Texture GetTexture (UWindowFramedWindow W)
{
	if ( W.bStatusBar )
	{
		if ( W.IsActive() )
		{
			return ActiveS;
		}
		else
		{
			return InactiveS;
		}
	}
	else
	{
		if ( W.IsActive() )
		{
			return Active;
		}
		else
		{
			return Inactive;
		}
	}
}

function Setup ();

function FW_DrawWindowFrame (UWindowFramedWindow W, Canvas C);

function Region FW_GetClientArea (UWindowFramedWindow W);

function FrameHitTest FW_HitTest (UWindowFramedWindow W, float X, float Y);

function FW_SetupFrameButtons (UWindowFramedWindow W, Canvas C);

function DrawClientArea (UWindowClientWindow W, Canvas C);

function Combo_SetupSizes (UWindowComboControl W, Canvas C);

function Combo_Draw (UWindowComboControl W, Canvas C);

function Combo_SetupButton (UWindowComboButton W);

function Combo_SetupLeftButton (UWindowComboLeftButton W);

function Combo_SetupRightButton (UWindowComboRightButton W);

function ComboList_DrawBackground (UWindowComboList W, Canvas C);

function ComboList_DrawItem (UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected);

function Editbox_SetupSizes (UWindowEditControl W, Canvas C);

function Editbox_Draw (UWindowEditControl W, Canvas C);

function SB_SetupUpButton (UWindowSBUpButton W);

function SB_SetupDownButton (UWindowSBDownButton W);

function SB_SetupLeftButton (UWindowSBLeftButton W);

function SB_SetupRightButton (UWindowSBRightButton W);

function SB_VDraw (UWindowVScrollbar W, Canvas C);

function SB_HDraw (UWindowHScrollbar W, Canvas C);

function Tab_DrawTab (UWindowTabControlTabArea Tab, Canvas C, bool bActiveTab, bool bLeftmostTab, float X, float Y, float W, float H, string Text, bool bShowText);

function Tab_GetTabSize (UWindowTabControlTabArea Tab, Canvas C, string Text, out float W, out float H);

function Tab_SetupLeftButton (UWindowTabControlLeftButton W);

function Tab_SetupRightButton (UWindowTabControlRightButton W);

function Tab_SetTabPageSize (UWindowPageControl W, UWindowPageWindow P);

function Tab_DrawTabPageArea (UWindowPageControl W, Canvas C, UWindowPageWindow P);

function Menu_DrawMenuBar (UWindowMenuBar W, Canvas C);

function Menu_DrawMenuBarItem (UWindowMenuBar B, UWindowMenuBarItem i, float X, float Y, float W, float H, Canvas C);

function Menu_DrawPulldownMenuBackground (UWindowPulldownMenu W, Canvas C);

function Menu_DrawPulldownMenuItem (UWindowPulldownMenu M, UWindowPulldownMenuItem Item, Canvas C, float X, float Y, float W, float H, bool bSelected);

function Button_DrawSmallButton (UWindowSmallButton B, Canvas C);

function PlayMenuSound (UWindowWindow W, MenuSound S);

function ControlFrame_SetupSizes (UWindowControlFrame W, Canvas C);

function ControlFrame_Draw (UWindowControlFrame W, Canvas C);

function DrawSimpleBorder (UWindowWindow W, Canvas C);
