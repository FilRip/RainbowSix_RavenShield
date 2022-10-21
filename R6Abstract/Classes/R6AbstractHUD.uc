//================================================================================
// R6AbstractHUD.
//================================================================================
class R6AbstractHUD extends HUD
	Native
	Abstract;

enum EGoCode {
	GOCODE_Alpha,
	GOCODE_Bravo,
	GOCODE_Charlie,
	GOCODE_Zulu,
	GOCODE_None
};

var int m_iCycleHUDLayer;
var bool m_bToggleHelmet;
var bool m_bGetRes;
var float m_fNewHUDResX;
var float m_fNewHUDResY;
var string m_szStatusDetail;

function PostRender (Canvas C)
{
	if ( (m_fNewHUDResX > 0) && (m_fNewHUDResY > 0) )
	{
		C.SetVirtualSize(m_fNewHUDResX,m_fNewHUDResY);
		m_fNewHUDResX=0.00;
		m_fNewHUDResY=0.00;
	}
	if ( m_bGetRes )
	{
		PlayerController(Owner).ClientMessage(string(C.SizeX) @ "x" @ string(C.SizeY));
		m_bGetRes=False;
	}
	Super.PostRender(C);
}

function DrawTextCenteredInBox (Canvas C, string strText, float fPosX, float fPosY, float fWidth, float fHeight)
{
	local float fTextWidth;
	local float fTextHeight;
	local bool bBackCenter;
	local float fBackOrgX;
	local float fBackOrgY;
	local float fBackClipX;
	local float fBackClipY;

	bBackCenter=C.bCenter;
	fBackOrgX=C.OrgX;
	fBackOrgY=C.OrgY;
	fBackClipX=C.ClipX;
	fBackClipY=C.ClipY;
	C.bCenter=True;
	C.OrgX=fPosX;
	C.OrgY=fPosY;
	C.ClipX=fWidth;
	C.ClipY=fHeight;
	C.StrLen(strText,fTextWidth,fTextHeight);
	C.SetPos(0.00,(fHeight - fTextHeight) / 2.00);
	C.DrawText(strText);
	C.bCenter=bBackCenter;
	C.OrgX=fBackOrgX;
	C.OrgY=fBackOrgY;
	C.ClipX=fBackClipX;
	C.ClipY=fBackClipY;
}

function DrawTexturePart (Canvas C, Texture Tex, float fUStart, float fVStart, float fSizeX, float fSizeY)
{
	C.DrawTile(Tex,fSizeX,fSizeY,fUStart,fVStart,fSizeX,fSizeY);
}

exec function HUDRes (string strRes)
{
	local int iPos;
	local int X;
	local int Y;

	iPos=InStr(strRes,"x");
	X=int(Left(strRes,iPos));
	Y=int(Mid(strRes,iPos + 1));
	if ( (X > 0) && (Y > 0) )
	{
		m_fNewHUDResX=X;
		m_fNewHUDResY=Y;
	}
}

exec function GetRes ()
{
	m_bGetRes=True;
}

function string GetGoCodeStr (EGoCode goCode)
{
	switch (goCode)
	{
		case GOCODE_Alpha:
		return "A";
		case GOCODE_Bravo:
		return "B";
		case GOCODE_Charlie:
		return "C";
		case GOCODE_Zulu:
		return "D";
		default:
	}
	return "";
}

exec function ToggleHelmet ()
{
	m_bToggleHelmet= !m_bToggleHelmet;
}

exec function CycleHUDLayer ()
{
	m_iCycleHUDLayer++;
	if ( m_iCycleHUDLayer == 4 )
	{
		m_iCycleHUDLayer=0;
	}
}

function StartFadeToBlack (int iSec, int iPercentageOfBlack);

function StopFadeToBlack ();

function UpdateHudFilter ();

function ActivateNoDeathCameraMsg (bool bToggleOn);
