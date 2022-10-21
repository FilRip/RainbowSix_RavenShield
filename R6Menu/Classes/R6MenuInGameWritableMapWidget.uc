//================================================================================
// R6MenuInGameWritableMapWidget.
//================================================================================
class R6MenuInGameWritableMapWidget extends R6MenuWidget;

var const int c_iNbOfIcons;
var bool m_bIsDrawing;
var R6ColorPicker m_cColorPicker;
var R6WindowRadioButton m_Icons[16];
var R6WindowRadioButton m_CurrentSelectedIcon;

function Created ()
{
	local int iIconsCount;
	local int iPosX;
	local Region ButtonRegion;

	m_cColorPicker=R6ColorPicker(CreateWindow(Class'R6ColorPicker',10.00,190.00,40.00,100.00,self));
	iIconsCount=0;
JL0032:
	if ( iIconsCount < c_iNbOfIcons )
	{
		if ( iIconsCount < 8 )
		{
			ButtonRegion.X=iIconsCount * 64;
			ButtonRegion.Y=0;
		}
		else
		{
			ButtonRegion.X=(iIconsCount - 8) * 64;
			ButtonRegion.Y=192;
		}
		ButtonRegion.W=64;
		ButtonRegion.H=64;
		iPosX=34 + iIconsCount * (32 + 4);
		m_Icons[iIconsCount]=R6WindowRadioButton(CreateControl(Class'R6WindowRadioButton',iPosX,WinHeight - 48,32.00,32.00,self));
		m_Icons[iIconsCount].RegionScale=0.50;
		m_Icons[iIconsCount].bUseRegion=True;
		m_Icons[iIconsCount].UpRegion=ButtonRegion;
//		m_Icons[iIconsCount].UpTexture=Texture'R6WritableMapIcons';
		m_Icons[iIconsCount].bCenter=False;
		m_Icons[iIconsCount].m_iDrawStyle=5;
		m_Icons[iIconsCount].m_bDrawBorders=False;
		if ( iIconsCount < 8 )
		{
			ButtonRegion.Y=64;
		}
		else
		{
			ButtonRegion.Y=256;
		}
		m_Icons[iIconsCount].OverRegion=ButtonRegion;
//		m_Icons[iIconsCount].OverTexture=Texture'R6WritableMapIcons';
		if ( iIconsCount < 8 )
		{
			ButtonRegion.Y=128;
		}
		else
		{
			ButtonRegion.Y=320;
		}
		m_Icons[iIconsCount].DownRegion=ButtonRegion;
//		m_Icons[iIconsCount].DownTexture=Texture'R6WritableMapIcons';
		m_Icons[iIconsCount].m_iButtonID=iIconsCount;
		iIconsCount++;
		goto JL0032;
	}
	m_CurrentSelectedIcon=m_Icons[0];
	m_CurrentSelectedIcon.m_bSelected=True;
//	Class'Actor'.static.GetCanvas().m_pWritableMapIconsTexture=Texture'R6WritableMapIcons';
}

function SendLineToTeam ()
{
	local string Msg;
	local int i;
	local float X;
	local float Y;
	local Color C;
	local LevelInfo pLevel;

	C=m_cColorPicker.GetSelectedColor();
	i=0;
	if ( C.R == 255 )
	{
		i += 2;
	}
	if ( C.G == 255 )
	{
		i += 4;
	}
	if ( C.B == 255 )
	{
		i += 8;
	}
	Msg=Chr(i);
	pLevel=GetLevel();
	if ( pLevel.m_aCurrentStrip.Length > 2 )
	{
		i=0;
JL00A6:
		if ( i < pLevel.m_aCurrentStrip.Length )
		{
			Msg=Msg $ Chr(pLevel.m_aCurrentStrip[i].Position.X) $ Chr(pLevel.m_aCurrentStrip[i].Position.Y);
			i++;
			goto JL00A6;
		}
		pLevel.AddEncodedWritableMapStrip(Msg);
		R6PlayerController(GetPlayerOwner()).ServerBroadcast(GetPlayerOwner(),Msg,'Line');
	}
	pLevel.m_aCurrentStrip.Remove (0,pLevel.m_aCurrentStrip.Length);
}

function MouseLeave ()
{
	Super.MouseLeave();
	m_bIsDrawing=False;
	SendLineToTeam();
}

function RMouseDown (float X, float Y)
{
	local string szMsg;
	local Color C;
	local int iColorIndex;

	if ( (X < 60) || (X > 640) || (Y < 0) || (Y > 416) )
	{
		return;
	}
	C=m_cColorPicker.GetSelectedColor();
	iColorIndex=0;
	if ( C.R == 255 )
	{
		iColorIndex += 2;
	}
	if ( C.G == 255 )
	{
		iColorIndex += 4;
	}
	if ( C.B == 255 )
	{
		iColorIndex += 8;
	}
	Super.RMouseDown(X,Y);
	szMsg=string(X) $ " " $ string(Y) $ " " $ string(m_CurrentSelectedIcon.m_iButtonID) $ " " $ string(iColorIndex);
	Log(szMsg);
	R6PlayerController(GetPlayerOwner()).ServerBroadcast(GetPlayerOwner(),szMsg,'Icon');
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( (X >= 60) && (X < 640) && (Y >= 0) && (Y < 480) )
	{
		m_bIsDrawing=True;
	}
}

function LMouseUp (float X, float Y)
{
	Super.LMouseUp(X,Y);
	if ( m_bIsDrawing )
	{
		m_bIsDrawing=False;
		SendLineToTeam();
	}
}

function MouseMove (float X, float Y)
{
	local float tX;
	local float tY;
	local Vector V;

	Super.MouseMove(X,Y);
	if ( m_bIsDrawing )
	{
		ParentWindow.GetMouseXY(tX,tY);
		V.X=(tX - 60.00) / (640.00 - 60.00);
		V.Y=tY / 480.00;
		V.Z=0.00;
		GetLevel().AddWritableMapPoint(V,m_cColorPicker.GetSelectedColor());
	}
}

function Paint (Canvas C, float X, float Y)
{
	local int USize;
	local int VSize;
	local Texture mapTexture;

	Super.Paint(C,X,Y);
	C.SetPos(0.00,0.00);
//	C.DrawRect(Texture'Black',640.00,480.00);
	mapTexture=GetLevel().m_tWritableMapTexture;
	if ( mapTexture != None )
	{
		C.SetPos(60.00,0.00);
//		C.DrawRect(mapTexture,640.00 - 60,480.00);
	}
	C.DrawWritableMap(GetLevel());
}

function Notify (UWindowDialogControl Button, byte Msg)
{
	switch (Msg)
	{
		case 2:
		if ( R6WindowRadioButton(Button) != None )
		{
			m_CurrentSelectedIcon.m_bSelected=False;
			m_CurrentSelectedIcon=R6WindowRadioButton(Button);
			m_CurrentSelectedIcon.m_bSelected=True;
		}
		break;
		default:
	}
}

function ShowWindow ()
{
	Super.ShowWindow();
	Root.m_bScaleWindowToRoot=True;
}

function HideWindow ()
{
	Super.HideWindow();
	Root.m_bScaleWindowToRoot=False;
}

defaultproperties
{
    c_iNbOfIcons=16
}
