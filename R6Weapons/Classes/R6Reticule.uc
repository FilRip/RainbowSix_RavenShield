//================================================================================
// R6Reticule.
//================================================================================
class R6Reticule extends Actor
	Native
	Abstract
//	NoNativeReplication
	Config(User);

var() int m_iNonFunctionnalX;
var() int m_iNonFunctionnalY;
var bool m_bIdentifyCharacter;
var bool m_bAimingAtFriendly;
var bool m_bShowNames;
var float m_fAccuracy;
var float m_fZoomScale;
var float m_fReticuleOffsetX;
var float m_fReticuleOffsetY;
var Font m_SmallFont_14pt;
var config Color m_color;
var string m_CharacterName;

simulated function PostRender (Canvas C)
{
	m_iNonFunctionnalX=C.HalfClipX;
	m_iNonFunctionnalY=C.HalfClipY;
	C.SetDrawColor(m_color.R,m_color.G,m_color.B);
	C.SetPos(m_iNonFunctionnalX,m_iNonFunctionnalY);
	C.DrawText("(NO RETICULE)");
}

simulated function SetReticuleInfo (Canvas C)
{
	local Color aColor;
	local R6GameOptions GameOptions;

	C.SetDrawColor(m_color.R,m_color.G,m_color.B);
	GameOptions=GetGameOptions();
	if ( m_bAimingAtFriendly )
	{
		aColor=GameOptions.m_reticuleFriendColour;
		C.SetDrawColor(aColor.R,aColor.G,aColor.B);
	}
}

simulated function SetIdentificationReticule (Canvas C)
{
	local float fStrSizeX;
	local float fStrSizeY;
	local int X;
	local int Y;

	if ( m_bIdentifyCharacter && m_bShowNames )
	{
		C.UseVirtualSize(True,640.00,480.00);
		X=C.HalfClipX;
		Y=C.HalfClipY;
		C.Font=m_SmallFont_14pt;
		C.StrLen(m_CharacterName,fStrSizeX,fStrSizeY);
		C.SetPos(X - fStrSizeX / 2,Y + 24);
		C.DrawText(m_CharacterName);
	}
}

defaultproperties
{
    m_fZoomScale=1.00
    m_color=(R=0,G=0,B=255,A=0)
    RemoteRole=ROLE_None
    bHidden=True
}
/*
    m_SmallFont_14pt=Font'R6Font.Rainbow6_14pt'
*/

