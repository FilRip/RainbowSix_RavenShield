//================================================================================
// Canvas.
//================================================================================
class Canvas extends Object
	Native;

var Font Font;
var float SpaceX;
var float SpaceY;
var float OrgX;
var float OrgY;
var float ClipX;
var float ClipY;
var float HalfClipX;
var float HalfClipY;
var float CurX;
var float CurY;
var float Z;
var byte Style;
var float CurYL;
var Color DrawColor;
var bool bCenter;
var bool bNoSmooth;
var const int SizeX;
var const int SizeY;
var Font SmallFont;
var Font MedFont;
var const Viewport Viewport;
var int m_hBink;
var bool m_bPlaying;
var int m_iPosX;
var int m_iPosY;
var bool m_bForceMul2x;
var float m_fStretchX;
var float m_fStretchY;
var float m_fVirtualResX;
var float m_fVirtualResY;
var float m_fNormalClipX;
var float m_fNormalClipY;
var bool m_bDisplayGameOutroVideo;
var bool m_bChangeResRequested;
var int m_iNewResolutionX;
var int m_iNewResolutionY;
var bool m_bFading;
var bool m_bFadeAutoStop;
var Color m_FadeStartColor;
var Color m_FadeEndColor;
var float m_fFadeTotalTime;
var float m_fFadeCurrentTime;
var Material m_pWritableMapIconsTexture;

native(464) final function StrLen (coerce string String, out float XL, out float YL);

native(465) final function DrawText (coerce string Text, optional bool CR);

native(466) final function DrawTile (Material Mat, float XL, float YL, float U, float V, float UL, float VL, optional float fRotationAngle);

native(467) final function DrawActor (Actor A, bool Wireframe, optional bool ClearZ, optional float DisplayFOV);

native(468) final function DrawTileClipped (Material Mat, float XL, float YL, float U, float V, float UL, float VL);

native(469) final function DrawTextClipped (coerce string Text, optional bool bCheckHotKey);

native(470) final function string TextSize (coerce string String, out float XL, out float YL, optional int TotalWidth, optional int SpaceWidth);

native(480) final function DrawPortal (int X, int Y, int Width, int Height, Actor CamActor, Vector CamLocation, Rotator CamRotation, optional int FOV, optional bool ClearZ);

native(2005) final function SetMotionBlurIntensity (int iIntensityValue);

native(2400) final function bool GetScreenCoordinate (out float fScreenX, out float fScreenY, Vector v3DCoordinate, Vector vCamLocation, Rotator rCamRotation, optional float fFOV);

native(2403) final function Draw3DLine (Vector vStart, Vector vEnd, Color cLineColor);

native(2601) final function VideoOpen (string Name, int bDisplayDoubleSize);

native(2602) final function VideoClose ();

native(2603) final function VideoPlay (int iPosX, int iPosY, int bCentered);

native(2604) final function VideoStop ();

native(2800) final function DrawWritableMap (LevelInfo Info);

native(1606) final function UseVirtualSize (bool bUse, optional float X, optional float Y);

native(1607) final function SetVirtualSize (float X, float Y);

native(2623) final function SetPos (float X, float Y);

native(2624) final function SetOrigin (float X, float Y);

native(2625) final function SetClip (float X, float Y);

native(2626) final function SetDrawColor (byte R, byte G, byte B, optional byte A);

native(2627) final function DrawStretchedTextureSegmentNative (float X, float Y, float W, float H, float tX, float tY, float tW, float tH, float GUIScale, Region ClipRegion, Texture Tex);

native(2628) final function ClipTextNative (float X, float Y, coerce string S, float GUIScale, Region ClipRegion, optional bool bCheckHotKey);

event Reset ()
{
	Font=Font(DynamicLoadObject("R6Font.SmallFont",Class'Font'));
	SmallFont=Font;
	MedFont=Font(DynamicLoadObject("R6Font.MediumFont",Class'Font'));
	SpaceX=Default.SpaceX;
	SpaceY=Default.SpaceY;
	OrgX=Default.OrgX;
	OrgY=Default.OrgY;
	CurX=Default.CurX;
	CurY=Default.CurY;
	Style=Default.Style;
	DrawColor=Default.DrawColor;
	CurYL=Default.CurYL;
	bCenter=False;
	bNoSmooth=False;
	Z=1.00;
}

