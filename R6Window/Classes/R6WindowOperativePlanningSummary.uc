//================================================================================
// R6WindowOperativePlanningSummary.
//================================================================================
class R6WindowOperativePlanningSummary extends UWindowWindow;

var byte m_BAlphaOpNameBg;
var byte m_BSelectedAlphaOpNameBg;
var byte m_BCurrentAlpha;
var byte m_BAlphaBg;
var int m_IXSpecialityOffset;
var int m_IXHealthOffset;
var int m_IYIconPos;
var int m_IHealthWidth;
var int m_IHealthHeight;
var int m_ISpecialityWidth;
var int m_ISpecialityHeight;
var bool m_bIsSelected;
var float m_fFaceWidth;
var float m_FaceHeight;
var float m_fNameLabelHeight;
var R6WindowBitMap m_OperativeFace;
var R6WindowBitMap m_BMPSpeciality;
var R6WindowBitMap m_BMPHealth;
var R6WindowTextLabel m_PrimaryWeapon;
var R6WindowTextLabel m_Armor;
var R6WindowTextLabel m_OperativeName;
var Texture m_TBottomLabelBG;
var Region m_RBottomLabelBG;
var Color m_LabelColor;
var Color m_CDarkColor;

function Created ()
{
	local float fLabelHeight;

	m_OperativeFace=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_BorderTextureRegion.H,m_BorderTextureRegion.W,m_fFaceWidth,m_FaceHeight,self));
	m_BMPSpeciality=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_FaceHeight + m_IXSpecialityOffset,m_IYIconPos,m_ISpecialityWidth,m_ISpecialityHeight,self));
	m_BMPSpeciality.m_iDrawStyle=5;
	m_BMPHealth=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_BMPSpeciality.WinLeft + m_BMPSpeciality.WinWidth + m_IXHealthOffset,m_IYIconPos,m_IHealthWidth,m_IHealthHeight,self));
	m_BMPHealth.m_iDrawStyle=5;
	m_OperativeName=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_BMPHealth.WinLeft + m_BMPHealth.WinWidth,0.00,WinWidth - m_BMPHealth.WinLeft - m_BMPHealth.WinWidth,m_fNameLabelHeight,self));
	m_OperativeName.m_bDrawBorders=False;
	m_OperativeName.Align=TA_Center;
	m_OperativeName.TextColor=Root.Colors.White;
	m_OperativeName.m_Font=Root.Fonts[5];
	m_OperativeName.m_BGTexture=None;
	fLabelHeight=(WinHeight - m_OperativeName.WinHeight) / 2;
	m_PrimaryWeapon=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_OperativeFace.WinLeft + m_fFaceWidth,m_OperativeName.WinTop + m_OperativeName.WinHeight,m_OperativeName.WinWidth,fLabelHeight,self));
	m_PrimaryWeapon.m_bDrawBorders=False;
	m_PrimaryWeapon.Align=TA_Left;
	m_PrimaryWeapon.TextColor=Root.Colors.White;
	m_PrimaryWeapon.m_Font=Root.Fonts[6];
	m_PrimaryWeapon.m_BGTexture=None;
	m_PrimaryWeapon.m_fLMarge=4.00;
	m_PrimaryWeapon.m_bFixedYPos=True;
	m_PrimaryWeapon.TextY=1.00;
	m_Armor=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_PrimaryWeapon.WinLeft,m_PrimaryWeapon.WinTop + m_PrimaryWeapon.WinHeight,m_OperativeName.WinWidth,fLabelHeight,self));
	m_Armor.m_bDrawBorders=False;
	m_Armor.Align=TA_Left;
	m_Armor.TextColor=Root.Colors.White;
	m_Armor.m_Font=Root.Fonts[6];
	m_Armor.m_BGTexture=None;
	m_Armor.m_fLMarge=m_PrimaryWeapon.m_fLMarge;
	m_Armor.m_bFixedYPos=True;
	m_BCurrentAlpha=m_BAlphaOpNameBg;
}

function setHealth (TexRegion _T)
{
	m_BMPHealth.t=_T.t;
	m_BMPHealth.R.X=_T.X;
	m_BMPHealth.R.Y=_T.Y;
	m_BMPHealth.R.W=_T.H;
	m_BMPHealth.R.H=_T.W;
}

