//================================================================================
// R6CrossReticule.
//================================================================================
class R6CrossReticule extends R6Reticule
	Config(User);

var const int c_iLineWidth;
var const int c_iLineHeight;
var(Textures) Texture m_LineTexture;

simulated function PostRender (Canvas C)
{
	local float fScale;
	local int iWidth;
	local int iHeight;
	local float fPositionAjustment;

	iWidth=c_iLineWidth;
	iHeight=c_iLineHeight;
	SetReticuleInfo(C);
	C.Style=1;
	C.UseVirtualSize(False);
	m_fAccuracy -= 0.14;
	if ( m_fAccuracy < 0.00 )
	{
		m_fAccuracy=0.00;
	}
	fPositionAjustment=m_fReticuleOffsetY * m_fAccuracy * 0.02;
	iHeight += c_iLineHeight * m_fAccuracy * 0.02;
	C.SetPos(m_fReticuleOffsetX - 1.00,m_fReticuleOffsetY - iHeight - fPositionAjustment);
	C.DrawRect(m_LineTexture,iWidth,iHeight);
	C.SetPos(m_fReticuleOffsetX - 1.00,m_fReticuleOffsetY + fPositionAjustment);
	C.DrawRect(m_LineTexture,iWidth,iHeight);
	C.SetPos(m_fReticuleOffsetX - iHeight - fPositionAjustment,m_fReticuleOffsetY - 1.00);
	C.DrawRect(m_LineTexture,iHeight,iWidth);
	C.SetPos(m_fReticuleOffsetX + fPositionAjustment,m_fReticuleOffsetY - 1.00);
	C.DrawRect(m_LineTexture,iHeight,iWidth);
}

defaultproperties
{
    c_iLineWidth=2
    c_iLineHeight=16
}
/*
    m_LineTexture=Texture'UWindow.WhiteTexture'
*/