final function DrawPattern (Texture Tex, float XL, float YL, float Scale)
{
	DrawTile(Tex,XL,YL,(CurX - OrgX) * Scale,(CurY - OrgY) * Scale,XL * Scale,YL * Scale);
}

final function DrawIcon (Texture Tex, float Scale)
{
	if ( Tex != None )
	{
		DrawTile(Tex,Tex.USize * Scale,Tex.VSize * Scale,0.00,0.00,Tex.USize,Tex.VSize);
	}
}

final function DrawRect (Texture Tex, float RectX, float RectY)
{
	DrawTile(Tex,RectX,RectY,0.00,0.00,Tex.USize,Tex.VSize);
}

static final function Color MakeColor (byte R, byte G, byte B, optional byte A)
{
	local Color C;

	C.R=R;
	C.G=G;
	C.B=B;
	if ( A == 0 )
	{
		A=255;
	}
	C.A=A;
	return C;
}

final function DrawVertical (float X, float Height)
{
	SetPos(X,CurY);
//	DrawRect(Texture'WhiteSquareTexture',2.00,Height);
}

final function DrawHorizontal (float Y, float Width)
{
	SetPos(CurX,Y);
//	DrawRect(Texture'WhiteSquareTexture',Width,2.00);
}

final function DrawLine (int direction, float Size)
{
	local float X;
	local float Y;

	X=CurX;
	Y=CurY;
	switch (direction)
	{
		case 0:
		SetPos(X,Y - Size);
//		DrawRect(Texture'WhiteSquareTexture',2.00,Size);
		break;
		case 1:
//		DrawRect(Texture'WhiteSquareTexture',2.00,Size);
		break;
		case 2:
		SetPos(X - Size,Y);
//		DrawRect(Texture'WhiteSquareTexture',Size,2.00);
		break;
		case 3:
//		DrawRect(Texture'WhiteSquareTexture',Size,2.00);
		break;
		default:
	}
	SetPos(X,Y);
}

final simulated function DrawBracket (float Width, float Height, float bracket_size)
{
	local float X;
	local float Y;

	X=CurX;
	Y=CurY;
	Width=Max(Width,5);
	Height=Max(Height,5);
	DrawLine(3,bracket_size);
	DrawLine(1,bracket_size);
	SetPos(X + Width,Y);
	DrawLine(2,bracket_size);
	DrawLine(1,bracket_size);
	SetPos(X + Width,Y + Height);
	DrawLine(0,bracket_size);
	DrawLine(2,bracket_size);
	SetPos(X,Y + Height);
	DrawLine(3,bracket_size);
	DrawLine(0,bracket_size);
	SetPos(X,Y);
}

final simulated function DrawBox (Canvas Canvas, float Width, float Height)
{
	local float X;
	local float Y;

	X=Canvas.CurX;
	Y=Canvas.CurY;
//	Canvas.DrawRect(Texture'WhiteSquareTexture',2.00,Height);
//	Canvas.DrawRect(Texture'WhiteSquareTexture',Width,2.00);
	Canvas.SetPos(X + Width,Y);
//	Canvas.DrawRect(Texture'WhiteSquareTexture',2.00,Height);
	Canvas.SetPos(X,Y + Height);
//	Canvas.DrawRect(Texture'WhiteSquareTexture',Width + 1,2.00);
	Canvas.SetPos(X,Y);
}

final function float GetVirtualSizeX ()
{
	return m_fVirtualResX;
}

final function float GetVirtualSizeY ()
{
	return m_fVirtualResY;
}

defaultproperties
{
    Z=1.00
    Style=1
    DrawColor=(R=127,G=127,B=127,A=255)
    m_fStretchX=1.00
    m_fStretchY=1.00
    m_fVirtualResX=800.00
    m_fVirtualResY=600.00
    m_fNormalClipX=-1.00
    m_fNormalClipY=-1.00
}