function setSpeciality (TexRegion _T)
{
	m_BMPSpeciality.t=_T.t;
	m_BMPSpeciality.R.X=_T.X;
	m_BMPSpeciality.R.Y=_T.Y;
	m_BMPSpeciality.R.W=_T.H;
	m_BMPSpeciality.R.H=_T.W;
}

function setFace (Texture _T, Region _R)
{
	m_OperativeFace.t=_T;
	m_OperativeFace.R=_R;
}

function setLabels (string szPrimaryWeapon, string szArmor, string szOperativeName)
{
	m_PrimaryWeapon.SetNewText(szPrimaryWeapon,True);
	m_Armor.SetNewText(szArmor,True);
	m_OperativeName.SetNewText(szOperativeName,True);
}

function SetColor (Color _LabelColor, Color _DarkColor)
{
	m_BorderColor=_LabelColor;
	m_LabelColor=_LabelColor;
	m_CDarkColor=_DarkColor;
	m_BMPSpeciality.m_TextureColor=_LabelColor;
	m_BMPHealth.m_TextureColor=_LabelColor;
	SetSelected(m_bIsSelected);
}

function SetSelected (bool _IsSelected)
{
	if ( _IsSelected )
	{
		m_OperativeName.TextColor=Root.Colors.White;
		m_PrimaryWeapon.TextColor=Root.Colors.White;
		m_Armor.TextColor=Root.Colors.White;
		m_BCurrentAlpha=m_BSelectedAlphaOpNameBg;
	}
	else
	{
		m_OperativeName.TextColor=m_LabelColor;
		m_PrimaryWeapon.TextColor=m_LabelColor;
		m_Armor.TextColor=m_LabelColor;
		m_BCurrentAlpha=m_BAlphaOpNameBg;
	}
	m_BMPSpeciality.m_bUseColor= !_IsSelected;
	m_BMPHealth.m_bUseColor= !_IsSelected;
	m_bIsSelected=_IsSelected;
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=5;
	C.SetDrawColor(m_LabelColor.R,m_LabelColor.G,m_LabelColor.B,m_BCurrentAlpha);
	DrawStretchedTexture(C,m_OperativeFace.WinLeft + m_fFaceWidth,0.00,WinWidth - m_fFaceWidth - m_OperativeFace.WinLeft,m_OperativeName.WinHeight,m_TBottomLabelBG);
	C.SetDrawColor(m_CDarkColor.R,m_CDarkColor.G,m_CDarkColor.B,m_BAlphaBg);
	DrawStretchedTexture(C,m_OperativeFace.WinLeft + m_fFaceWidth,m_OperativeName.WinHeight,WinWidth - m_fFaceWidth - m_OperativeFace.WinLeft,WinHeight - m_OperativeName.WinHeight,m_TBottomLabelBG);
}

function AfterPaint (Canvas C, float X, float Y)
{
	C.Style=1;
	C.SetDrawColor(m_LabelColor.R,m_LabelColor.G,m_LabelColor.B,m_LabelColor.A);
	DrawStretchedTexture(C,m_OperativeFace.WinLeft + m_fFaceWidth,0.00,1.00,WinHeight,m_TBottomLabelBG);
	DrawStretchedTexture(C,m_OperativeFace.WinLeft + m_fFaceWidth,m_fNameLabelHeight,WinWidth - m_fFaceWidth - m_OperativeFace.WinLeft,1.00,m_TBottomLabelBG);
	DrawSimpleBorder(C);
}

defaultproperties
{
    m_BAlphaOpNameBg=77
    m_BSelectedAlphaOpNameBg=128
    m_BAlphaBg=128
    m_IXSpecialityOffset=1
    m_IXHealthOffset=3
    m_IYIconPos=4
    m_IHealthWidth=10
    m_IHealthHeight=10
    m_ISpecialityWidth=9
    m_ISpecialityHeight=9
    m_fFaceWidth=38.00
    m_FaceHeight=42.00
    m_fNameLabelHeight=17.00
    m_RBottomLabelBG=(X=664073,Y=570949632,W=10,H=1299672832)
}
/*
    m_TBottomLabelBG=Texture'UWindow.WhiteTexture'
*/

