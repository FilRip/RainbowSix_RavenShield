//================================================================================
// R6MenuRSLookAndFeel.
//================================================================================
class R6MenuRSLookAndFeel extends R6WindowLookAndFeel;

struct STLapTopFramePlus
{
	var Region T1;
	var Region T2;
	var Region T3;
	var Region T4On;
	var Region T4Off;
};

struct STLapTopFrame
{
	var Region TL;
	var Region t;
	var Region TR;
	var Region L;
	var Region R;
	var Region BL;
	var Region B;
	var Region BR;
	var Region L2;
	var Region R2;
	var Region L3;
	var Region R3;
	var Region L4;
	var Region R4;
};

struct STFrameColor
{
	var Color TextColor;
	var Color SelTextColor;
	var Color DisableColor;
	var Color TitleColor;
	var Color TitleBack;
	var Color ButtonBack;
	var Color SelButtonBack;
	var Color ButtonLine;
};

struct STWindowFrame
{
	var Region TL;
	var Region t;
	var Region TR;
	var Region L;
	var Region R;
	var Region BL;
	var Region B;
	var Region BR;
};

enum eSignChoiceButton {
	eSCB_Accept,
	eSCB_Cancel
};

enum ENavBarButton {
	NBB_Home,
	NBB_Option,
	NBB_Archive,
	NBB_TeleCom,
	NBB_Roster,
	NBB_Gear,
	NBB_Planning,
	NBB_Play,
	NBB_Load,
	NBB_Save
};

enum ERSBLButton {
	ERSBL_BLActive,
	ERSBL_BLLeft,
	ERSBL_BLRight
};

const RadioButtonWidth= 16;
const RadioButtonHeight= 17;
const BRSIZEBORDER= 15;
const SIZEBORDER= 3;
var int m_iMultiplyer;
var int m_fVSBButtonImageX;
var int m_fHSBButtonImageX;
var int m_fVSBButtonImageY;
var int m_fHSBButtonImageY;
var int m_fComboImageX;
var int m_fComboImageY;
var float m_fCurrentPct;
var float m_fScrollRate;
var float m_fTextHeaderHeight;
var Texture m_NavBarTex;
var Texture m_TIcon;
var Texture m_TSquareBg;
var Region m_FrameSBL;
var Region m_FrameSB;
var Region m_FrameSBR;
var RegionButton m_BLTitleL;
var RegionButton m_BLTitleC;
var RegionButton m_BLTitleR;
var Region m_PopupArrowUp;
var Region m_PopupArrowDown;
var STLapTopFrame m_stLapTopFrame;
var STLapTopFramePlus m_stLapTopFramePlus;
var Region m_NavBarBack[12];
var Region m_topLeftCornerR;
var RegionButton m_RBAcceptCancel[2];
var RegionButton m_RArrow[2];
var Region m_SBScrollerActive;
var Region m_SBUpGear;
var Region m_SBDownGear;
var Region m_RSquareBgLeft;
var Region m_RSquareBgMid;
var Region m_RSquareBgRight;

function Setup ()
{
	Super.Setup();
	m_NavBarTex=Texture(DynamicLoadObject("R6MenuTextures.GUI_01",Class'Texture'));
	m_R6ScrollTexture=Texture(DynamicLoadObject("R6MenuTextures.Gui_BoxScroll",Class'Texture'));
	m_TIcon=Texture(DynamicLoadObject("R6MenuTextures.TeamBarIcon",Class'Texture'));
}

function Button_SetupEnumSignChoice (UWindowButton W, int eRegionId)
{
	W.bUseRegion=True;
	W.UpTexture=m_R6ScrollTexture;
	W.DownTexture=m_R6ScrollTexture;
	W.OverTexture=m_R6ScrollTexture;
	W.DisabledTexture=m_R6ScrollTexture;
	W.UpRegion=m_RBAcceptCancel[eRegionId].Up;
	W.DownRegion=m_RBAcceptCancel[eRegionId].Down;
	W.OverRegion=m_RBAcceptCancel[eRegionId].Over;
	W.DisabledRegion=m_RBAcceptCancel[eRegionId].Disabled;
}

function Button_SetupMapList (UWindowButton W, bool _bInverseTex)
{
	local RegionButton RTemp;

	W.bUseRegion=True;
	W.UpTexture=m_R6ScrollTexture;
	W.DownTexture=m_R6ScrollTexture;
	W.OverTexture=m_R6ScrollTexture;
	W.DisabledTexture=m_R6ScrollTexture;
	if ( _bInverseTex )
	{
		W.RegionScale=-1.00;
		W.UpRegion=m_RArrow[1].Up;
		W.DownRegion=m_RArrow[1].Down;
		W.OverRegion=m_RArrow[1].Over;
		W.DisabledRegion=m_RArrow[1].Disabled;
	}
	else
	{
		W.RegionScale=1.00;
		W.UpRegion=m_RArrow[0].Up;
		W.DownRegion=m_RArrow[0].Down;
		W.OverRegion=m_RArrow[0].Over;
		W.DisabledRegion=m_RArrow[0].Disabled;
	}
}

function Texture R6GetTexture (R6WindowFramedWindow W)
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

