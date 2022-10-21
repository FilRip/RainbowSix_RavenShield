//================================================================================
// R6MenuInGameInstructionWidget.
//================================================================================
class R6MenuInGameInstructionWidget extends R6MenuWidget;

var int m_iArrayHudStep[3];
var bool bIsChangingText;
var float m_fYInstructionTextPos;
var R6WindowSimpleFramedWindow m_InstructionText;
var R6InstructionSoundVolume m_pLastIntructionVolume;
var Region m_RMsgSize;
var string m_szText;

function Created ()
{
	local R6WindowWrappedTextArea TextArea;

	m_InstructionText=R6WindowSimpleFramedWindow(CreateWindow(Class'R6WindowSimpleFramedWindow',100.00,m_fYInstructionTextPos,440.00,100.00,self));
	m_InstructionText.CreateClientWindow(Class'R6WindowWrappedTextArea');
	TextArea=R6WindowWrappedTextArea(m_InstructionText.m_ClientArea);
	TextArea.m_HBorderTexture=None;
	TextArea.m_VBorderTexture=None;
	TextArea.SetAbsoluteFont(Root.Fonts[16]);
	TextArea.m_bUseBGTexture=True;
	TextArea.m_bUseBGColor=True;
//	m_InstructionText.m_eCornerType=3;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float fHeight;
	local float fWidth;
	local int iNbLines;
	local R6WindowWrappedTextArea TextArea;

	if ( bIsChangingText )
	{
		bIsChangingText=False;
		TextArea=R6WindowWrappedTextArea(m_InstructionText.m_ClientArea);
		TextArea.BeforePaint(C,X,Y);
		C.Font=Root.Fonts[16];
		TextSize(C,"TEST",fWidth,fHeight);
		iNbLines=TextArea.m_fYOffSet / fHeight;
		iNbLines += 1;
		iNbLines += TextArea.Lines;
		m_RMsgSize.H=fHeight * iNbLines;
		m_InstructionText.WinHeight=m_RMsgSize.H + 2 * m_InstructionText.m_fHBorderHeight + 2 * m_InstructionText.m_fHBorderOffset;
		TextArea.WinHeight=m_RMsgSize.H;
	}
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=5;
	C.SetDrawColor(Root.Colors.Black.R,Root.Colors.Black.G,Root.Colors.Black.B,128);
	DrawStretchedTextureSegment(C,m_InstructionText.WinLeft,m_InstructionText.WinTop,m_InstructionText.WinWidth,m_InstructionText.WinHeight,0.00,0.00,10.00,10.00,Texture'WhiteTexture');
}

function ChangeText (R6InstructionSoundVolume pISV, int iBox, int iParagraph)
{
	local string szParagraphID;
	local string szSectionID;
	local R6WindowWrappedTextArea TextArea;

	if ( (m_pLastIntructionVolume != None) && (m_pLastIntructionVolume != pISV) )
	{
		m_pLastIntructionVolume.StopInstruction();
	}
	m_pLastIntructionVolume=pISV;
	switch (iParagraph)
	{
		case 0:
		szParagraphID="TextA";
		break;
		case 1:
		szParagraphID="TextB";
		break;
		case 2:
		szParagraphID="TextC";
		break;
		case 3:
		szParagraphID="TextD";
		break;
		default:
	}
	switch (iBox)
	{
		case 1:
		szSectionID="BasicAreaBox1";
		break;
		case 2:
		szSectionID="BasicAreaBox2";
		break;
		case 3:
		szSectionID="BasicAreaBox3";
		break;
		case 4:
		szSectionID="BasicAreaBox4";
		break;
		case 5:
		szSectionID="BasicAreaBox5";
		break;
		case 6:
		szSectionID="BasicAreaBox6";
		break;
		case 7:
		szSectionID="BasicAreaBox7";
		break;
		case 8:
		szSectionID="ShootingAreaBox1";
		break;
		case 9:
		szSectionID="ShootingAreaBox2";
		break;
		case 10:
		szSectionID="ShootingAreaBox3";
		break;
		case 11:
		szSectionID="ShootingAreaBox4";
		break;
		case 12:
		szSectionID="ShootingAreaBox5";
		break;
		case 13:
		szSectionID="ShootingAreaBox6";
		break;
		case 14:
		szSectionID="ShootingAreaBox7";
		break;
		case 15:
		szSectionID="ShootingAreaBox8";
		break;
		case 16:
		szSectionID="ExplodingAreaBox1";
		break;
		case 17:
		szSectionID="ExplodingAreaBox2";
		break;
		case 18:
		szSectionID="ExplodingAreaBox3";
		break;
		case 19:
		szSectionID="ExplodingAreaBox4";
		break;
		case 20:
		szSectionID="ExplodingAreaBox5";
		break;
		case 21:
		szSectionID="RoomClearing1Box1";
		break;
		case 22:
		szSectionID="RoomClearing1Box2";
		break;
		case 23:
		szSectionID="RoomClearing1Box3";
		break;
		case 24:
		szSectionID="RoomClearing2Box1";
		break;
		case 25:
		szSectionID="RoomClearing3Box1";
		break;
		case 26:
		szSectionID="HostageRescue1";
		break;
		case 27:
		szSectionID="HostageRescue2";
		break;
		case 28:
		szSectionID="HostageRescue3";
		break;
		default:
	}
	m_szText=R6PlayerController(GetPlayerOwner()).LocalizeTraining(szSectionID,szParagraphID,"R6Training",iBox,iParagraph);
	TextArea=R6WindowWrappedTextArea(m_InstructionText.m_ClientArea);
	TextArea.Clear();
	TextArea.m_fYOffSet=10.00;
	TextArea.m_fXOffSet=15.00;
	TextArea.AddText(m_szText,Root.Colors.White,Root.Fonts[16]);
	TextArea.SetScrollable(False);
	bIsChangingText=True;
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	local float fBkpOrgY;

	if ( (Msg == 8) && (Key == GetPlayerOwner().GetKey("Action")) )
	{
		m_pLastIntructionVolume.SkipToNextInstruction();
	}
	if ( Msg == 11 )
	{
		fBkpOrgY=C.OrgY;
		C.OrgY=0.00;
		m_InstructionText.WinTop=C.SizeY / 480 * m_fYInstructionTextPos;
		Super.WindowEvent(Msg,C,X,Y,Key);
		C.OrgY=fBkpOrgY;
	}
	else
	{
		Super.WindowEvent(Msg,C,X,Y,Key);
	}
}

function ResolutionChanged (float W, float H)
{
	WinWidth=W;
	WinHeight=H;
	Super.ResolutionChanged(W,H);
}

defaultproperties
{
    m_fYInstructionTextPos=35.00
    m_RMsgSize=(X=664070,Y=570753024,W=60,H=26223108)
}
