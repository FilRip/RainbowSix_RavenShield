//================================================================================
// R6WindowTextIconsSubListBox.
//================================================================================
class R6WindowTextIconsSubListBox extends UWindowDialogControl;

var int m_LabelDrawStyle;
var int m_IAddRemoveXPos;
var int m_IAddRemoveYPos;
var int m_IAddRemoveBgXPos;
var int m_IAddRemoveBgYPos;
var int m_IUpDownXPos;
var int m_IUpDownBgXPos;
var int m_IUpDownYPos;
var int m_IUpDownBgYPos;
var int m_IUpDownBetweenPadding;
var int m_maxItemsCount;
var R6WindowTextIconsListBox m_listBox;
var R6WindowButton m_RemoveButton;
var R6WindowButton m_AddButton;
var R6WindowButton m_UpButton;
var R6WindowButton m_DownButton;
var R6WindowTextLabel m_Title;
var R6WindowBitMap m_UpDownBg;
var R6WindowBitMap m_AddRemoveBg;
var Texture m_LabelTexture;
var Region m_UpDownBgReg;
var Region m_AddRemoveBgReg;
var Color m_LabelColor;
var Region m_LabelRegionTop;
var Region m_LabelRegionTile;
var Region m_LabelRegionBottom;
var RegionButton m_UpReg;
var RegionButton m_DownReg;

