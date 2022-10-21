//================================================================================
// R6MenuMPInGameRecMessages.
//================================================================================
class R6MenuMPInGameRecMessages extends R6MenuWidget;

var bool m_bFirstTimePaint;
var float m_fOffsetTxtPos;
var R6WindowTextLabel m_TextPreRecMessages[5];
var R6WindowPopUpBox m_pInGameRecMessagesPopUp;
var Region m_RRecMsg;

function Created ()
{
	local R6WindowTextLabel pR6TextLabelTemp;
	local Color LabelTextColor;

	LabelTextColor.R=129;
	LabelTextColor.G=209;
	LabelTextColor.B=238;
	m_pInGameRecMessagesPopUp=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pInGameRecMessagesPopUp.CreatePopUpFrameWindow(Localize("RecMessages","ID_HEADER","R6RecMessages"),R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize(),m_RRecMsg.X,m_RRecMsg.Y,m_RRecMsg.W,m_RRecMsg.H);
	m_pInGameRecMessagesPopUp.bAlwaysBehind=True;
	m_pInGameRecMessagesPopUp.m_bBGFullScreen=False;
	m_TextPreRecMessages[0]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_RRecMsg.X + 5,m_RRecMsg.Y + 30,WinWidth - 5,25.00,self));
	m_TextPreRecMessages[0].Text=Localize("Number","ID_NUM1","R6RecMessages") $ " " $ Localize("RecMessages","ID_MSG1","R6RecMessages");
	m_TextPreRecMessages[0].align=ta_left;
	m_TextPreRecMessages[0].m_Font=Root.Fonts[5];
	m_TextPreRecMessages[0].TextColor=LabelTextColor;
	m_TextPreRecMessages[0].m_BGTexture=None;
	m_TextPreRecMessages[0].m_bDrawBorders=False;
	m_TextPreRecMessages[1]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_RRecMsg.X + 5,m_RRecMsg.Y + 50,WinWidth - 5,25.00,self));
	m_TextPreRecMessages[1].Text=Localize("Number","ID_NUM2","R6RecMessages") $ " " $ Localize("RecMessages","ID_MSG2","R6RecMessages");
	m_TextPreRecMessages[1].align=ta_left;
	m_TextPreRecMessages[1].m_Font=Root.Fonts[5];
	m_TextPreRecMessages[1].TextColor=LabelTextColor;
	m_TextPreRecMessages[1].m_BGTexture=None;
	m_TextPreRecMessages[1].m_bDrawBorders=False;
	m_TextPreRecMessages[2]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_RRecMsg.X + 5,m_RRecMsg.Y + 70,WinWidth - 5,25.00,self));
	m_TextPreRecMessages[2].Text=Localize("Number","ID_NUM3","R6RecMessages") $ " " $ Localize("RecMessages","ID_MSG3","R6RecMessages");
	m_TextPreRecMessages[2].align=ta_left;
	m_TextPreRecMessages[2].m_Font=Root.Fonts[5];
	m_TextPreRecMessages[2].TextColor=LabelTextColor;
	m_TextPreRecMessages[2].m_BGTexture=None;
	m_TextPreRecMessages[2].m_bDrawBorders=False;
	m_TextPreRecMessages[3]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_RRecMsg.X + 5,m_RRecMsg.Y + 90,WinWidth - 5,25.00,self));
	m_TextPreRecMessages[3].Text=Localize("Number","ID_NUM4","R6RecMessages") $ " " $ Localize("RecMessages","ID_MSG4","R6RecMessages");
	m_TextPreRecMessages[3].align=ta_left;
	m_TextPreRecMessages[3].m_Font=Root.Fonts[5];
	m_TextPreRecMessages[3].TextColor=LabelTextColor;
	m_TextPreRecMessages[3].m_BGTexture=None;
	m_TextPreRecMessages[3].m_bDrawBorders=False;
	m_TextPreRecMessages[4]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_RRecMsg.X + 5,m_RRecMsg.Y + 110,WinWidth - 5,25.00,self));
	m_TextPreRecMessages[4].Text=Localize("Number","ID_NUM0","R6RecMessages") $ " " $ Localize("ExitMenu","ID_MSG0","R6RecMessages");
	m_TextPreRecMessages[4].align=ta_left;
	m_TextPreRecMessages[4].m_Font=Root.Fonts[5];
	m_TextPreRecMessages[4].TextColor=LabelTextColor;
	m_TextPreRecMessages[4].m_BGTexture=None;
	m_TextPreRecMessages[4].m_bDrawBorders=False;
	SetAcceptsFocus();
}

function Paint (Canvas C, float X, float Y)
{
	Super.Paint(C,X,Y);
	if (  !GetPlayerOwner().Pawn.IsAlive() )
	{
//		Root.ChangeCurrentWidget(0);
	}
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float fHeight;
	local float fWidth;
	local int i;

	if (  !m_bFirstTimePaint )
	{
		m_bFirstTimePaint=True;
		TextSize(C,Localize("RecMessages","ID_HEADER","R6RecMessages"),fWidth,fHeight);
		if ( fWidth > m_RRecMsg.W - m_fOffsetTxtPos )
		{
			m_RRecMsg.W=fWidth + m_fOffsetTxtPos;
		}
		for (i=0;i < 5;i++)
		{
			C.Font=m_TextPreRecMessages[i].m_Font;
			TextSize(C,m_TextPreRecMessages[i].Text,fWidth,fHeight);
			if ( fWidth > m_RRecMsg.W - m_fOffsetTxtPos )
			{
				m_RRecMsg.W=fWidth + m_fOffsetTxtPos;
			}
		}
		m_pInGameRecMessagesPopUp.ModifyPopUpFrameWindow(Localize("RecMessages","ID_HEADER","R6RecMessages"),R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize(),m_RRecMsg.X,m_RRecMsg.Y,m_RRecMsg.W,m_RRecMsg.H);
	}
}

function KeyDown (int Key, float X, float Y)
{
	local R6MenuInGameMultiPlayerRootWindow RootWindow;

	RootWindow=R6MenuInGameMultiPlayerRootWindow(OwnerWindow);
	switch (Key)
	{
/*		case RootWindow.Console.49:
//		RootWindow.ChangeCurrentWidget(28);
		break;
		case RootWindow.Console.50:
//		RootWindow.ChangeCurrentWidget(29);
		break;
		case RootWindow.Console.51:
//		RootWindow.ChangeCurrentWidget(30);
		break;
		case RootWindow.Console.52:
//		RootWindow.ChangeCurrentWidget(31);
		break;
		case RootWindow.Console.48:
//		RootWindow.ChangeCurrentWidget(0);
		break;
		default:*/
	}
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	local float fBkpOrgX;
	local float fBkpOrgY;

	if ( Msg == 11 )
	{
		fBkpOrgX=C.OrgX;
		fBkpOrgY=C.OrgY;
		C.OrgX=0.00;
		C.OrgY=(C.SizeY - 480) * 0.50;
		Super.WindowEvent(Msg,C,X,Y,Key);
		C.OrgX=fBkpOrgX;
		C.OrgY=fBkpOrgY;
	}
	else
	{
		Super.WindowEvent(Msg,C,X,Y,Key);
	}
}

defaultproperties
{
    m_fOffsetTxtPos=15.00
    m_RRecMsg=(X=11149829,Y=570621952,W=120,H=0)
}
