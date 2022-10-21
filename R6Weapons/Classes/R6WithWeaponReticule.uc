//================================================================================
// R6WithWeaponReticule.
//================================================================================
class R6WithWeaponReticule extends R6Reticule
	Config(User);

var const int c_iLineWidth;
var const int c_iLineHeight;
var(Textures) Texture m_LineTexture;

simulated function PostRender (Canvas C)
{
	local float fScale;
	local int iWidth;
	local int iHeight;
	local float fAjustedAccuracy;
	local float fPositionAjustment;
	local float fCenterOffsetX;
	local float fCenterOffsetY;

	iWidth=c_iLineWidth;
	iHeight=c_iLineHeight;
	fAjustedAccuracy=m_fAccuracy - 0.25;
	if ( fAjustedAccuracy < 0.00 )
	{
		fAjustedAccuracy=0.00;
	}
	iHeight += c_iLineHeight * fAjustedAccuracy * 0.02;
	SetReticuleInfo(C);
	C.Style=1;
	C.UseVirtualSize(False);
	fCenterOffsetX=C.SizeX / 640.00;
	fCenterOffsetY=C.SizeY / 480.00;
	C.SetPos(m_fReticuleOffsetX + fCenterOffsetX,m_fReticuleOffsetY + fCenterOffsetY);
	C.DrawRect(m_LineTexture,c_iLineWidth,c_iLineWidth);
	fPositionAjustment=m_fReticuleOffsetY * fAjustedAccuracy * 0.02;
	C.SetPos(m_fReticuleOffsetX + fCenterOffsetX,m_fReticuleOffsetY - iHeight - fPositionAjustment + fCenterOffsetY);
	C.DrawRect(m_LineTexture,iWidth,iHeight);
	C.SetPos(m_fReticuleOffsetX + fCenterOffsetX,m_fReticuleOffsetY + fPositionAjustment + fCenterOffsetY + 1);
	C.DrawRect(m_LineTexture,iWidth,iHeight);
	C.SetPos(m_fReticuleOffsetX - iHeight - fPositionAjustment + fCenterOffsetX,m_fReticuleOffsetY + fCenterOffsetY);
	C.DrawRect(m_LineTexture,iHeight,iWidth);
	C.SetPos(m_fReticuleOffsetX + fPositionAjustment + fCenterOffsetX + 1,m_fReticuleOffsetY + fCenterOffsetY);
	C.DrawRect(m_LineTexture,iHeight,iWidth);
}

defaultproperties
{
    c_iLineWidth=1
    c_iLineHeight=8
}
/*
    m_LineTexture=Texture'UWindow.WhiteTexture'
*/