function Created ()
{
	local Region normalReg;
	local Region overReg;
	local Region disabledReg;
	local Region downReg;
	local float ButtonBorderWidth;
	local float ButtonBorderHeight;
	local float UpDownButtonWidth;
	local float UpDownButtonHeight;
	local float fLabelWidth;
	local Texture ButtonTexture;

	Super.Created();
	m_listBox=R6WindowTextIconsListBox(CreateWindow(Class'R6WindowTextIconsListBox',0.00,m_LabelRegionTop.H,WinWidth,WinHeight - m_LabelRegionTop.H,self));
//	m_listBox.SetCornerType(1);
	m_listBox.m_IgnoreAllreadySelected=False;
	ButtonTexture=R6WindowLookAndFeel(LookAndFeel).m_R6ScrollTexture;
	normalReg.X=204;
	normalReg.Y=0;
	normalReg.W=18;
	normalReg.H=12;
	overReg.X=204;
	overReg.Y=12;
	overReg.W=18;
	overReg.H=12;
	disabledReg.X=204;
	disabledReg.Y=24;
	disabledReg.W=18;
	disabledReg.H=12;
	ButtonBorderWidth=normalReg.W;
	ButtonBorderHeight=normalReg.H;
	UpDownButtonWidth=m_UpReg.Up.W;
	UpDownButtonHeight=m_UpReg.Up.H;
	m_RemoveButton=R6WindowButton(CreateWindow(Class'R6WindowButton',m_IAddRemoveXPos,m_IAddRemoveYPos,ButtonBorderWidth,ButtonBorderHeight,self));
	m_RemoveButton.ToolTipString=Localize("Tip","GearRoomButRemove","R6Menu");
	m_RemoveButton.m_bDrawBorders=False;
	m_RemoveButton.bUseRegion=True;
	m_RemoveButton.DisabledTexture=ButtonTexture;
	m_RemoveButton.DisabledRegion=disabledReg;
	m_RemoveButton.DownTexture=ButtonTexture;
	m_RemoveButton.DownRegion=disabledReg;
	m_RemoveButton.OverTexture=ButtonTexture;
	m_RemoveButton.OverRegion=overReg;
	m_RemoveButton.UpTexture=ButtonTexture;
	m_RemoveButton.UpRegion=normalReg;
	m_RemoveButton.m_iDrawStyle=5;
	m_RemoveButton.HideWindow();
	normalReg.X=222;
	overReg.X=222;
	disabledReg.X=222;
	m_AddButton=R6WindowButton(CreateWindow(Class'R6WindowButton',m_IAddRemoveXPos,m_IAddRemoveYPos,ButtonBorderWidth,ButtonBorderHeight,self));
	m_AddButton.ToolTipString=Localize("Tip","GearRoomButAdd","R6Menu");
	m_AddButton.m_bDrawBorders=False;
	m_AddButton.bUseRegion=True;
	m_AddButton.DisabledTexture=ButtonTexture;
	m_AddButton.DisabledRegion=disabledReg;
	m_AddButton.DownTexture=ButtonTexture;
	m_AddButton.DownRegion=disabledReg;
	m_AddButton.OverTexture=ButtonTexture;
	m_AddButton.OverRegion=overReg;
	m_AddButton.UpTexture=ButtonTexture;
	m_AddButton.UpRegion=normalReg;
	m_AddButton.m_iDrawStyle=5;
	m_AddRemoveBg=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_IAddRemoveBgXPos,m_IAddRemoveBgYPos,m_AddRemoveBgReg.W,m_AddRemoveBgReg.H,self));
	m_AddRemoveBg.bAlwaysBehind=True;
	m_AddRemoveBg.m_bUseColor=True;
	m_AddRemoveBg.m_iDrawStyle=5;
	m_AddRemoveBg.t=ButtonTexture;
	m_AddRemoveBg.R=m_AddRemoveBgReg;
	m_AddRemoveBg.SendToBack();
	m_UpButton=R6WindowButton(CreateWindow(Class'R6WindowButton',WinWidth - m_IUpDownXPos,m_IUpDownYPos,UpDownButtonWidth,UpDownButtonHeight,self));
	m_UpButton.ToolTipString=Localize("Tip","GearRoomButUp","R6Menu");
	m_UpButton.m_bDrawBorders=False;
	m_UpButton.bUseRegion=True;
	m_UpButton.DisabledTexture=ButtonTexture;
	m_UpButton.DisabledRegion=m_UpReg.Disabled;
	m_UpButton.DownTexture=ButtonTexture;
	m_UpButton.DownRegion=m_UpReg.Down;
	m_UpButton.OverTexture=ButtonTexture;
	m_UpButton.OverRegion=m_UpReg.Over;
	m_UpButton.UpTexture=ButtonTexture;
	m_UpButton.UpRegion=m_UpReg.Up;
	m_UpButton.m_iDrawStyle=5;
	m_DownButton=R6WindowButton(CreateWindow(Class'R6WindowButton',m_UpButton.WinLeft + m_UpButton.WinWidth + m_IUpDownBetweenPadding,m_IUpDownYPos,UpDownButtonWidth,UpDownButtonHeight,self));
	m_DownButton.ToolTipString=Localize("Tip","GearRoomButDown","R6Menu");
	m_DownButton.m_bDrawBorders=False;
	m_DownButton.bUseRegion=True;
	m_DownButton.DisabledTexture=ButtonTexture;
	m_DownButton.DisabledRegion=m_DownReg.Disabled;
	m_DownButton.DownTexture=ButtonTexture;
	m_DownButton.DownRegion=m_DownReg.Down;
	m_DownButton.OverTexture=ButtonTexture;
	m_DownButton.OverRegion=m_DownReg.Over;
	m_DownButton.UpTexture=ButtonTexture;
	m_DownButton.UpRegion=m_DownReg.Up;
	m_DownButton.m_iDrawStyle=5;
	m_UpDownBg=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',WinWidth - m_IUpDownBgXPos,m_IUpDownBgYPos,m_UpDownBgReg.W,m_UpDownBgReg.H,self));
	m_UpDownBg.bAlwaysBehind=True;
	m_UpDownBg.m_bUseColor=True;
	m_UpDownBg.m_iDrawStyle=5;
	m_UpDownBg.t=ButtonTexture;
	m_UpDownBg.R=m_UpDownBgReg;
	m_UpDownBg.SendToBack();
	fLabelWidth=m_UpButton.WinLeft - m_AddButton.WinLeft - m_AddButton.WinWidth - 1;
	m_Title=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,0.00,WinWidth,m_LabelRegionTop.H,self));
	m_Title.bAlwaysBehind=True;
	m_Title.m_BGTexture=None;
	m_Title.m_bDrawBorders=False;
	m_Title.m_bFixedYPos=True;
	m_Title.TextY=4.00;
	m_Title.SendToBack();
}

function Resized ()
{
	m_listBox.SetSize(m_listBox.WinWidth,WinHeight - m_LabelRegionTop.H);
}

function Register (UWindowDialogClientWindow W)
{
	NotifyWindow=W;
	Notify(0);
	m_listBox.Register(W);
	m_AddButton.Register(W);
	m_RemoveButton.Register(W);
	m_UpButton.Register(W);
	m_DownButton.Register(W);
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=m_LabelDrawStyle;
	C.SetDrawColor(m_LabelColor.R,m_LabelColor.G,m_LabelColor.B);
	DrawStretchedTextureSegment(C,0.00,0.00,m_LabelRegionTop.W,m_LabelRegionTop.H,m_LabelRegionTop.X,m_LabelRegionTop.Y,m_LabelRegionTop.W,m_LabelRegionTop.H,m_LabelTexture);
	DrawStretchedTextureSegment(C,0.00,m_LabelRegionTop.H,m_LabelRegionTile.W,WinHeight - m_LabelRegionTop.H - m_LabelRegionBottom.H,m_LabelRegionTile.X,m_LabelRegionTile.Y,m_LabelRegionTile.W,m_LabelRegionTile.H,m_LabelTexture);
	DrawStretchedTextureSegment(C,0.00,WinHeight - m_LabelRegionBottom.H,m_LabelRegionBottom.W,m_LabelRegionBottom.H,m_LabelRegionBottom.X,m_LabelRegionBottom.Y,m_LabelRegionBottom.W,m_LabelRegionBottom.H,m_LabelTexture);
}

