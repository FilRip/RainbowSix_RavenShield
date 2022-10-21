//================================================================================
// UWindowWin95LookAndFeel.
//================================================================================
class UWindowWin95LookAndFeel extends UWindowLookAndFeel;

const BRSIZEBORDER= 15;
const SIZEBORDER= 3;
var() int CloseBoxOffsetX;
var() int CloseBoxOffsetY;
var() Region SBUpUp;
var() Region SBUpDown;
var() Region SBUpDisabled;
var() Region SBDownUp;
var() Region SBDownDown;
var() Region SBDownDisabled;
var() Region SBLeftUp;
var() Region SBLeftDown;
var() Region SBLeftDisabled;
var() Region SBRightUp;
var() Region SBRightDown;
var() Region SBRightDisabled;
var() Region SBBackground;
var() Region FrameSBL;
var() Region FrameSB;
var() Region FrameSBR;
var() Region CloseBoxUp;
var() Region CloseBoxDown;

function FW_DrawWindowFrame (UWindowFramedWindow W, Canvas C)
{
	local Texture t;
	local Region R;
	local Region temp;

	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	t=W.GetLookAndFeelTexture();
	R=FrameTL;
	W.DrawStretchedTextureSegment(C,0.00,0.00,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameT;
	W.DrawStretchedTextureSegment(C,FrameTL.W,0.00,W.WinWidth - FrameTL.W - FrameTR.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameTR;
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,0.00,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	if ( W.bStatusBar )
	{
		temp=FrameSBL;
	}
	else
	{
		temp=FrameBL;
	}
	R=FrameL;
	W.DrawStretchedTextureSegment(C,0.00,FrameTL.H,R.W,W.WinHeight - FrameTL.H - temp.H,R.X,R.Y,R.W,R.H,t);
	R=FrameR;
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,FrameTL.H,R.W,W.WinHeight - FrameTL.H - temp.H,R.X,R.Y,R.W,R.H,t);
	if ( W.bStatusBar )
	{
		R=FrameSBL;
	}
	else
	{
		R=FrameBL;
	}
	W.DrawStretchedTextureSegment(C,0.00,W.WinHeight - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	if ( W.bStatusBar )
	{
		R=FrameSB;
		W.DrawStretchedTextureSegment(C,FrameBL.W,W.WinHeight - R.H,W.WinWidth - FrameSBL.W - FrameSBR.W,R.H,R.X,R.Y,R.W,R.H,t);
	}
	else
	{
		R=FrameB;
		W.DrawStretchedTextureSegment(C,FrameBL.W,W.WinHeight - R.H,W.WinWidth - FrameBL.W - FrameBR.W,R.H,R.X,R.Y,R.W,R.H,t);
	}
	if ( W.bStatusBar )
	{
		R=FrameSBR;
	}
	else
	{
		R=FrameBR;
	}
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,W.WinHeight - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
//	C.Font=W.Root.Fonts[W.0];
	if ( W.ParentWindow.ActiveWindow == W )
	{
		C.DrawColor=FrameActiveTitleColor;
	}
	else
	{
		C.DrawColor=FrameInactiveTitleColor;
	}
	W.ClipTextWidth(C,FrameTitleX,FrameTitleY,W.WindowTitle,W.WinWidth - 22);
	if ( W.bStatusBar )
	{
		C.DrawColor.R=0;
		C.DrawColor.G=0;
		C.DrawColor.B=0;
		W.ClipTextWidth(C,6.00,W.WinHeight - 13,W.StatusBarText,W.WinWidth - 22);
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
	}
}

function FW_SetupFrameButtons (UWindowFramedWindow W, Canvas C)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.CloseBox.WinLeft=W.WinWidth - CloseBoxOffsetX - CloseBoxUp.W;
	W.CloseBox.WinTop=CloseBoxOffsetY;
	W.CloseBox.SetSize(CloseBoxUp.W,CloseBoxUp.H);
	W.CloseBox.bUseRegion=True;
	W.CloseBox.UpTexture=t;
	W.CloseBox.DownTexture=t;
	W.CloseBox.OverTexture=t;
	W.CloseBox.DisabledTexture=t;
	W.CloseBox.UpRegion=CloseBoxUp;
	W.CloseBox.DownRegion=CloseBoxDown;
	W.CloseBox.OverRegion=CloseBoxUp;
	W.CloseBox.DisabledRegion=CloseBoxUp;
}

function Region FW_GetClientArea (UWindowFramedWindow W)
{
	local Region R;

	R.X=FrameL.W;
	R.Y=FrameT.H;
	R.W=W.WinWidth - FrameL.W + FrameR.W;
	if ( W.bStatusBar )
	{
		R.H=W.WinHeight - FrameT.H + FrameSB.H;
	}
	else
	{
		R.H=W.WinHeight - FrameT.H + FrameB.H;
	}
	return R;
}

function FrameHitTest FW_HitTest (UWindowFramedWindow W, float X, float Y)
{
	if ( (X >= 3) && (X <= W.WinWidth - 3) && (Y >= 3) && (Y <= 14) )
	{
		return HT_TitleBar;
	}
	if ( (X < 15) && (Y < 3) || (X < 3) && (Y < 15) )
	{
		return HT_NW;
	}
	if ( (X > W.WinWidth - 3) && (Y < 15) || (X > W.WinWidth - 15) && (Y < 3) )
	{
		return HT_NE;
	}
	if ( (X < 15) && (Y > W.WinHeight - 3) || (X < 3) && (Y > W.WinHeight - 15) )
	{
		return HT_SW;
	}
	if ( (X > W.WinWidth - 15) && (Y > W.WinHeight - 15) )
	{
		return HT_SE;
	}
	if ( Y < 3 )
	{
		return HT_N;
	}
	if ( Y > W.WinHeight - 3 )
	{
		return HT_S;
	}
	if ( X < 3 )
	{
		return HT_W;
	}
	if ( X > W.WinWidth - 3 )
	{
		return HT_E;
	}
	return HT_None;
}

function DrawClientArea (UWindowClientWindow W, Canvas C)
{
//	W.DrawStretchedTexture(C,0.00,0.00,W.WinWidth,W.WinHeight,Texture'BlackTexture');
}

function Combo_SetupSizes (UWindowComboControl W, Canvas C)
{
	local float tW;
	local float tH;

	C.Font=W.Root.Fonts[W.Font];
	W.TextSize(C,W.Text,tW,tH);
	W.WinHeight=12.00 + MiscBevelT[2].H + MiscBevelB[2].H;
	switch (W.Align)
	{
		case TA_Left:
		W.EditAreaDrawX=W.WinWidth - W.EditBoxWidth;
		W.TextX=0.00;
		break;
		case TA_Right:
		W.EditAreaDrawX=0.00;
		W.TextX=W.WinWidth - tW;
		break;
		case TA_Center:
		W.EditAreaDrawX=(W.WinWidth - W.EditBoxWidth) / 2;
		W.TextX=(W.WinWidth - tW) / 2;
		break;
		default:
	}
	W.EditAreaDrawY=(W.WinHeight - 2) / 2;
	W.TextY=(W.WinHeight - tH) / 2;
	W.EditBox.WinLeft=W.EditAreaDrawX + MiscBevelL[2].W;
	W.EditBox.WinTop=MiscBevelT[2].H;
	W.Button.WinWidth=ComboBtnUp.W;
	if ( W.bButtons )
	{
		W.EditBox.WinWidth=W.EditBoxWidth - MiscBevelL[2].W - MiscBevelR[2].W - ComboBtnUp.W - SBLeftUp.W - SBRightUp.W;
		W.EditBox.WinHeight=W.WinHeight - MiscBevelT[2].H - MiscBevelB[2].H;
		W.Button.WinLeft=W.WinWidth - ComboBtnUp.W - MiscBevelR[2].W - SBLeftUp.W - SBRightUp.W;
		W.Button.WinTop=W.EditBox.WinTop;
		W.LeftButton.WinLeft=W.WinWidth - MiscBevelR[2].W - SBLeftUp.W - SBRightUp.W;
		W.LeftButton.WinTop=W.EditBox.WinTop;
		W.RightButton.WinLeft=W.WinWidth - MiscBevelR[2].W - SBRightUp.W;
		W.RightButton.WinTop=W.EditBox.WinTop;
		W.LeftButton.WinWidth=SBLeftUp.W;
		W.LeftButton.WinHeight=SBLeftUp.H;
		W.RightButton.WinWidth=SBRightUp.W;
		W.RightButton.WinHeight=SBRightUp.H;
	}
	else
	{
		W.EditBox.WinWidth=W.EditBoxWidth - MiscBevelL[2].W - MiscBevelR[2].W - ComboBtnUp.W;
		W.EditBox.WinHeight=W.WinHeight - MiscBevelT[2].H - MiscBevelB[2].H;
		W.Button.WinLeft=W.WinWidth - ComboBtnUp.W - MiscBevelR[2].W;
		W.Button.WinTop=W.EditBox.WinTop;
	}
	W.Button.WinHeight=W.EditBox.WinHeight;
}

function Combo_Draw (UWindowComboControl W, Canvas C)
{
	W.DrawMiscBevel(C,W.EditAreaDrawX,0.00,W.EditBoxWidth,W.WinHeight,Misc,2);
	if ( W.Text != "" )
	{
		C.DrawColor=W.TextColor;
		W.ClipText(C,W.TextX,W.TextY,W.Text);
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
	}
}

function ComboList_DrawBackground (UWindowComboList W, Canvas C)
{
/*	W.DrawClippedTexture(C,0.00,0.00,Texture'MenuTL');
	W.DrawStretchedTexture(C,4.00,0.00,W.WinWidth - 8,4.00,Texture'MenuT');
	W.DrawClippedTexture(C,W.WinWidth - 4,0.00,Texture'MenuTR');
	W.DrawClippedTexture(C,0.00,W.WinHeight - 4,Texture'MenuBL');
	W.DrawStretchedTexture(C,4.00,W.WinHeight - 4,W.WinWidth - 8,4.00,Texture'MenuB');
	W.DrawClippedTexture(C,W.WinWidth - 4,W.WinHeight - 4,Texture'MenuBR');
	W.DrawStretchedTexture(C,0.00,4.00,4.00,W.WinHeight - 8,Texture'MenuL');
	W.DrawStretchedTexture(C,W.WinWidth - 4,4.00,4.00,W.WinHeight - 8,Texture'MenuR');
	W.DrawStretchedTexture(C,4.00,4.00,W.WinWidth - 8,W.WinHeight - 8,Texture'MenuArea');*/
}

function ComboList_DrawItem (UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected)
{
	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	if ( bSelected )
	{
//		Combo.DrawStretchedTexture(C,X,Y,W,H,Texture'MenuHighlight');
		C.DrawColor.R=0;
		C.DrawColor.G=0;
		C.DrawColor.B=0;
	}
	else
	{
		C.DrawColor.R=0;
		C.DrawColor.G=0;
		C.DrawColor.B=0;
	}
	Combo.ClipText(C,X + Combo.TextBorder + 2,Y + 3,Text);
}

function Combo_SetupButton (UWindowComboButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=ComboBtnUp;
	W.DownRegion=ComboBtnDown;
	W.OverRegion=ComboBtnUp;
	W.DisabledRegion=ComboBtnDisabled;
}

function Editbox_SetupSizes (UWindowEditControl W, Canvas C)
{
	local float tW;
	local float tH;
	local int B;

	B=EditBoxBevel;
	C.Font=W.Root.Fonts[W.Font];
	W.TextSize(C,W.Text,tW,tH);
	W.WinHeight=12.00 + MiscBevelT[B].H + MiscBevelB[B].H;
	switch (W.Align)
	{
		case TA_Left:
		W.EditAreaDrawX=W.WinWidth - W.EditBoxWidth;
		W.TextX=0.00;
		break;
		case TA_Right:
		W.EditAreaDrawX=0.00;
		W.TextX=W.WinWidth - tW;
		break;
		case TA_Center:
		W.EditAreaDrawX=(W.WinWidth - W.EditBoxWidth) / 2;
		W.TextX=(W.WinWidth - tW) / 2;
		break;
		default:
	}
	W.EditAreaDrawY=(W.WinHeight - 2) / 2;
	W.TextY=(W.WinHeight - tH) / 2;
	W.EditBox.WinLeft=W.EditAreaDrawX + MiscBevelL[B].W;
	W.EditBox.WinTop=MiscBevelT[B].H;
	W.EditBox.WinWidth=W.EditBoxWidth - MiscBevelL[B].W - MiscBevelR[B].W;
	W.EditBox.WinHeight=W.WinHeight - MiscBevelT[B].H - MiscBevelB[B].H;
}

function Editbox_Draw (UWindowEditControl W, Canvas C)
{
	W.DrawMiscBevel(C,W.EditAreaDrawX,0.00,W.EditBoxWidth,W.WinHeight,Misc,EditBoxBevel);
	if ( W.Text != "" )
	{
		C.DrawColor=W.TextColor;
		W.ClipText(C,W.TextX,W.TextY,W.Text);
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
	}
}

function Tab_DrawTab (UWindowTabControlTabArea Tab, Canvas C, bool bActiveTab, bool bLeftmostTab, float X, float Y, float W, float H, string Text, bool bShowText)
{
	local Region R;
	local Texture t;
	local float tW;
	local float tH;

	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	t=Tab.GetLookAndFeelTexture();
	if ( bActiveTab )
	{
		R=TabSelectedL;
		Tab.DrawStretchedTextureSegment(C,X,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
		R=TabSelectedM;
		Tab.DrawStretchedTextureSegment(C,X + TabSelectedL.W,Y,W - TabSelectedL.W - TabSelectedR.W,R.H,R.X,R.Y,R.W,R.H,t);
		R=TabSelectedR;
		Tab.DrawStretchedTextureSegment(C,X + W - R.W,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
//		C.Font=Tab.Root.Fonts[Tab.1];
		C.DrawColor.R=0;
		C.DrawColor.G=0;
		C.DrawColor.B=0;
		if ( bShowText )
		{
			Tab.TextSize(C,Text,tW,tH);
			Tab.ClipText(C,X + (W - tW) / 2,Y + 3,Text,True);
		}
	}
	else
	{
		R=TabUnselectedL;
		Tab.DrawStretchedTextureSegment(C,X,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
		R=TabUnselectedM;
		Tab.DrawStretchedTextureSegment(C,X + TabUnselectedL.W,Y,W - TabUnselectedL.W - TabUnselectedR.W,R.H,R.X,R.Y,R.W,R.H,t);
		R=TabUnselectedR;
		Tab.DrawStretchedTextureSegment(C,X + W - R.W,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
//		C.Font=Tab.Root.Fonts[Tab.0];
		C.DrawColor.R=0;
		C.DrawColor.G=0;
		C.DrawColor.B=0;
		if ( bShowText )
		{
			Tab.TextSize(C,Text,tW,tH);
			Tab.ClipText(C,X + (W - tW) / 2,Y + 4,Text,True);
		}
	}
}

function SB_SetupUpButton (UWindowSBUpButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBUpUp;
	W.DownRegion=SBUpDown;
	W.OverRegion=SBUpUp;
	W.DisabledRegion=SBUpDisabled;
}

function SB_SetupDownButton (UWindowSBDownButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBDownUp;
	W.DownRegion=SBDownDown;
	W.OverRegion=SBDownUp;
	W.DisabledRegion=SBDownDisabled;
}

function SB_SetupLeftButton (UWindowSBLeftButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBLeftUp;
	W.DownRegion=SBLeftDown;
	W.OverRegion=SBLeftUp;
	W.DisabledRegion=SBLeftDisabled;
}

function SB_SetupRightButton (UWindowSBRightButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBRightUp;
	W.DownRegion=SBRightDown;
	W.OverRegion=SBRightUp;
	W.DisabledRegion=SBRightDisabled;
}

function SB_VDraw (UWindowVScrollbar W, Canvas C)
{
	local Region R;
	local Texture t;

	t=W.GetLookAndFeelTexture();
	R=SBBackground;
	W.DrawStretchedTextureSegment(C,0.00,0.00,W.WinWidth,W.WinHeight,R.X,R.Y,R.W,R.H,t);
	if (  !W.bDisabled )
	{
		W.DrawUpBevel(C,0.00,W.ThumbStart,Size_ScrollbarWidth,W.ThumbHeight,t);
	}
}

function SB_HDraw (UWindowHScrollbar W, Canvas C)
{
	local Region R;
	local Texture t;

	t=W.GetLookAndFeelTexture();
	R=SBBackground;
	W.DrawStretchedTextureSegment(C,0.00,0.00,W.WinWidth,W.WinHeight,R.X,R.Y,R.W,R.H,t);
	if (  !W.bDisabled )
	{
		W.DrawUpBevel(C,W.ThumbStart,0.00,W.ThumbWidth,Size_ScrollbarWidth,t);
	}
}

function Tab_SetupLeftButton (UWindowTabControlLeftButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.WinWidth=Size_ScrollbarButtonHeight;
	W.WinHeight=Size_ScrollbarWidth;
	W.WinTop=Size_TabAreaHeight - W.WinHeight;
	W.WinLeft=W.ParentWindow.WinWidth - 2 * W.WinWidth;
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBLeftUp;
	W.DownRegion=SBLeftDown;
	W.OverRegion=SBLeftUp;
	W.DisabledRegion=SBLeftDisabled;
}

function Tab_SetupRightButton (UWindowTabControlRightButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.WinWidth=Size_ScrollbarButtonHeight;
	W.WinHeight=Size_ScrollbarWidth;
	W.WinTop=Size_TabAreaHeight - W.WinHeight;
	W.WinLeft=W.ParentWindow.WinWidth - W.WinWidth;
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBRightUp;
	W.DownRegion=SBRightDown;
	W.OverRegion=SBRightUp;
	W.DisabledRegion=SBRightDisabled;
}

function Tab_SetTabPageSize (UWindowPageControl W, UWindowPageWindow P)
{
	P.WinLeft=2.00;
	P.WinTop=W.TabArea.WinHeight - TabSelectedM.H - TabUnselectedM.H + 3;
	P.SetSize(W.WinWidth - 4,W.WinHeight - W.TabArea.WinHeight - TabSelectedM.H - TabUnselectedM.H - 6);
}

function Tab_DrawTabPageArea (UWindowPageControl W, Canvas C, UWindowPageWindow P)
{
	W.DrawUpBevel(C,0.00,Size_TabAreaHeight,W.WinWidth,W.WinHeight - Size_TabAreaHeight,W.GetLookAndFeelTexture());
}

function Tab_GetTabSize (UWindowTabControlTabArea Tab, Canvas C, string Text, out float W, out float H)
{
	local float tW;
	local float tH;

//	C.Font=Tab.Root.Fonts[Tab.0];
	Tab.TextSize(C,Text,tW,tH);
	W=tW + Size_TabSpacing;
	H=tH;
}

function Menu_DrawMenuBar (UWindowMenuBar W, Canvas C)
{
//	W.DrawStretchedTexture(C,16.00,0.00,W.WinWidth - 32,16.00,Texture'MenuBar');
}

function Menu_DrawMenuBarItem (UWindowMenuBar B, UWindowMenuBarItem i, float X, float Y, float W, float H, Canvas C)
{
	if ( B.Selected == i )
	{
/*		B.DrawClippedTexture(C,X,1.00,Texture'MenuHighlightL');
		B.DrawClippedTexture(C,X + W - 1,1.00,Texture'MenuHighlightR');
		B.DrawStretchedTexture(C,X + 1,1.00,W - 2,16.00,Texture'MenuHighlightM');*/
	}
	C.Font=B.Root.Fonts[0];
	C.DrawColor.R=0;
	C.DrawColor.G=0;
	C.DrawColor.B=0;
	B.ClipText(C,X + B.Spacing / 2,2.00,i.Caption,True);
}

function Menu_DrawPulldownMenuBackground (UWindowPulldownMenu W, Canvas C)
{
/*	W.DrawClippedTexture(C,0.00,0.00,Texture'MenuTL');
	W.DrawStretchedTexture(C,2.00,0.00,W.WinWidth - 4,2.00,Texture'MenuT');
	W.DrawClippedTexture(C,W.WinWidth - 2,0.00,Texture'MenuTR');
	W.DrawClippedTexture(C,0.00,W.WinHeight - 2,Texture'MenuBL');
	W.DrawStretchedTexture(C,2.00,W.WinHeight - 2,W.WinWidth - 4,2.00,Texture'MenuB');
	W.DrawClippedTexture(C,W.WinWidth - 2,W.WinHeight - 2,Texture'MenuBR');
	W.DrawStretchedTexture(C,0.00,2.00,2.00,W.WinHeight - 4,Texture'MenuL');
	W.DrawStretchedTexture(C,W.WinWidth - 2,2.00,2.00,W.WinHeight - 4,Texture'MenuR');
	W.DrawStretchedTexture(C,2.00,2.00,W.WinWidth - 4,W.WinHeight - 4,Texture'MenuArea');*/
}

function Menu_DrawPulldownMenuItem (UWindowPulldownMenu M, UWindowPulldownMenuItem Item, Canvas C, float X, float Y, float W, float H, bool bSelected)
{
	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	Item.ItemTop=Y + M.WinTop;
	if ( Item.Caption == "-" )
	{
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
//		M.DrawStretchedTexture(C,X,Y + 5,W,2.00,Texture'MenuDivider');
		return;
	}
	C.Font=M.Root.Fonts[0];
	if ( bSelected )
	{
//		M.DrawStretchedTexture(C,X,Y,W,H,Texture'MenuHighlight');
	}
	if ( Item.bDisabled )
	{
		C.DrawColor.R=96;
		C.DrawColor.G=96;
		C.DrawColor.B=96;
	}
	else
	{
		C.DrawColor.R=0;
		C.DrawColor.G=0;
		C.DrawColor.B=0;
	}
	if ( Item.bChecked )
	{
//		M.DrawClippedTexture(C,X + 1,Y + 3,Texture'MenuTick');
	}
	if ( Item.SubMenu != None )
	{
//		M.DrawClippedTexture(C,X + W - 9,Y + 3,Texture'MenuSubArrow');
	}
	M.ClipText(C,X + M.TextBorder + 2,Y + 3,Item.Caption,True);
}

/*
    Active=Texture'Icons.ActiveFrame'
    Inactive=Texture'Icons.InactiveFrame'
    ActiveS=Texture'Icons.ActiveFrameS'
    InactiveS=Texture'Icons.InactiveFrameS'
    Misc=Texture'Icons.Misc'
*/
defaultproperties
{
    CloseBoxOffsetX=3
    CloseBoxOffsetY=5
    SBUpUp=(X=1319433,Y=570818560,W=16,H=795140)
    SBUpDown=(X=2105865,Y=570818560,W=16,H=795140)
    SBUpDisabled=(X=2892297,Y=570818560,W=16,H=795140)
    SBDownUp=(X=1319433,Y=570818560,W=26,H=795140)
    SBDownDown=(X=2105865,Y=570818560,W=26,H=795140)
    SBDownDisabled=(X=2892297,Y=570818560,W=26,H=795140)
    SBLeftUp=(X=1319433,Y=570818560,W=48,H=664068)
    SBLeftDown=(X=1974793,Y=570818560,W=48,H=664068)
    SBLeftDisabled=(X=2630153,Y=570818560,W=48,H=664068)
    SBRightUp=(X=1319433,Y=570818560,W=36,H=664068)
    SBRightDown=(X=1974793,Y=570818560,W=36,H=664068)
    SBRightDisabled=(X=2630153,Y=570818560,W=36,H=664068)
    SBBackground=(X=270857,Y=570818560,W=79,H=74244)
    FrameSBL=(X=7348742,Y=570687488,W=2,H=1057281)
    FrameSB=(X=2105865,Y=570818560,W=112,H=74244)
    FrameSBR=(X=7348745,Y=570818560,W=112,H=1057284)
    CloseBoxUp=(X=270857,Y=570818560,W=32,H=729604)
    CloseBoxDown=(X=270857,Y=570818560,W=43,H=729604)
    FrameTitleX=6
    FrameTitleY=4
    ColumnHeadingHeight=13
    EditBoxBevel=2
    Size_ScrollbarWidth=12.00
    Size_ScrollbarButtonHeight=10.00
    Size_MinScrollbarHeight=6.00
    Size_TabAreaHeight=15.00
    Size_TabAreaOverhangHeight=2.00
    Size_TabSpacing=20.00
    Size_TabXOffset=1.00
    Pulldown_ItemHeight=15.00
    Pulldown_VBorder=3.00
    Pulldown_HBorder=3.00
    Pulldown_TextBorder=9.00
    FrameTL=(X=139780,Y=570490880,W=16,H=11592704)
    FrameT=(X=2105865,Y=570687488,W=1,H=1057281)
    FrameTR=(X=8266249,Y=570687488,W=2,H=1057281)
    FrameL=(X=2105862,Y=570687488,W=2,H=74241)
    FrameR=(X=8266249,Y=570818560,W=32,H=139780)
    FrameBL=(X=8200710,Y=570687488,W=2,H=205313)
    FrameB=(X=2105865,Y=570818560,W=125,H=74244)
    FrameBR=(X=8266249,Y=570818560,W=125,H=139780)
    FrameActiveTitleColor=(R=255,G=255,B=255,A=0)
    FrameInactiveTitleColor=(R=255,G=255,B=255,A=0)
    BevelUpTL=(X=270857,Y=570818560,W=16,H=139780)
    BevelUpT=(X=664073,Y=570818560,W=16,H=74244)
    BevelUpTR=(X=1188361,Y=570818560,W=16,H=139780)
    BevelUpL=(X=270857,Y=570818560,W=20,H=139780)
    BevelUpR=(X=1188361,Y=570818560,W=20,H=139780)
    BevelUpBL=(X=270857,Y=570818560,W=30,H=139780)
    BevelUpB=(X=664073,Y=570818560,W=30,H=74244)
    BevelUpBR=(X=1188361,Y=570818560,W=30,H=139780)
    BevelUpArea=(X=533001,Y=570818560,W=20,H=74244)
    MiscBevelTL(0)=(X=1122822,Y=570687488,W=3,H=205313)
    MiscBevelTL(1)=(X=205316,Y=570490880,W=3,H=0)
    MiscBevelTL(2)=(X=2171398,Y=570687488,W=2,H=139777)
    MiscBevelT(0)=(X=205321,Y=570818560,W=17,H=7610884)
    MiscBevelT(1)=(X=205321,Y=570687488,W=116,H=205313)
    MiscBevelT(2)=(X=139785,Y=570818560,W=33,H=74244)
    MiscBevelTR(0)=(X=7807497,Y=570818560,W=17,H=205316)
    MiscBevelTR(1)=(X=7807497,Y=570687488,W=3,H=205313)
    MiscBevelTR(2)=(X=729609,Y=570818560,W=33,H=139780)
    MiscBevelL(0)=(X=1319430,Y=570687488,W=3,H=664065)
    MiscBevelL(1)=(X=205318,Y=570687488,W=3,H=664065)
    MiscBevelL(2)=(X=2368006,Y=570687488,W=2,H=74241)
    MiscBevelR(0)=(X=7807497,Y=570818560,W=20,H=205316)
    MiscBevelR(1)=(X=7807497,Y=570818560,W=3,H=205316)
    MiscBevelR(2)=(X=729609,Y=570818560,W=36,H=139780)
    MiscBevelBL(0)=(X=1974790,Y=570687488,W=3,H=205313)
    MiscBevelBL(1)=(X=926214,Y=570687488,W=3,H=205313)
    MiscBevelBL(2)=(X=2892294,Y=570687488,W=2,H=139777)
    MiscBevelB(0)=(X=205321,Y=570818560,W=30,H=7610884)
    MiscBevelB(1)=(X=205321,Y=570818560,W=14,H=7610884)
    MiscBevelB(2)=(X=139785,Y=570818560,W=44,H=74244)
    MiscBevelBR(0)=(X=7807497,Y=570818560,W=30,H=205316)
    MiscBevelBR(1)=(X=7807497,Y=570818560,W=14,H=205316)
    MiscBevelBR(2)=(X=729609,Y=570818560,W=44,H=139780)
    MiscBevelArea(0)=(X=205321,Y=570818560,W=20,H=7610884)
    MiscBevelArea(1)=(X=205321,Y=570818560,W=3,H=7610884)
    MiscBevelArea(2)=(X=139785,Y=570818560,W=35,H=598532)
    ComboBtnUp=(X=1319433,Y=570818560,W=60,H=795140)
    ComboBtnDown=(X=2105865,Y=570818560,W=60,H=795140)
    ComboBtnDisabled=(X=2892297,Y=570818560,W=60,H=795140)
    HLine=(X=336393,Y=570818560,W=78,H=74244)
    TabSelectedL=(X=270857,Y=570818560,W=80,H=205316)
    TabSelectedM=(X=467465,Y=570818560,W=80,H=74244)
    TabSelectedR=(X=3613193,Y=570818560,W=80,H=139780)
    TabUnselectedL=(X=3744265,Y=570818560,W=80,H=205316)
    TabUnselectedM=(X=3940873,Y=570818560,W=80,H=74244)
    TabUnselectedR=(X=7152137,Y=570818560,W=80,H=139780)
    TabBackground=(X=270857,Y=570818560,W=79,H=74244)
}