function FW_DrawWindowFrame (UWindowFramedWindow W, Canvas C)
{
	local Texture t;
	local Region R;
	local Region temp;

	C.SetDrawColor(255,255,255);
	t=W.GetLookAndFeelTexture();
	R=FrameTL;
	W.DrawStretchedTextureSegment(C,0.00,0.00,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameT;
	W.DrawStretchedTextureSegment(C,FrameTL.W,0.00,W.WinWidth - FrameTL.W - FrameTR.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameTR;
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,0.00,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	if ( W.bStatusBar )
	{
		temp=m_FrameSBL;
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
		R=m_FrameSBL;
	}
	else
	{
		R=FrameBL;
	}
	W.DrawStretchedTextureSegment(C,0.00,W.WinHeight - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	if ( W.bStatusBar )
	{
		R=m_FrameSB;
		W.DrawStretchedTextureSegment(C,FrameBL.W,W.WinHeight - R.H,W.WinWidth - m_FrameSBL.W - m_FrameSBR.W,R.H,R.X,R.Y,R.W,R.H,t);
	}
	else
	{
		R=FrameB;
		W.DrawStretchedTextureSegment(C,FrameBL.W,W.WinHeight - R.H,W.WinWidth - FrameBL.W - FrameBR.W,R.H,R.X,R.Y,R.W,R.H,t);
	}
	if ( W.bStatusBar )
	{
		R=m_FrameSBR;
	}
	else
	{
		R=FrameBR;
	}
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,W.WinHeight - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
//	C.Font=W.Root.Fonts[W.0];
	if ( W.ParentWindow.ActiveWindow == W )
	{
		C.SetDrawColor(FrameActiveTitleColor.R,FrameActiveTitleColor.G,FrameActiveTitleColor.B);
	}
	else
	{
		C.SetDrawColor(FrameInactiveTitleColor.R,FrameInactiveTitleColor.G,FrameInactiveTitleColor.B);
	}
	W.ClipTextWidth(C,FrameTitleX,FrameTitleY,W.WindowTitle,W.WinWidth);
	if ( W.bStatusBar )
	{
		C.SetDrawColor(0,0,0);
		W.ClipTextWidth(C,6.00,W.WinHeight - 13,W.StatusBarText,W.WinWidth);
		C.SetDrawColor(255,255,255);
	}
}

function R6FW_DrawWindowFrame (R6WindowFramedWindow W, Canvas C)
{
	local Texture t;
	local Region R;

	C.SetDrawColor(255,255,255);
	t=W.GetLookAndFeelTexture();
	R=FrameTL;
	W.DrawStretchedTextureSegment(C,0.00,0.00,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameT;
	W.DrawStretchedTextureSegment(C,FrameTL.W,0.00,W.WinWidth - FrameTL.W - FrameTR.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameTR;
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,0.00,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameL;
	W.DrawStretchedTextureSegment(C,0.00,FrameTL.H,R.W,W.WinHeight - FrameTL.H - FrameBL.H,R.X,R.Y,R.W,R.H,t);
	R=FrameR;
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,FrameTL.H,R.W,W.WinHeight - FrameTL.H - FrameBL.H,R.X,R.Y,R.W,R.H,t);
	R=FrameBL;
	W.DrawStretchedTextureSegment(C,0.00,W.WinHeight - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameB;
	W.DrawStretchedTextureSegment(C,FrameBL.W,W.WinHeight - R.H,W.WinWidth - FrameBL.W - FrameBR.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameBR;
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,W.WinHeight - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
//	C.Font=W.Root.Fonts[W.0];
	if ( W.ParentWindow.ActiveWindow == W )
	{
		C.SetDrawColor(FrameActiveTitleColor.R,FrameActiveTitleColor.G,FrameActiveTitleColor.B);
	}
	else
	{
		C.SetDrawColor(FrameInactiveTitleColor.R,FrameInactiveTitleColor.G,FrameInactiveTitleColor.B);
	}
	W.ClipTextWidth(C,W.m_fTitleOffSet,FrameTitleY,W.m_szWindowTitle,W.WinWidth);
}

function DrawPopUpFrameWindow (R6WindowPopUpBox W, Canvas C)
{
	local Texture TBackGround;
	local Color vBorderColor;
	local Color vCornerColor;

//	TBackGround=Texture'WhiteTexture';
	C.Style=5;
	if ( W.m_bBGFullScreen )
	{
		W.Root.DrawBackGroundEffect(C,W.m_vFullBGColor);
	}
	if ( W.m_bBGClientArea )
	{
		C.SetDrawColor(W.m_vClientAreaColor.R,W.m_vClientAreaColor.G,W.m_vClientAreaColor.B,W.m_vClientAreaColor.A);
		W.DrawStretchedTextureSegment(C,W.m_RWindowBorder.X + 2,W.m_pTextLabel.WinTop + 1,W.m_RWindowBorder.W - 4,W.m_pTextLabel.WinHeight + W.m_RWindowBorder.H - 2,0.00,0.00,10.00,10.00,TBackGround);
	}
	if (  !W.m_bNoBorderToDraw )
	{
/*		if ( W.m_sBorderForm[W.0].bActive )
		{
			if ( W.m_sBorderForm[W.0].vColor!=vBorderColor )
			{
				vBorderColor=W.m_sBorderForm[W.0].vColor;
				C.SetDrawColor(vBorderColor.R,vBorderColor.G,vBorderColor.B);
			}
			W.DrawStretchedTextureSegment(C,W.m_sBorderForm[W.0].fXPos,W.m_sBorderForm[W.0].fYPos,W.m_sBorderForm[W.0].fWidth,W.m_sBorderForm[W.0].fHeight,W.m_HBorderTextureRegion.X,W.m_HBorderTextureRegion.Y,W.m_HBorderTextureRegion.W,W.m_HBorderTextureRegion.H,W.m_HBorderTexture);
		}
		if ( W.m_sBorderForm[W.1].bActive )
		{
			if ( W.m_sBorderForm[W.1].vColor!=vBorderColor )
			{
				vBorderColor=W.m_sBorderForm[W.1].vColor;
				C.SetDrawColor(vBorderColor.R,vBorderColor.G,vBorderColor.B);
			}
			W.DrawStretchedTextureSegment(C,W.m_sBorderForm[W.1].fXPos,W.m_sBorderForm[W.1].fYPos,W.m_sBorderForm[W.1].fWidth,W.m_sBorderForm[W.1].fHeight,W.m_HBorderTextureRegion.X,W.m_HBorderTextureRegion.Y,W.m_HBorderTextureRegion.W,W.m_HBorderTextureRegion.H,W.m_HBorderTexture);
		}
		if ( W.m_sBorderForm[W.2].bActive )
		{
			if ( W.m_sBorderForm[W.2].vColor!=vBorderColor )
			{
				vBorderColor=W.m_sBorderForm[W.2].vColor;
				C.SetDrawColor(vBorderColor.R,vBorderColor.G,vBorderColor.B);
			}
			W.DrawStretchedTextureSegment(C,W.m_sBorderForm[W.2].fXPos,W.m_sBorderForm[W.2].fYPos,W.m_sBorderForm[W.2].fWidth,W.m_sBorderForm[W.2].fHeight,W.m_VBorderTextureRegion.X,W.m_VBorderTextureRegion.Y,W.m_VBorderTextureRegion.W,W.m_VBorderTextureRegion.H,W.m_VBorderTexture);
		}
		if ( W.m_sBorderForm[W.3].bActive )
		{
			if ( W.m_sBorderForm[W.3].vColor!=vBorderColor )
			{
				vBorderColor=W.m_sBorderForm[W.3].vColor;
				C.SetDrawColor(vBorderColor.R,vBorderColor.G,vBorderColor.B);
			}
			W.DrawStretchedTextureSegment(C,W.m_sBorderForm[W.3].fXPos,W.m_sBorderForm[W.3].fYPos,W.m_sBorderForm[W.3].fWidth,W.m_sBorderForm[W.3].fHeight,W.m_VBorderTextureRegion.X,W.m_VBorderTextureRegion.Y,W.m_VBorderTextureRegion.W,W.m_VBorderTextureRegion.H,W.m_VBorderTexture);
		}*/
	}
	vCornerColor.R=0;
	vCornerColor.G=0;
	vCornerColor.B=0;
	if ( W.m_eCornerType != 0 )
	{
		switch (W.m_eCornerType)
		{
/*			case 3:
			if ( W.m_eCornerColor[W.3]!=vCornerColor )
			{
				vCornerColor=W.m_eCornerColor[W.3];
				C.SetDrawColor(vCornerColor.R,vCornerColor.G,vCornerColor.B);
			}
			case 1:
			if ( W.m_eCornerColor[W.1]!=vCornerColor )
			{
				vCornerColor=W.m_eCornerColor[W.1];
				C.SetDrawColor(vCornerColor.R,vCornerColor.G,vCornerColor.B);
			}
			if ( W.m_topLeftCornerT != None )
			{
				W.DrawStretchedTextureSegment(C,W.m_RWindowBorder.X,W.m_RWindowBorder.Y,W.m_topLeftCornerR.W,W.m_topLeftCornerR.H,W.m_topLeftCornerR.X,W.m_topLeftCornerR.Y,W.m_topLeftCornerR.W,W.m_topLeftCornerR.H,W.m_topLeftCornerT);
				W.DrawStretchedTextureSegment(C,W.m_RWindowBorder.X + W.m_RWindowBorder.W - m_topLeftCornerR.W,W.m_RWindowBorder.Y,W.m_topLeftCornerR.W,W.m_topLeftCornerR.H,W.m_topLeftCornerR.X + W.m_topLeftCornerR.W,W.m_topLeftCornerR.Y, -W.m_topLeftCornerR.W,W.m_topLeftCornerR.H,W.m_topLeftCornerT);
			}
			if ( W.m_eCornerType != 3 )
			{
				goto JL0E23;
			}
			case 2:
			if ( W.m_eCornerColor[W.2]!=vCornerColor )
			{
				vCornerColor=W.m_eCornerColor[W.2];
				C.SetDrawColor(vCornerColor.R,vCornerColor.G,vCornerColor.B);
			}
			if ( W.m_topLeftCornerT != None )
			{
				W.DrawStretchedTextureSegment(C,W.m_RWindowBorder.X,W.m_RWindowBorder.Y + W.m_RWindowBorder.H - m_topLeftCornerR.H,W.m_topLeftCornerR.W,W.m_topLeftCornerR.H,W.m_topLeftCornerR.X,W.m_topLeftCornerR.Y + W.m_topLeftCornerR.H,W.m_topLeftCornerR.W, -W.m_topLeftCornerR.H,W.m_topLeftCornerT);
				W.DrawStretchedTextureSegment(C,W.m_RWindowBorder.X + W.m_RWindowBorder.W - W.m_topLeftCornerR.W,W.m_RWindowBorder.Y + W.m_RWindowBorder.H - W.m_topLeftCornerR.H,W.m_topLeftCornerR.W,W.m_topLeftCornerR.H,W.m_topLeftCornerR.X + W.m_topLeftCornerR.W,W.m_topLeftCornerR.Y + W.m_topLeftCornerR.H, -W.m_topLeftCornerR.W, -W.m_topLeftCornerR.H,W.m_topLeftCornerT);
			}
			break;
			default:*/
		}
	}
	else
	{
	}
JL0E23:
}

function FW_SetupFrameButtons (UWindowFramedWindow W, Canvas C)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.CloseBox.WinLeft=W.WinWidth - m_iCloseBoxOffsetX - m_CloseBoxUp.W;
	W.CloseBox.WinTop=m_iCloseBoxOffsetY;
	W.CloseBox.SetSize(m_CloseBoxUp.W,m_CloseBoxUp.H);
	W.CloseBox.bUseRegion=True;
	W.CloseBox.UpTexture=t;
	W.CloseBox.DownTexture=t;
	W.CloseBox.OverTexture=t;
	W.CloseBox.DisabledTexture=t;
	W.CloseBox.UpRegion=m_CloseBoxUp;
	W.CloseBox.DownRegion=m_CloseBoxDown;
	W.CloseBox.OverRegion=m_CloseBoxUp;
	W.CloseBox.DisabledRegion=m_CloseBoxUp;
}

function R6FW_SetupFrameButtons (R6WindowFramedWindow W, Canvas C)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.m_CloseBoxButton.SetSize(m_CloseBoxUp.W,m_CloseBoxUp.H);
	W.m_CloseBoxButton.bUseRegion=True;
	W.m_CloseBoxButton.UpTexture=t;
	W.m_CloseBoxButton.DownTexture=t;
	W.m_CloseBoxButton.OverTexture=t;
	W.m_CloseBoxButton.DisabledTexture=t;
	W.m_CloseBoxButton.UpRegion=m_CloseBoxUp;
	W.m_CloseBoxButton.DownRegion=m_CloseBoxDown;
	W.m_CloseBoxButton.OverRegion=m_CloseBoxUp;
	W.m_CloseBoxButton.DisabledRegion=m_CloseBoxUp;
}

function Region FW_GetClientArea (UWindowFramedWindow W)
{
	local Region R;

	R.X=FrameL.W;
	R.Y=FrameT.H;
	R.W=W.WinWidth - FrameL.W + FrameR.W;
	if ( W.bStatusBar )
	{
		R.H=W.WinHeight - FrameT.H + m_FrameSB.H;
	}
	else
	{
		R.H=W.WinHeight - FrameT.H + FrameB.H;
	}
	return R;
}

function Region R6FW_GetClientArea (R6WindowFramedWindow W)
{
	local Region R;

	R.X=FrameL.W;
	R.Y=FrameT.H;
	R.W=W.WinWidth - FrameL.W + FrameR.W;
	R.H=W.WinHeight - FrameT.H + FrameB.H;
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

function FrameHitTest R6FW_HitTest (R6WindowFramedWindow W, float X, float Y)
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
	local float fTW;
	local float fTH;

//	C.Font=W.Root.Fonts[W.Font];
	W.TextSize(C,W.Text,fTW,fTH);
	switch (W.Align)
	{
		case TA_Left:
		W.EditAreaDrawX=W.WinWidth - W.EditBoxWidth;
		W.TextX=0.00;
		break;
		case TA_Right:
		W.EditAreaDrawX=0.00;
		W.TextX=W.WinWidth - fTW;
		break;
		case TA_Center:
		W.EditAreaDrawX=(W.WinWidth - W.EditBoxWidth) / 2;
		W.TextX=(W.WinWidth - fTW) / 2;
		break;
		default:
	}
	W.EditAreaDrawY=(W.WinHeight - 2) / 2;
	W.TextY=(W.WinHeight - fTH) / 2;
	W.EditBox.WinLeft=W.EditAreaDrawX + MiscBevelL[2].W;
	W.EditBox.WinTop=MiscBevelT[2].H;
	W.Button.WinWidth=ComboBtnUp.W;
	if ( W.bButtons )
	{
		W.EditBox.WinWidth=W.EditBoxWidth - MiscBevelL[2].W - MiscBevelR[2].W - ComboBtnUp.W - m_SBLeft.Up.W - m_SBRight.Up.W;
		W.EditBox.WinHeight=W.WinHeight - MiscBevelT[2].H - MiscBevelB[2].H;
		W.Button.WinLeft=W.WinWidth - ComboBtnUp.W - MiscBevelR[2].W - m_SBLeft.Up.W - m_SBRight.Up.W;
		W.Button.WinTop=W.EditBox.WinTop;
		W.LeftButton.WinLeft=W.WinWidth - MiscBevelR[2].W - m_SBLeft.Up.W - m_SBRight.Up.W;
		W.LeftButton.WinTop=W.EditBox.WinTop;
		W.RightButton.WinLeft=W.WinWidth - MiscBevelR[2].W - m_SBRight.Up.W;
		W.RightButton.WinTop=W.EditBox.WinTop;
		W.LeftButton.WinWidth=m_SBLeft.Up.W;
		W.LeftButton.WinHeight=m_SBLeft.Up.H;
		W.RightButton.WinWidth=m_SBRight.Up.W;
		W.RightButton.WinHeight=m_SBRight.Up.H;
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
	local Texture t;

	t=W.GetLookAndFeelTexture();
	C.Style=5;
	C.SetDrawColor(120,120,120);
	W.DrawStretchedTextureSegment(C,0.00,0.00,W.WinWidth,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	W.DrawStretchedTextureSegment(C,0.00,W.WinHeight - W.m_BorderTextureRegion.H,W.WinWidth,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	W.DrawStretchedTextureSegment(C,0.00,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.W,W.WinHeight - 2 * W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	W.DrawStretchedTextureSegment(C,W.WinWidth - W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.W,W.WinHeight - 2 * W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	if ( W.Text != "" )
	{
		C.SetDrawColor(W.TextColor.R,W.TextColor.G,W.TextColor.B);
		W.ClipText(C,W.TextX,W.TextY,W.Text);
	}
}

function R6List_DrawBackground (R6WindowListBox W, Canvas C)
{
	local Texture t;

	t=m_R6ScrollTexture;
	C.SetDrawColor(W.m_BorderColor.R,W.m_BorderColor.G,W.m_BorderColor.B);
	C.Style=5;
	switch (W.m_eCornerType)
	{
/*		case 0:
		W.DrawSimpleBorder(C);
		break;
		case 2:
		W.DrawStretchedTextureSegment(C,0.00,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y,m_topLeftCornerR.W,m_topLeftCornerR.H,m_R6ScrollTexture);
		W.DrawStretchedTextureSegment(C,W.WinWidth - m_topLeftCornerR.W,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y, -m_topLeftCornerR.W,m_topLeftCornerR.H,m_R6ScrollTexture);
		W.DrawStretchedTextureSegment(C,m_topLeftCornerR.W + m_iListHPadding,0.00,W.WinWidth - 2 * m_iListHPadding - 2 * m_topLeftCornerR.W,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		W.DrawStretchedTextureSegment(C,m_iListVPadding,W.WinHeight - W.m_BorderTextureRegion.H,W.WinWidth - 2 * m_iListVPadding,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		W.DrawStretchedTextureSegment(C,m_iListVPadding,m_topLeftCornerR.H,W.m_BorderTextureRegion.W,W.WinHeight - m_topLeftCornerR.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		W.DrawStretchedTextureSegment(C,W.WinWidth - W.m_BorderTextureRegion.W - m_iListVPadding,m_topLeftCornerR.H,W.m_BorderTextureRegion.W,W.WinHeight - m_topLeftCornerR.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		break;
		case 3:
		W.DrawStretchedTextureSegment(C,0.00,W.WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y + m_topLeftCornerR.H,m_topLeftCornerR.W, -m_topLeftCornerR.H,m_R6ScrollTexture);
		W.DrawStretchedTextureSegment(C,W.WinWidth - m_topLeftCornerR.W,W.WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y + m_topLeftCornerR.H, -m_topLeftCornerR.W, -m_topLeftCornerR.H,m_R6ScrollTexture);
		W.DrawStretchedTextureSegment(C,m_iListVPadding,0.00,W.WinWidth - 2 * m_iListVPadding,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		W.DrawStretchedTextureSegment(C,m_topLeftCornerR.W + m_iListHPadding,W.WinHeight - W.m_BorderTextureRegion.H,W.WinWidth - 2 * m_iListHPadding - 2 * m_topLeftCornerR.W,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		W.DrawStretchedTextureSegment(C,m_iListVPadding,0.00,W.m_BorderTextureRegion.W,W.WinHeight - m_topLeftCornerR.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		W.DrawStretchedTextureSegment(C,W.WinWidth - W.m_BorderTextureRegion.W - m_iListVPadding,0.00,W.m_BorderTextureRegion.W,W.WinHeight - m_topLeftCornerR.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		break;
		case 4:
		W.DrawStretchedTextureSegment(C,0.00,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y,m_topLeftCornerR.W,m_topLeftCornerR.H,m_R6ScrollTexture);
		W.DrawStretchedTextureSegment(C,W.WinWidth - m_topLeftCornerR.W,0.00,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y, -m_topLeftCornerR.W,m_topLeftCornerR.H,m_R6ScrollTexture);
		W.DrawStretchedTextureSegment(C,0.00,W.WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X,m_topLeftCornerR.Y + m_topLeftCornerR.H,m_topLeftCornerR.W, -m_topLeftCornerR.H,m_R6ScrollTexture);
		W.DrawStretchedTextureSegment(C,W.WinWidth - m_topLeftCornerR.W,W.WinHeight - m_topLeftCornerR.H,m_topLeftCornerR.W,m_topLeftCornerR.H,m_topLeftCornerR.X + m_topLeftCornerR.W,m_topLeftCornerR.Y + m_topLeftCornerR.H, -m_topLeftCornerR.W, -m_topLeftCornerR.H,m_R6ScrollTexture);
		W.DrawStretchedTextureSegment(C,m_topLeftCornerR.W + m_iListHPadding,0.00,W.WinWidth - 2 * m_iListHPadding - 2 * m_topLeftCornerR.W,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		W.DrawStretchedTextureSegment(C,m_topLeftCornerR.W + m_iListHPadding,W.WinHeight - W.m_BorderTextureRegion.H,W.WinWidth - 2 * m_iListHPadding - 2 * m_topLeftCornerR.W,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		W.DrawStretchedTextureSegment(C,m_iListVPadding,m_topLeftCornerR.H,W.m_BorderTextureRegion.W,W.WinHeight - 2 * m_topLeftCornerR.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		W.DrawStretchedTextureSegment(C,W.WinWidth - W.m_BorderTextureRegion.W - m_iListVPadding,m_topLeftCornerR.H,W.m_BorderTextureRegion.W,W.WinHeight - 2 * m_topLeftCornerR.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
		break;
		case 1:
		break;
		default:*/
	}
}

function List_DrawBackground (UWindowListControl W, Canvas C)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.DrawUpBevel(C,0.00,0.00,W.WinWidth,W.WinHeight,Active);
}

function ComboList_DrawBackground (UWindowComboList W, Canvas C)
{
	W.DrawSimpleBorder(C);
}

function ComboList_DrawItem (UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected)
{
	local Texture t;

	t=Combo.GetLookAndFeelTexture();
	if ( bSelected )
	{
		C.SetDrawColor(0,0,0);
		Combo.DrawStretchedTextureSegment(C,X,Y,W,H,4.00,16.00,1.00,1.00,t);
		C.SetDrawColor(255,255,255);
	}
	else
	{
		C.SetDrawColor(22,22,22);
		Combo.DrawStretchedTextureSegment(C,X,Y,W,H,4.00,16.00,1.00,1.00,t);
		C.SetDrawColor(15,136,176);
	}
	Combo.ClipText(C,X + Combo.TextBorder + 2,Y + 3,Text);
}

function Combo_SetupButton (UWindowComboButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
/*	W.UpTexture=Texture'Gui_BoxScroll';
	W.DownTexture=Texture'Gui_BoxScroll';
	W.OverTexture=Texture'Gui_BoxScroll';
	W.DisabledTexture=Texture'Gui_BoxScroll';*/
	W.UpRegion=ComboBtnUp;
	W.DownRegion=ComboBtnDown;
	W.OverRegion=ComboBtnOver;
	W.DisabledRegion=ComboBtnDisabled;
	W.ImageX=m_fComboImageX;
	W.ImageY=m_fComboImageY;
}

function Editbox_SetupSizes (UWindowEditControl W, Canvas C)
{
	local float fTW;
	local float fTH;
	local int B;

	B=EditBoxBevel;
//	C.Font=W.Root.Fonts[W.Font];
	W.TextSize(C,W.Text,fTW,fTH);
	W.WinHeight=12.00 + MiscBevelT[B].H + MiscBevelB[B].H;
	switch (W.Align)
	{
		case TA_Left:
		W.EditAreaDrawX=W.WinWidth - W.EditBoxWidth;
		W.TextX=0.00;
		break;
		case TA_Right:
		W.EditAreaDrawX=0.00;
		W.TextX=W.WinWidth - fTW;
		break;
		case TA_Center:
		W.EditAreaDrawX=W.WinWidth - W.EditBoxWidth;
		W.TextX=W.WinWidth - fTW;
		break;
		default:
	}
	W.EditAreaDrawY=W.WinHeight - 2;
	W.TextY=W.WinHeight - fTH;
	W.EditBox.WinLeft=W.EditAreaDrawX + MiscBevelL[B].W;
	W.EditBox.WinTop=MiscBevelT[B].H;
	W.EditBox.WinWidth=W.EditBoxWidth - MiscBevelL[B].W - MiscBevelR[B].W;
	W.EditBox.WinHeight=W.WinHeight - MiscBevelT[B].H - MiscBevelB[B].H;
}

function Editbox_Draw (UWindowEditControl W, Canvas C)
{
	W.DrawMiscBevel(C,W.EditAreaDrawX,0.00,W.EditBoxWidth,W.WinHeight,Active,EditBoxBevel);
}

function Tab_DrawTab (UWindowTabControlTabArea Tab, Canvas C, bool bActiveTab, bool bLeftmostTab, float X, float Y, float W, float H, string Text, bool bShowText)
{
	local Region R;
	local Region Temp_RTabLeft;
	local Region Temp_RTabRight;
	local string szText;
	local float fTW;
	local float fTH;
	local float fXOffset;

	fXOffset=Size_TabTextOffset;
	C.Style=5;
	szText=Text;
	if ( bActiveTab )
	{
		C.SetDrawColor(Tab.m_vEffectColor.R,Tab.m_vEffectColor.G,Tab.m_vEffectColor.B);
		if ( Tab.m_bDisplayToolTip )
		{
			C.SetDrawColor(Tab.Root.Colors.BlueLight.R,Tab.Root.Colors.BlueLight.G,Tab.Root.Colors.BlueLight.B);
		}
		R=TabSelectedL;
		Tab.DrawStretchedTextureSegment(C,X,Y,R.W,R.H,R.X,R.Y,R.W,R.H,m_R6ScrollTexture);
		R=TabSelectedM;
		Tab.DrawStretchedTextureSegment(C,X + TabSelectedL.W,Y,W - TabSelectedL.W - TabSelectedR.W,R.H,R.X,R.Y,R.W,R.H,m_R6ScrollTexture);
		R=TabSelectedR;
		Tab.DrawStretchedTextureSegment(C,X + W - R.W,Y,R.W,R.H,R.X,R.Y,R.W,R.H,m_R6ScrollTexture);
		if ( bShowText )
		{
			C.Style=1;
//			C.Font=Tab.Root.Fonts[7];
			C.SpaceX=0.00;
			szText=Tab.TextSize(C,szText,fTW,fTH,W - fXOffset - TabSelectedR.W);
			Y=(Tab.WinHeight - fTH) / 2;
			Y=Y + 0.50;
			Tab.ClipText(C,X + fXOffset,Y,szText,True);
		}
	}
	else
	{
		switch (Tab.m_eTabCase)
		{
/*			case Tab.0:
			Temp_RTabLeft=TabSelectedL;
			Temp_RTabRight=TabSelectedR;
			break;
			case Tab.3:
			Temp_RTabLeft=TabSelectedL;
			Temp_RTabRight=TabUnselectedR;
			break;
			case Tab.1:
			Temp_RTabLeft=TabUnselectedL;
			Temp_RTabRight=TabSelectedR;
			break;
			case Tab.4:
			Temp_RTabLeft=TabUnselectedL;
			Temp_RTabRight=TabUnselectedR;
			break;
			default:
			Temp_RTabLeft=TabUnselectedL;
			Temp_RTabRight=TabSelectedR;
			break;*/
		}
		C.SetDrawColor(Tab.m_vEffectColor.R,Tab.m_vEffectColor.G,Tab.m_vEffectColor.B);
		if ( Tab.m_bDisplayToolTip )
		{
			C.SetDrawColor(Tab.Root.Colors.BlueLight.R,Tab.Root.Colors.BlueLight.G,Tab.Root.Colors.BlueLight.B);
		}
		R=Temp_RTabLeft;
		Tab.DrawStretchedTextureSegment(C,X,Y,R.W,R.H,R.X,R.Y,R.W,R.H,m_R6ScrollTexture);
		R=TabSelectedM;
		Tab.DrawStretchedTextureSegment(C,X + TabSelectedL.W,Y,W - TabSelectedL.W - TabSelectedR.W,R.H,R.X,R.Y,R.W,R.H,m_R6ScrollTexture);
		R=Temp_RTabRight;
		Tab.DrawStretchedTextureSegment(C,X + W - R.W,Y,R.W,R.H,R.X,R.Y,R.W,R.H,m_R6ScrollTexture);
		if ( bShowText )
		{
			C.Style=1;
//			C.Font=Tab.Root.Fonts[7];
			C.SpaceX=0.00;
			szText=Tab.TextSize(C,szText,fTW,fTH,W - fXOffset - TabSelectedR.W);
			Y=(Tab.WinHeight - fTH) / 2;
			Y=Y + 0.50;
			Tab.ClipText(C,X + fXOffset,Y,szText,True);
		}
	}
}

function SB_SetupUpButton (UWindowSBUpButton W)
{
	local Texture t;

	t=m_R6ScrollTexture;
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	if ( UWindowVScrollbar(W.OwnerWindow).m_bUseSpecialEffect == True )
	{
		W.UpRegion=m_SBUpGear;
	}
	else
	{
		W.UpRegion=m_SBUp.Up;
	}
	W.DownRegion=m_SBUp.Down;
	W.OverRegion=m_SBUp.Over;
	W.DisabledRegion=m_SBUp.Disabled;
	W.m_bDrawButtonBorders=True;
	W.ImageX=m_fVSBButtonImageX;
	W.ImageY=m_fVSBButtonImageY;
}

function SB_SetupDownButton (UWindowSBDownButton W)
{
	local Texture t;

	t=m_R6ScrollTexture;
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	if ( UWindowVScrollbar(W.OwnerWindow).m_bUseSpecialEffect == True )
	{
		W.UpRegion=m_SBDownGear;
	}
	else
	{
		W.UpRegion=m_SBDown.Up;
	}
	W.DownRegion=m_SBDown.Down;
	W.OverRegion=m_SBDown.Over;
	W.DisabledRegion=m_SBDown.Disabled;
	W.m_bDrawButtonBorders=True;
	W.ImageX=m_fVSBButtonImageX;
	W.ImageY=m_fVSBButtonImageY;
}

function SB_SetupLeftButton (UWindowSBLeftButton W)
{
	local Texture t;

	t=m_R6ScrollTexture;
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=m_SBLeft.Up;
	W.DownRegion=m_SBLeft.Down;
	W.OverRegion=m_SBLeft.Up;
	W.DisabledRegion=m_SBLeft.Disabled;
	W.m_bDrawButtonBorders=True;
	W.ImageX=m_fHSBButtonImageX;
	W.ImageY=m_fHSBButtonImageY;
}

function SB_SetupRightButton (UWindowSBRightButton W)
{
	local Texture t;

	t=m_R6ScrollTexture;
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=m_SBRight.Up;
	W.DownRegion=m_SBRight.Down;
	W.OverRegion=m_SBRight.Up;
	W.DisabledRegion=m_SBRight.Disabled;
	W.m_bDrawButtonBorders=True;
	W.ImageX=m_fHSBButtonImageX;
	W.ImageY=m_fHSBButtonImageY;
}

function SB_VDraw (UWindowVScrollbar W, Canvas C)
{
	local int BoxHeight;

	BoxHeight=W.WinHeight - W.UpButton.WinHeight - W.DownButton.WinHeight + W.UpButton.m_BorderTextureRegion.H + W.DownButton.m_BorderTextureRegion.H;
	C.SetDrawColor(W.m_BorderColor.R,W.m_BorderColor.G,W.m_BorderColor.B);
	DrawBox(W,C,0.00,W.UpButton.WinHeight - W.UpButton.m_BorderTextureRegion.H,W.WinWidth,BoxHeight);
	C.Style=5;
	C.SetDrawColor(W.Root.Colors.White.R,W.Root.Colors.White.G,W.Root.Colors.White.B,W.Root.Colors.White.A);
	if ( W.m_bUseSpecialEffect )
	{
		C.SetDrawColor(W.Root.Colors.GrayLight.R,W.Root.Colors.GrayLight.G,W.Root.Colors.GrayLight.B,W.Root.Colors.GrayLight.A);
	}
	W.DrawStretchedTextureSegment(C,m_iSize_ScrollBarFrameW + m_iScrollerOffset,W.ThumbStart,m_iVScrollerWidth,W.ThumbHeight,m_SBScroller.X,m_SBScroller.Y,m_SBScroller.W,m_SBScroller.H,m_R6ScrollTexture);
}

function SB_HDraw (UWindowHScrollbar W, Canvas C)
{
	local int BoxWidth;

	C.SetDrawColor(W.m_BorderColor.R,W.m_BorderColor.G,W.m_BorderColor.B);
	BoxWidth=W.WinWidth - W.LeftButton.WinWidth - W.RightButton.WinWidth + W.LeftButton.m_BorderTextureRegion.W + W.RightButton.m_BorderTextureRegion.W;
	DrawBox(W,C,W.LeftButton.WinWidth - W.LeftButton.m_BorderTextureRegion.W,0.00,BoxWidth,W.WinHeight);
	W.DrawStretchedTextureSegment(C,W.ThumbStart,m_iSize_ScrollBarFrameW + m_iScrollerOffset,W.ThumbWidth,m_iVScrollerWidth,m_SBScroller.X,m_SBScroller.Y,m_SBScroller.W,m_SBScroller.H,m_R6ScrollTexture);
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
	W.UpRegion=m_SBLeft.Up;
	W.DownRegion=m_SBLeft.Down;
	W.OverRegion=m_SBLeft.Up;
	W.DisabledRegion=m_SBLeft.Disabled;
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
	W.UpRegion=m_SBRight.Up;
	W.DownRegion=m_SBRight.Down;
	W.OverRegion=m_SBRight.Up;
	W.DisabledRegion=m_SBRight.Disabled;
}

function Tab_SetTabPageSize (UWindowPageControl W, UWindowPageWindow P)
{
	P.WinLeft=2.00;
	P.WinTop=W.TabArea.WinHeight - TabSelectedM.H - TabUnselectedM.H + 3;
	P.SetSize(W.WinWidth - 4,W.WinHeight - W.TabArea.WinHeight - TabSelectedM.H - TabUnselectedM.H - 6);
}

function Tab_DrawTabPageArea (UWindowPageControl W, Canvas C, UWindowPageWindow P)
{
	W.DrawUpBevel(C,0.00,Size_TabAreaHeight,W.WinWidth,W.WinHeight - Size_TabAreaHeight,Active);
}

function Tab_GetTabSize (UWindowTabControlTabArea Tab, Canvas C, string Text, out float W, out float H)
{
	local float fTW;
	local float fTH;

//	C.Font=Tab.Root.Fonts[Tab.7];
	Tab.TextSize(C,Text,fTW,fTH);
	W=fTW + Size_TabSpacing + Size_TabTextOffset + TabSelectedR.W;
	H=fTH;
}

function Menu_DrawMenuBar (UWindowMenuBar W, Canvas C)
{
	W.DrawStretchedTextureSegment(C,0.00,0.00,W.WinWidth,16.00,11.00,0.00,106.00,16.00,Active);
}

function Menu_DrawMenuBarItem (UWindowMenuBar B, UWindowMenuBarItem i, float X, float Y, float W, float H, Canvas C)
{
	if ( B.Selected == i )
	{
/*		B.DrawClippedTexture(C,X,1.00,Texture'BlackTexture');
		B.DrawClippedTexture(C,X + W - 1,1.00,Texture'BlackTexture');
		B.DrawStretchedTexture(C,X + 1,1.00,W - 2,16.00,Texture'BlackTexture');*/
	}
	C.Font=B.Root.Fonts[0];
	C.SetDrawColor(0,0,0);
	B.ClipText(C,X + B.Spacing / 2,2.00,i.Caption,True);
}

function Menu_DrawPulldownMenuBackground (UWindowPulldownMenu W, Canvas C)
{
}

function Menu_DrawPulldownMenuItem (UWindowPulldownMenu M, UWindowPulldownMenuItem Item, Canvas C, float X, float Y, float W, float H, bool bSelected)
{
}

function DrawWinTop (R6WindowHSplitter W, Canvas C)
{
	W.DrawStretchedTextureSegment(C,0.00,0.00,FrameTL.W,W.WinHeight,FrameTL.X,FrameTL.Y,FrameTL.W,FrameTL.H,Active);
	W.DrawStretchedTextureSegment(C,FrameTL.W,0.00,W.WinWidth - FrameTL.W - FrameTR.W,W.WinHeight,FrameT.X,FrameT.Y,FrameT.W,FrameT.H,Active);
	W.DrawStretchedTextureSegment(C,W.WinWidth - FrameTR.W,0.00,FrameTR.W,W.WinHeight,FrameTR.X,FrameTR.Y,FrameTR.W,FrameTR.H,Active);
}

function DrawHSplitterT (R6WindowHSplitter W, Canvas C)
{
	W.DrawStretchedTextureSegment(C,0.00,0.00,12.00,W.WinHeight,30.00,5.00,12.00,6.00,Active);
	W.DrawStretchedTextureSegment(C,12.00,0.00,W.WinWidth - 24,W.WinHeight,42.00,5.00,2.00,6.00,Active);
	W.DrawStretchedTextureSegment(C,W.WinWidth - 12,0.00,12.00,W.WinHeight,49.00,5.00,12.00,6.00,Active);
}

function DrawHSplitterB (R6WindowHSplitter W, Canvas C)
{
	W.DrawStretchedTextureSegment(C,0.00,0.00,12.00,W.WinHeight,61.00,5.00,12.00,6.00,Active);
	W.DrawStretchedTextureSegment(C,12.00,0.00,W.WinWidth - 24,W.WinHeight,73.00,5.00,2.00,6.00,Active);
	W.DrawStretchedTextureSegment(C,W.WinWidth - 12,0.00,12.00,W.WinHeight,80.00,5.00,12.00,6.00,Active);
}

function DrawPopupButtonDown (R6MenuPopUpStayDownButton W, Canvas C)
{
	local int iColor;
	local Color MenuColor;

	iColor=R6PlanningCtrl(W.GetPlayerOwner()).m_iCurrentTeam;
	C.Style=1;
	MenuColor=W.Root.Colors.TeamColorLight[iColor];
	MenuColor.R /= 2;
	MenuColor.G /= 2;
	MenuColor.B /= 2;
	C.SetDrawColor(MenuColor.R,MenuColor.G,MenuColor.B);
//	W.DrawStretchedTexture(C,0.00,0.00,W.WinWidth,W.WinHeight,Texture'WhiteTexture');
	MenuColor=W.Root.Colors.White;
	C.SetDrawColor(MenuColor.R,MenuColor.G,MenuColor.B);
	if ( W.Text != "" )
	{
		W.ClipText(C,W.TextX,W.TextY,W.Text,True);
	}
	C.Style=5;
	if ( W.m_bSubMenu )
	{
		W.DrawStretchedTextureSegment(C,W.WinWidth - 2 + m_PopupArrowDown.H,(W.WinHeight - m_PopupArrowDown.H) * 0.50,m_PopupArrowDown.W,m_PopupArrowDown.H,m_PopupArrowDown.X,m_PopupArrowDown.Y,m_PopupArrowDown.W,m_PopupArrowDown.H,m_R6ScrollTexture);
	}
	C.SetDrawColor(255,255,255);
}

function DrawPopupButtonUp (R6MenuPopUpStayDownButton W, Canvas C)
{
	local Color MenuColor;

	MenuColor=W.Root.Colors.White;
	C.SetDrawColor(MenuColor.R,MenuColor.G,MenuColor.B,W.Root.Colors.PopUpAlphaFactor);
	C.Style=5;
	if ( W.Text != "" )
	{
		W.ClipText(C,W.TextX,W.TextY,W.Text,True);
	}
	if ( W.m_bSubMenu )
	{
		W.DrawStretchedTextureSegment(C,W.WinWidth - 2 + m_PopupArrowDown.H,(W.WinHeight - m_PopupArrowUp.H) * 0.50,m_PopupArrowUp.W,m_PopupArrowUp.H,m_PopupArrowUp.X,m_PopupArrowUp.Y,m_PopupArrowUp.W,m_PopupArrowUp.H,m_R6ScrollTexture);
	}
	C.Style=1;
	C.SetDrawColor(255,255,255);
}

function DrawPopupButtonOver (R6MenuPopUpStayDownButton W, Canvas C)
{
	local Color MenuColor;

	MenuColor=W.Root.Colors.White;
	C.SetDrawColor(MenuColor.R,MenuColor.G,MenuColor.B);
	C.Style=1;
	if ( W.Text != "" )
	{
		W.ClipText(C,W.TextX,W.TextY,W.Text,True);
	}
	C.Style=5;
	if ( W.m_bSubMenu )
	{
		W.DrawStretchedTextureSegment(C,W.WinWidth - 2 + m_PopupArrowDown.H,(W.WinHeight - m_PopupArrowUp.H) * 0.50,m_PopupArrowUp.W,m_PopupArrowUp.H,m_PopupArrowUp.X,m_PopupArrowUp.Y,m_PopupArrowUp.W,m_PopupArrowUp.H,m_R6ScrollTexture);
	}
	C.SetDrawColor(255,255,255);
}

function DrawPopupButtonDisable (R6MenuPopUpStayDownButton W, Canvas C)
{
	local Color MenuColor;

	MenuColor=W.Root.Colors.White;
	C.SetDrawColor(MenuColor.R,MenuColor.G,MenuColor.B,50);
	C.Style=5;
	if ( W.Text != "" )
	{
		W.ClipText(C,W.TextX,W.TextY,W.Text,True);
	}
	if ( W.m_bSubMenu )
	{
		W.DrawStretchedTextureSegment(C,W.WinWidth - 2 + m_PopupArrowDown.H,(W.WinHeight - m_PopupArrowUp.H) * 0.50,m_PopupArrowUp.W,m_PopupArrowUp.H,m_PopupArrowUp.X,m_PopupArrowUp.Y,m_PopupArrowUp.W,m_PopupArrowUp.H,m_R6ScrollTexture);
	}
	C.Style=1;
	C.SetDrawColor(255,255,255);
}

function DrawNavigationBar (R6MenuNavigationBar W, Canvas C)
{
	local int iXStart;
	local int iXTexSize;
	local int iXWidth;
	local int iYTexSize;
	local Region R;
	local Color cTemp;

	cTemp=W.m_BorderColor;
	W.m_BorderColor=W.Root.Colors.BlueLight;
	W.DrawSimpleBorder(C);
	W.m_BorderColor=cTemp;
	C.Style=5;
	C.SetDrawColor(W.Root.Colors.BlueLight.R,W.Root.Colors.BlueLight.G,W.Root.Colors.BlueLight.B);
	W.DrawStretchedTextureSegment(C,120.00,0.00,1.00,33.00,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	W.DrawStretchedTextureSegment(C,414.00,0.00,1.00,33.00,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	W.DrawStretchedTextureSegment(C,450.00,0.00,1.00,33.00,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	W.DrawStretchedTextureSegment(C,554.00,0.00,1.00,33.00,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	iXStart=120;
	iXTexSize=12;
	iXWidth=318;
	iYTexSize=34;
	R=m_NavBarBack[0];
	W.DrawStretchedTextureSegment(C,iXStart + iXTexSize,-1.00,iXWidth - iXTexSize,iYTexSize,R.X,R.Y,R.W,R.H,m_NavBarTex);
	R=m_NavBarBack[1];
	W.DrawStretchedTextureSegment(C,iXStart,-1.00,iXTexSize,iYTexSize,R.X,R.Y,R.W,R.H,m_NavBarTex);
	W.DrawStretchedTextureSegment(C,iXStart + iXWidth,-1.00,iXTexSize,iYTexSize,R.X + iXTexSize,R.Y, -R.W,R.H,m_NavBarTex);
	C.Style=1;
}

function DrawButtonBorder (UWindowWindow W, Canvas C, optional bool _bDefineBorderColor)
{
	if ( m_TButtonBackGround != None )
	{
		C.Style=5;
		if ( _bDefineBorderColor )
		{
			C.SetDrawColor(W.m_BorderColor.R,W.m_BorderColor.G,W.m_BorderColor.B);
		}
		else
		{
			C.SetDrawColor(m_CBorder.R,m_CBorder.G,m_CBorder.B);
		}
		W.DrawStretchedTextureSegment(C,0.00,0.00,W.WinWidth,W.WinHeight,m_RButtonBackGround.X,m_RButtonBackGround.Y,m_RButtonBackGround.W,m_RButtonBackGround.H,m_TButtonBackGround);
	}
}

function DrawSpecialButtonBorder (R6WindowButton Button, Canvas C, float X, float Y)
{
	local int XPos;
	local int MidWidth;

	C.Style=5;
	C.SetDrawColor(Button.m_BorderColor.R,Button.m_BorderColor.G,Button.m_BorderColor.B);
	XPos=0;
	Button.DrawStretchedTextureSegment(C,XPos,0.00,m_RSquareBgLeft.W,m_RSquareBgLeft.H,m_RSquareBgLeft.X,m_RSquareBgLeft.Y,m_RSquareBgLeft.W,m_RSquareBgLeft.H,m_TSquareBg);
	XPos += m_RSquareBgLeft.W;
	MidWidth=Button.WinWidth - m_RSquareBgLeft.W - m_RSquareBgRight.W;
	Button.DrawStretchedTextureSegment(C,XPos,0.00,MidWidth,m_RSquareBgMid.H,m_RSquareBgMid.X,m_RSquareBgMid.Y,m_RSquareBgMid.W,m_RSquareBgMid.H,m_TSquareBg);
	XPos=Button.WinWidth - m_RSquareBgRight.W;
	Button.DrawStretchedTextureSegment(C,XPos,0.00,m_RSquareBgRight.W,m_RSquareBgRight.H,m_RSquareBgRight.X,m_RSquareBgRight.Y,m_RSquareBgRight.W,m_RSquareBgRight.H,m_TSquareBg);
}

function DrawBox (UWindowWindow W, Canvas C, float X, float Y, float Width, float Height)
{
	C.Style=5;
	C.SetDrawColor(W.m_BorderColor.R,W.m_BorderColor.G,W.m_BorderColor.B);
	W.DrawStretchedTextureSegment(C,X,Y,Width,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	W.DrawStretchedTextureSegment(C,X,Y + Height - W.m_BorderTextureRegion.H,Width,W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	W.DrawStretchedTextureSegment(C,X,Y + W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.W,Height - 2 * W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
	W.DrawStretchedTextureSegment(C,X + Width - W.m_BorderTextureRegion.W,Y + W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.W,Height - 2 * W.m_BorderTextureRegion.H,W.m_BorderTextureRegion.X,W.m_BorderTextureRegion.Y,W.m_BorderTextureRegion.W,W.m_BorderTextureRegion.H,W.m_BorderTexture);
}

function DrawBGShading (UWindowWindow Window, Canvas C, float X, float Y, float W, float H)
{
	C.Style=5;
	C.SetDrawColor(Window.Root.Colors.Black.R,Window.Root.Colors.Black.G,Window.Root.Colors.Black.B,Window.Root.Colors.DarkBGAlpha);
//	Window.DrawStretchedTexture(C,X,Y,W,H,Texture'WhiteTexture');
}

function DrawPopUpTextBackGround (UWindowWindow W, Canvas C, float _fHeight)
{
	local Region RTexture;
	local float fY;
	local float fHeight;

	RTexture.X=114;
	RTexture.Y=47;
	RTexture.W=2;
	RTexture.H=13;
	C.Style=5;
	fHeight=_fHeight;
	if ( fHeight < W.WinHeight )
	{
		fY=(W.WinHeight - fHeight) / 2;
	}
	else
	{
		fY=0.00;
	}
	if ( fHeight < RTexture.H )
	{
		fHeight=RTexture.H;
	}
	W.DrawStretchedTextureSegment(C,0.00,0.00,W.WinWidth,13.00,RTexture.X,RTexture.Y,RTexture.W,RTexture.H,m_R6ScrollTexture);
}

function DrawInGamePlayerStats (UWindowWindow W, Canvas C, int _iPlayerStats, float _fX, float _fY, float _fHeight, float _fWidth)
{
	local float fXOffset;
	local Region RIconRegion;
	local Region RIconToDraw;

	RIconToDraw.Y=29;
	RIconToDraw.W=10;
	RIconToDraw.H=10;
	fXOffset=_fX;
	switch (_iPlayerStats)
	{
		case 1:
		RIconToDraw.X=31;
		RIconRegion=CenterIconInBox(fXOffset,_fY,_fWidth,_fHeight,RIconToDraw);
		break;
		case 2:
		RIconToDraw.X=42;
		RIconRegion=CenterIconInBox(fXOffset,_fY,_fWidth,_fHeight,RIconToDraw);
		break;
		case 3:
		RIconToDraw.X=53;
		RIconRegion=CenterIconInBox(fXOffset,_fY,_fWidth,_fHeight,RIconToDraw);
		break;
		case 4:
		RIconToDraw.X=53;
		RIconToDraw.Y=40;
		RIconToDraw.W=10;
		RIconToDraw.H=10;
		RIconRegion=CenterIconInBox(fXOffset,_fY,_fWidth,_fHeight,RIconToDraw);
		break;
		default:
		RIconToDraw.X=49;
		RIconToDraw.Y=14;
		RIconToDraw.W=10;
		RIconToDraw.H=10;
		RIconRegion=CenterIconInBox(fXOffset,_fY,_fWidth,_fHeight,RIconToDraw);
		break;
	}
	W.DrawStretchedTextureSegment(C,RIconRegion.X,RIconRegion.Y,RIconToDraw.W,RIconToDraw.H,RIconToDraw.X,RIconToDraw.Y,RIconToDraw.W,RIconToDraw.H,m_TIcon);
}

function Region CenterIconInBox (float _fX, float _fY, float _fWidth, float _fHeight, Region _RIconRegion)
{
	local Region RTemp;
	local float fTemp;

	fTemp=(_fWidth - _RIconRegion.W) / 2;
	RTemp.X=_fX + fTemp + 0.50;
	fTemp=(_fHeight - _RIconRegion.H) / 2;
	RTemp.Y=fTemp + 0.50;
	RTemp.Y += _fY;
	return RTemp;
}

function float GetTextHeaderSize ()
{
	return m_fTextHeaderHeight;
}

defaultproperties
{
}
/*
    m_TButtonBackGround=Texture'R6MenuTextures.Gui_BoxScroll'
    m_TSquareBg=Texture'R6MenuTextures.Gui_BoxScroll'
    m_iMultiplyer=-1
    m_fVSBButtonImageX=1
    m_fHSBButtonImageX=2
    m_fVSBButtonImageY=2
    m_fHSBButtonImageY=2
    m_fComboImageX=1
    m_fComboImageY=2
    m_fScrollRate=200.00
    m_fTextHeaderHeight=30.00
    m_FrameSBL=(X=74244,Y=570621952,W=1,H=0)
    m_FrameSB=(X=7021062,Y=570753024,W=17,H=1057284)
    m_FrameSBR=(X=74244,Y=570621952,W=1,H=12544)
    m_BLTitleL=(Up=(X=39453049,Y=52560909,W=50331648,H=5666),Down=(X=39453049,Y=52560909,W=50331648,H=5666)(X=39453049,Y=52560909,W=50331648,H=5666),Over=(X=39453049,Y=52560909,W=50331648,H=5666)(X=39453049,Y=52560909,W=50331648,H=5666)(X=39453049,Y=52560909,W=50331648,H=5666),Disabled=(X=39453049,Y=52560909,W=50331648,H=5666)(X=39453049,Y=52560909,W=50331648,H=5666)(X=39453049,Y=52560909,W=50331648,H=5666)(X=39453049,Y=52560909,W=50331648,H=5666))
    m_BLTitleC=(Up=(X=39453049,Y=52561427,W=67108864,H=546),Down=(X=39453049,Y=52561427,W=67108864,H=546)(X=39453049,Y=52561427,W=67108864,H=546),Over=(X=39453049,Y=52561427,W=67108864,H=546)(X=39453049,Y=52561427,W=67108864,H=546)(X=39453049,Y=52561427,W=67108864,H=546),Disabled=(X=39453049,Y=52561427,W=67108864,H=546)(X=39453049,Y=52561427,W=67108864,H=546)(X=39453049,Y=52561427,W=67108864,H=546)(X=39453049,Y=52561427,W=67108864,H=546))
    m_BLTitleR=(Up=(X=39453049,Y=304219667,W=67108864,H=802),Down=(X=39453049,Y=304219667,W=67108864,H=802)(X=39453049,Y=304219667,W=67108864,H=802),Over=(X=39453049,Y=304219667,W=67108864,H=802)(X=39453049,Y=304219667,W=67108864,H=802)(X=39453049,Y=304219667,W=67108864,H=802),Disabled=(X=39453049,Y=304219667,W=67108864,H=802)(X=39453049,Y=304219667,W=67108864,H=802)(X=39453049,Y=304219667,W=67108864,H=802)(X=39453049,Y=304219667,W=67108864,H=802))
    m_PopupArrowUp=(X=5710342,Y=570753024,W=53,H=401924)
    m_PopupArrowDown=(X=5251590,Y=570753024,W=53,H=401924)
    m_stLapTopFrame=(TL=(X=39456601,Y=2229261,W=50331649,H=8226),t=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),TR=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),L=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),R=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),BL=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),B=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),BR=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),L2=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),R2=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),L3=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),R3=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),L4=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226),R4=(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226)(X=39456601,Y=2229261,W=50331649,H=8226))
    m_stLapTopFramePlus=(T1=(X=39458908,Y=539100435,W=67108864,H=9762),T2=(X=39458908,Y=539100435,W=67108864,H=9762)(X=39458908,Y=539100435,W=67108864,H=9762),T3=(X=39458908,Y=539100435,W=67108864,H=9762)(X=39458908,Y=539100435,W=67108864,H=9762)(X=39458908,Y=539100435,W=67108864,H=9762),T4On=(X=39458908,Y=539100435,W=67108864,H=9762)(X=39458908,Y=539100435,W=67108864,H=9762)(X=39458908,Y=539100435,W=67108864,H=9762)(X=39458908,Y=539100435,W=67108864,H=9762),T4Off=(X=39458908,Y=539100435,W=67108864,H=9762)(X=39458908,Y=539100435,W=67108864,H=9762)(X=39458908,Y=539100435,W=67108864,H=9762)(X=39458908,Y=539100435,W=67108864,H=9762)(X=39458908,Y=539100435,W=67108864,H=9762))
    m_NavBarBack(0)=(X=16130566,Y=570753024,W=157,H=270852)
    m_NavBarBack(1)=(X=15999494,Y=570753024,W=120,H=795140)
    m_NavBarBack(2)=(X=14426630,Y=570753024,W=41,H=532996)
    m_NavBarBack(3)=(X=15016454,Y=570753024,W=41,H=664068)
    m_NavBarBack(4)=(X=15737350,Y=570753024,W=41,H=991748)
    m_NavBarBack(5)=(X=14426630,Y=570753024,W=82,H=926212)
    m_NavBarBack(6)=(X=15409670,Y=570753024,W=82,H=795140)
    m_NavBarBack(7)=(X=16261638,Y=570753024,W=82,H=401924)
    m_NavBarBack(8)=(X=14426630,Y=570753024,W=123,H=598532)
    m_NavBarBack(9)=(X=15081990,Y=570753024,W=123,H=664068)
    m_NavBarBack(10)=(X=14819846,Y=570687488,W=16,H=2695683)
    m_NavBarBack(11)=(X=14819846,Y=570753024,W=41,H=1253892)
    m_topLeftCornerR=(X=795142,Y=570753024,W=56,H=401924)
    m_RBAcceptCancel(0)=(Up=(X=39453049,Y=186779155,W=67108864,H=4898),Down=(X=39453049,Y=186779155,W=67108864,H=4898)(X=39453049,Y=186779155,W=67108864,H=4898),Over=(X=39453049,Y=186779155,W=67108864,H=4898)(X=39453049,Y=186779155,W=67108864,H=4898)(X=39453049,Y=186779155,W=67108864,H=4898),Disabled=(X=39453049,Y=186779155,W=67108864,H=4898)(X=39453049,Y=186779155,W=67108864,H=4898)(X=39453049,Y=186779155,W=67108864,H=4898)(X=39453049,Y=186779155,W=67108864,H=4898))
    m_RBAcceptCancel(1)=(Up=(X=39453049,Y=505546259,W=67108864,H=4898),Down=(X=39453049,Y=505546259,W=67108864,H=4898)(X=39453049,Y=505546259,W=67108864,H=4898),Over=(X=39453049,Y=505546259,W=67108864,H=4898)(X=39453049,Y=505546259,W=67108864,H=4898)(X=39453049,Y=505546259,W=67108864,H=4898),Disabled=(X=39453049,Y=505546259,W=67108864,H=4898)(X=39453049,Y=505546259,W=67108864,H=4898)(X=39453049,Y=505546259,W=67108864,H=4898)(X=39453049,Y=505546259,W=67108864,H=4898))
    m_RArrow(0)=(Up=(X=39453049,Y=1579288089,W=83886080,H=12066),Down=(X=39453049,Y=1579288089,W=83886080,H=12066)(X=39453049,Y=1579288089,W=83886080,H=12066),Over=(X=39453049,Y=1579288089,W=83886080,H=12066)(X=39453049,Y=1579288089,W=83886080,H=12066)(X=39453049,Y=1579288089,W=83886080,H=12066),Disabled=(X=39453049,Y=1579288089,W=83886080,H=12066)(X=39453049,Y=1579288089,W=83886080,H=12066)(X=39453049,Y=1579288089,W=83886080,H=12066)(X=39453049,Y=1579288089,W=83886080,H=12066))
    m_RArrow(1)=(Up=(X=39453049,Y=1747060249,W=83886080,H=12066),Down=(X=39453049,Y=1747060249,W=83886080,H=12066)(X=39453049,Y=1747060249,W=83886080,H=12066),Over=(X=39453049,Y=1747060249,W=83886080,H=12066)(X=39453049,Y=1747060249,W=83886080,H=12066)(X=39453049,Y=1747060249,W=83886080,H=12066),Disabled=(X=39453049,Y=1747060249,W=83886080,H=12066)(X=39453049,Y=1747060249,W=83886080,H=12066)(X=39453049,Y=1747060249,W=83886080,H=12066)(X=39453049,Y=1747060249,W=83886080,H=12066))
    m_SBScrollerActive=(X=4203014,Y=570753024,W=1,H=664068)
    m_SBUpGear=(X=5710342,Y=570753024,W=30,H=729604)
    m_SBDownGear=(X=5710342,Y=570753024,W=38,H=729604)
    m_RSquareBgLeft=(X=1712646,Y=570753024,W=40,H=270852)
    m_RSquareBgMid=(X=1974790,Y=570753024,W=40,H=74244)
    m_RSquareBgRight=(X=2957830,Y=570753024,W=40,H=270852)
    m_iCloseBoxOffsetX=3
    m_iCloseBoxOffsetY=5
    m_iListHPadding=1
    m_iListVPadding=1
    m_iSize_ScrollBarFrameW=1
    m_iVScrollerWidth=9
    m_iScrollerOffset=1
    m_SBUp=(Up=(X=39453049,Y=186778637,W=50331648,H=2082),Down=(X=39453049,Y=186778637,W=50331648,H=2082)(X=39453049,Y=186778637,W=50331648,H=2082),Over=(X=39453049,Y=186778637,W=50331648,H=2082)(X=39453049,Y=186778637,W=50331648,H=2082)(X=39453049,Y=186778637,W=50331648,H=2082),Disabled=(X=39453049,Y=186778637,W=50331648,H=2082)(X=39453049,Y=186778637,W=50331648,H=2082)(X=39453049,Y=186778637,W=50331648,H=2082)(X=39453049,Y=186778637,W=50331648,H=2082))
    m_SBDown=(Up=(X=39453049,Y=136447251,W=67108864,H=2850),Down=(X=39453049,Y=136447251,W=67108864,H=2850)(X=39453049,Y=136447251,W=67108864,H=2850),Over=(X=39453049,Y=136447251,W=67108864,H=2850)(X=39453049,Y=136447251,W=67108864,H=2850)(X=39453049,Y=136447251,W=67108864,H=2850),Disabled=(X=39453049,Y=136447251,W=67108864,H=2850)(X=39453049,Y=136447251,W=67108864,H=2850)(X=39453049,Y=136447251,W=67108864,H=2850)(X=39453049,Y=136447251,W=67108864,H=2850))
    m_SBRight=(Up=(X=39453049,Y=153224729,W=83886080,H=6434),Down=(X=39453049,Y=153224729,W=83886080,H=6434)(X=39453049,Y=153224729,W=83886080,H=6434),Over=(X=39453049,Y=153224729,W=83886080,H=6434)(X=39453049,Y=153224729,W=83886080,H=6434)(X=39453049,Y=153224729,W=83886080,H=6434),Disabled=(X=39453049,Y=153224729,W=83886080,H=6434)(X=39453049,Y=153224729,W=83886080,H=6434)(X=39453049,Y=153224729,W=83886080,H=6434)(X=39453049,Y=153224729,W=83886080,H=6434))
    m_SBLeft=(Up=(X=39453049,Y=19007001,W=83886080,H=6434),Down=(X=39453049,Y=19007001,W=83886080,H=6434)(X=39453049,Y=19007001,W=83886080,H=6434),Over=(X=39453049,Y=19007001,W=83886080,H=6434)(X=39453049,Y=19007001,W=83886080,H=6434)(X=39453049,Y=19007001,W=83886080,H=6434),Disabled=(X=39453049,Y=19007001,W=83886080,H=6434)(X=39453049,Y=19007001,W=83886080,H=6434)(X=39453049,Y=19007001,W=83886080,H=6434)(X=39453049,Y=19007001,W=83886080,H=6434))
    m_SBBackground=(X=991750,Y=570753024,W=28,H=926212)
    m_SBVBorder=(X=4203014,Y=570753024,W=56,H=74244)
    m_SBHBorder=(X=4203014,Y=570753024,W=56,H=74244)
    m_SBScroller=(X=3351046,Y=570753024,W=1,H=664068)
    m_CloseBoxUp=(X=5382662,Y=570753024,W=29,H=860676)
    m_CloseBoxDown=(X=5382662,Y=570753024,W=16,H=860676)
    m_RButtonBackGround=(X=795142,Y=570753024,W=40,H=926212)
    m_CBorder=(R=176,G=136,B=15,A=0)
    FrameTitleX=6
    FrameTitleY=4
    ColumnHeadingHeight=13
    EditBoxBevel=2
    Size_ComboHeight=12.00
    Size_ComboButtonWidth=13.00
    Size_ScrollbarWidth=13.00
    Size_ScrollbarButtonHeight=12.00
    Size_MinScrollbarHeight=6.00
    Size_TabAreaHeight=15.00
    Size_TabAreaOverhangHeight=2.00
    Size_TabXOffset=1.00
    Size_TabTextOffset=12.00
    Pulldown_ItemHeight=15.00
    Pulldown_VBorder=3.00
    Pulldown_HBorder=3.00
    Pulldown_TextBorder=9.00
    FrameTL=(X=795140,Y=570621952,W=16,H=0)
    FrameT=(X=795142,Y=570687488,W=1,H=1057283)
    FrameTR=(X=7610886,Y=570687488,W=12,H=1057283)
    FrameL=(X=1122821,Y=570687488,W=4,H=1188355)
    FrameR=(X=1122821,Y=570687488,W=4,H=1188355)
    FrameBL=(X=8266245,Y=570687488,W=4,H=139779)
    FrameB=(X=139782,Y=570753024,W=126,H=74244)
    FrameBR=(X=8135174,Y=570753024,W=125,H=270852)
    FrameActiveTitleColor=(R=255,G=255,B=255,A=0)
    FrameInactiveTitleColor=(R=255,G=255,B=255,A=0)
    BevelUpTL=(X=270854,Y=570753024,W=16,H=139780)
    BevelUpT=(X=664070,Y=570753024,W=16,H=74244)
    BevelUpTR=(X=1188358,Y=570753024,W=16,H=139780)
    BevelUpL=(X=270854,Y=570753024,W=20,H=139780)
    BevelUpR=(X=1188358,Y=570753024,W=20,H=139780)
    BevelUpBL=(X=270854,Y=570753024,W=30,H=139780)
    BevelUpB=(X=664070,Y=570753024,W=30,H=74244)
    BevelUpBR=(X=1188358,Y=570753024,W=30,H=139780)
    BevelUpArea=(X=532998,Y=570753024,W=20,H=74244)
    MiscBevelTL(0)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelTL(1)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelTL(2)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelT(0)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelT(1)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelT(2)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelTR(0)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelTR(1)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelTR(2)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelL(0)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelL(1)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelL(2)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelR(0)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelR(1)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelR(2)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelBL(0)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelBL(1)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelBL(2)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelB(0)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelB(1)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelB(2)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelBR(0)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelBR(1)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelBR(2)=(X=729606,Y=570687488,W=1,H=74243)
    MiscBevelArea(0)=(X=795142,Y=570753024,W=1,H=74244)
    MiscBevelArea(1)=(X=1319430,Y=570753024,W=16,H=74244)
    MiscBevelArea(2)=(X=1319430,Y=570753024,W=16,H=74244)
    ComboBtnUp=(X=532997,Y=570687488,W=11,H=-515581)
    ComboBtnDown=(X=1581573,Y=570687488,W=11,H=-515581)
    ComboBtnDisabled=(X=1581573,Y=570687488,W=11,H=-515581)
    ComboBtnOver=(X=1057285,Y=570687488,W=11,H=-515581)
    HLine=(X=336390,Y=570753024,W=78,H=74244)
    EditBoxTextColor=(R=255,G=255,B=255,A=0)
    TabSelectedL=(X=4203013,Y=570687488,W=54,H=1647107)
    TabSelectedM=(X=2695686,Y=570753024,W=57,H=139780)
    TabSelectedR=(X=3547654,Y=570753024,W=64,H=2105860)
    TabUnselectedL=(X=5644806,Y=570753024,W=64,H=3547652)
    TabUnselectedM=(X=3940870,Y=570753024,W=80,H=74244)
    TabUnselectedR=(X=9183750,Y=570753024,W=64,H=2105860)
    TabBackground=(X=270854,Y=570753024,W=7,H=74244)
*/