function SetColor (Color NewColor)
{
	m_LabelColor=NewColor;
	m_UpDownBg.m_TextureColor=NewColor;
	m_AddRemoveBg.m_TextureColor=NewColor;
}

function UpdateButtons (optional int addButton)
{
	local bool bDrawingAddOrRemove;

	if ( m_listBox.m_SelectedItem != None )
	{
		m_UpButton.bDisabled=False;
		m_DownButton.bDisabled=False;
		if ( m_listBox.m_SelectedItem.Next == None )
		{
			m_DownButton.bDisabled=True;
		}
		if ( m_listBox.m_SelectedItem.Prev == m_listBox.Items )
		{
			m_UpButton.bDisabled=True;
		}
	}
	else
	{
		m_UpButton.bDisabled=True;
		m_DownButton.bDisabled=True;
	}
	if ( m_listBox.m_SelectedItem != None )
	{
		m_RemoveButton.ShowWindow();
		bDrawingAddOrRemove=True;
	}
	else
	{
		m_RemoveButton.HideWindow();
	}
	if ( (addButton == 1) && (m_listBox.Items.Count() < m_maxItemsCount) )
	{
		m_AddButton.ShowWindow();
		bDrawingAddOrRemove=True;
	}
	else
	{
		m_AddButton.HideWindow();
	}
	if ( bDrawingAddOrRemove == True )
	{
		m_AddRemoveBg.ShowWindow();
		m_AddRemoveBg.SendToBack();
	}
	else
	{
		m_AddRemoveBg.HideWindow();
	}
	if ( bAcceptsFocus )
	{
		if ( Root.FocusedWindow == m_listBox )
		{
			m_listBox.ActivateWindow(0,False);
		}
	}
}

function SetTip (string _szTip)
{
	ToolTipString=_szTip;
	m_listBox.ToolTipString=_szTip;
	m_Title.ToolTipString=_szTip;
}

defaultproperties
{
    m_LabelDrawStyle=5
    m_IAddRemoveXPos=6
    m_IAddRemoveYPos=5
    m_IAddRemoveBgXPos=4
    m_IAddRemoveBgYPos=3
    m_IUpDownXPos=41
    m_IUpDownBgXPos=43
    m_IUpDownYPos=5
    m_IUpDownBgYPos=3
    m_IUpDownBetweenPadding=1
    m_maxItemsCount=4
    m_UpDownBgReg=(X=8659467,Y=571277312,W=36,H=2564617)
    m_AddRemoveBgReg=(X=14164491,Y=571277312,W=36,H=1450505)
    m_LabelColor=(R=255,G=255,B=255,A=0)
    m_LabelRegionTop=(X=31531533,Y=571015168,W=199,H=1319432)
    m_LabelRegionTile=(X=33038861,Y=571015168,W=199,H=139784)
    m_LabelRegionBottom=(X=33235469,Y=571015168,W=199,H=139784)
    m_UpReg=(Up=(X=123339592,Y=-2078143725,W=150994944,H=4386),Down=(X=123339592,Y=-2078143725,W=150994944,H=4386)(X=123339592,Y=-2078143725,W=150994944,H=4386), Over=(X=123339592,Y=-2078143725,W=150994944,H=4386)(X=123339592,Y=-2078143725,W=150994944,H=4386)(X=123339592,Y=-2078143725,W=150994944,H=4386), Disabled=(X=123339592,Y=-2078143725,W=150994944,H=4386)(X=123339592,Y=-2078143725,W=150994944,H=4386)(X=123339592,Y=-2078143725,W=150994944,H=4386)(X=123339592,Y=-2078143725,W=150994944,H=4386))
    m_DownReg=(Up=(X=123339592,Y=-1776153837,W=150994944,H=4386),Down=(X=123339592,Y=-1776153837,W=150994944,H=4386)(X=123339592,Y=-1776153837,W=150994944,H=4386), Over=(X=123339592,Y=-1776153837,W=150994944,H=4386)(X=123339592,Y=-1776153837,W=150994944,H=4386)(X=123339592,Y=-1776153837,W=150994944,H=4386), Disabled=(X=123339592,Y=-1776153837,W=150994944,H=4386)(X=123339592,Y=-1776153837,W=150994944,H=4386)(X=123339592,Y=-1776153837,W=150994944,H=4386)(X=123339592,Y=-1776153837,W=150994944,H=4386))
}
/*
    m_LabelTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

