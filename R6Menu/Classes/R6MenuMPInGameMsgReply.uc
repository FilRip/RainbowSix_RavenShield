//================================================================================
// R6MenuMPInGameMsgReply.
//================================================================================
class R6MenuMPInGameMsgReply extends R6MenuWidget;

var bool m_bFirstTimePaint;
var float m_fOffsetTxtPos;
var R6WindowTextLabel m_TextReply[7];
var R6WindowPopUpBox m_pInGameReplyPopUp;
var Region m_RMsgSize;

function Created ()
{
	local Color LabelTextColor;

	LabelTextColor.R=129;
	LabelTextColor.G=209;
	LabelTextColor.B=238;
	m_pInGameReplyPopUp=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pInGameReplyPopUp.CreatePopUpFrameWindow(Localize("Reply","ID_HEADER","R6RecMessages"),R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize(),m_RMsgSize.X,m_RMsgSize.Y,m_RMsgSize.W,m_RMsgSize.H);
	m_pInGameReplyPopUp.bAlwaysBehind=True;
	m_pInGameReplyPopUp.m_bBGFullScreen=False;
	m_TextReply[0]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',5.00,m_RMsgSize.Y + 30,WinWidth - 5,25.00,self));
	m_TextReply[0].Text=Localize("Number","ID_NUM1","R6RecMessages") $ " " $ Localize("Reply","ID_MSG31","R6RecMessages");
	m_TextReply[0].align=ta_left;
	m_TextReply[0].m_Font=Root.Fonts[5];
	m_TextReply[0].TextColor=LabelTextColor;
	m_TextReply[0].m_BGTexture=None;
	m_TextReply[0].m_bDrawBorders=False;
	m_TextReply[1]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',5.00,m_RMsgSize.Y + 50,WinWidth - 5,25.00,self));
	m_TextReply[1].Text=Localize("Number","ID_NUM2","R6RecMessages") $ " " $ Localize("Reply","ID_MSG32","R6RecMessages");
	m_TextReply[1].align=ta_left;
	m_TextReply[1].m_Font=Root.Fonts[5];
	m_TextReply[1].TextColor=LabelTextColor;
	m_TextReply[1].m_BGTexture=None;
	m_TextReply[1].m_bDrawBorders=False;
	m_TextReply[2]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',5.00,m_RMsgSize.Y + 70,WinWidth - 5,25.00,self));
	m_TextReply[2].Text=Localize("Number","ID_NUM3","R6RecMessages") $ " " $ Localize("Reply","ID_MSG33","R6RecMessages");
	m_TextReply[2].align=ta_left;
	m_TextReply[2].m_Font=Root.Fonts[5];
	m_TextReply[2].TextColor=LabelTextColor;
	m_TextReply[2].m_BGTexture=None;
	m_TextReply[2].m_bDrawBorders=False;
	m_TextReply[3]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',5.00,m_RMsgSize.Y + 90,WinWidth - 5,25.00,self));
	m_TextReply[3].Text=Localize("Number","ID_NUM4","R6RecMessages") $ " " $ Localize("Reply","ID_MSG34","R6RecMessages");
	m_TextReply[3].align=ta_left;
	m_TextReply[3].m_Font=Root.Fonts[5];
	m_TextReply[3].TextColor=LabelTextColor;
	m_TextReply[3].m_BGTexture=None;
	m_TextReply[3].m_bDrawBorders=False;
	m_TextReply[4]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',5.00,m_RMsgSize.Y + 110,WinWidth - 5,25.00,self));
	m_TextReply[4].Text=Localize("Number","ID_NUM5","R6RecMessages") $ " " $ Localize("Reply","ID_MSG35","R6RecMessages");
	m_TextReply[4].align=ta_left;
	m_TextReply[4].m_Font=Root.Fonts[5];
	m_TextReply[4].TextColor=LabelTextColor;
	m_TextReply[4].m_BGTexture=None;
	m_TextReply[4].m_bDrawBorders=False;
	m_TextReply[5]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',5.00,m_RMsgSize.Y + 130,WinWidth - 5,25.00,self));
	m_TextReply[5].Text=Localize("Number","ID_NUM6","R6RecMessages") $ " " $ Localize("Reply","ID_MSG36","R6RecMessages");
	m_TextReply[5].align=ta_left;
	m_TextReply[5].m_Font=Root.Fonts[5];
	m_TextReply[5].TextColor=LabelTextColor;
	m_TextReply[5].m_BGTexture=None;
	m_TextReply[5].m_bDrawBorders=False;
	m_TextReply[6]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',5.00,m_RMsgSize.Y + 150,WinWidth - 5,25.00,self));
	m_TextReply[6].Text=Localize("Number","ID_NUM0","R6RecMessages") $ " " $ Localize("ExitMenu","ID_MSG0","R6RecMessages");
	m_TextReply[6].align=ta_left;
	m_TextReply[6].m_Font=Root.Fonts[5];
	m_TextReply[6].TextColor=LabelTextColor;
	m_TextReply[6].m_BGTexture=None;
	m_TextReply[6].m_bDrawBorders=False;
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
		TextSize(C,Localize("Reply","ID_HEADER","R6RecMessages"),fWidth,fHeight);
		if ( fWidth > m_RMsgSize.W )
		{
			m_RMsgSize.W=fWidth;
		}
		i=0;
JL007F:
		if ( i < 7 )
		{
			C.Font=m_TextReply[i].m_Font;
			TextSize(C,m_TextReply[i].Text,fWidth,fHeight);
			if ( fWidth > m_RMsgSize.W - m_fOffsetTxtPos )
			{
				m_RMsgSize.W=fWidth + m_fOffsetTxtPos;
			}
			i++;
			goto JL007F;
		}
		m_pInGameReplyPopUp.ModifyPopUpFrameWindow(Localize("Reply","ID_HEADER","R6RecMessages"),R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize(),m_RMsgSize.X,m_RMsgSize.Y,m_RMsgSize.W,m_RMsgSize.H);
	}
}

function KeyDown (int Key, float X, float Y)
{
	local R6Rainbow aRainbow;
	local R6PlayerController aPC;
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(OwnerWindow);
	aPC=R6PlayerController(r6Root.m_R6GameMenuCom.m_PlayerController);
	aRainbow=R6Rainbow(aPC.Pawn);
	switch (Key)
	{
/*		case r6Root.Console.49:
		aPC.ServerPlayRecordedMsg("Reply ID_MSG31",19);
		break;
		case r6Root.Console.50:
		aPC.ServerPlayRecordedMsg("Reply ID_MSG32",20);
		break;
		case r6Root.Console.51:
		aPC.ServerPlayRecordedMsg("Reply ID_MSG33",26);
		break;
		case r6Root.Console.52:
		aPC.ServerPlayRecordedMsg("Reply ID_MSG34",24);
		break;
		case r6Root.Console.53:
		aPC.ServerPlayRecordedMsg("Reply ID_MSG35",10);
		break;
		case r6Root.Console.54:
		aPC.ServerPlayRecordedMsg("Reply ID_MSG36",22);
		break;
		default: */
	}
/*	if ( (Key >= r6Root.Console.48) && (Key <= r6Root.Console.57) )
	{
		r6Root.ChangeCurrentWidget(0);
	}*/
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
    m_RMsgSize=(X=11149829,Y=570621952,W=160,H=0)
}
