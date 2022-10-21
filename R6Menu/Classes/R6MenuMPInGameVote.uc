//================================================================================
// R6MenuMPInGameVote.
//================================================================================
class R6MenuMPInGameVote extends R6MenuWidget;

var bool m_bFirstTimePaint;
var float m_fOffsetTxtPos;
var R6WindowTextLabel m_AVoteText[4];
var R6WindowPopUpBox m_pPopUpBG;
var Region m_RVote;
var string m_szPlayerNameToKick;
const C_iNUMBER_OF_CHOICES= 3;

function Created ()
{
	local R6WindowTextLabel pR6TextLabelTemp;
	local Color LabelTextColor;

	LabelTextColor.R=129;
	LabelTextColor.G=209;
	LabelTextColor.B=238;
	m_pPopUpBG=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pPopUpBG.CreatePopUpFrameWindow(Localize("MPInGame","Vote_Title","R6Menu"),R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize(),m_RVote.X,m_RVote.Y,m_RVote.W,m_RVote.H);
	m_pPopUpBG.bAlwaysBehind=True;
	m_AVoteText[0]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_RVote.X + 5,m_RVote.Y + 30,WinWidth - 5,25.00,self));
	m_AVoteText[0].Text=Localize("Number","ID_NUM1","R6RecMessages") $ " " $ Localize("MPInGame","Vote_Yes","R6Menu");
	m_AVoteText[0].align=ta_left;
	m_AVoteText[0].m_Font=Root.Fonts[5];
	m_AVoteText[0].TextColor=LabelTextColor;
	m_AVoteText[0].m_BGTexture=None;
	m_AVoteText[0].m_bDrawBorders=False;
	m_AVoteText[1]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_RVote.X + 5,m_RVote.Y + 50,WinWidth - 5,25.00,self));
	m_AVoteText[1].Text=Localize("Number","ID_NUM2","R6RecMessages") $ " " $ Localize("MPInGame","Vote_No","R6Menu");
	m_AVoteText[1].align=ta_left;
	m_AVoteText[1].m_Font=Root.Fonts[5];
	m_AVoteText[1].TextColor=LabelTextColor;
	m_AVoteText[1].m_BGTexture=None;
	m_AVoteText[1].m_bDrawBorders=False;
	m_AVoteText[2]=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_RVote.X + 5,m_RVote.Y + 70,WinWidth - 5,25.00,self));
	m_AVoteText[2].Text=Localize("Number","ID_NUM0","R6RecMessages") $ " " $ Localize("ExitMenu","ID_MSG0","R6RecMessages");
	m_AVoteText[2].align=ta_left;
	m_AVoteText[2].m_Font=Root.Fonts[5];
	m_AVoteText[2].TextColor=LabelTextColor;
	m_AVoteText[2].m_BGTexture=None;
	m_AVoteText[2].m_bDrawBorders=False;
	SetAcceptsFocus();
}

function BeforePaint (Canvas C, float X, float Y)
{
	local string szTitle;
	local float fHeight;
	local float fWidth;
	local int i;

	Super.BeforePaint(C,X,Y);
	if (  !m_bFirstTimePaint )
	{
		m_bFirstTimePaint=True;
		szTitle=Localize("MPInGame","Vote_Title","R6Menu") $ " " $ m_szPlayerNameToKick;
		TextSize(C,szTitle,fWidth,fHeight);
		if ( fWidth > m_RVote.W - m_fOffsetTxtPos )
		{
			m_RVote.W=fWidth + m_fOffsetTxtPos;
		}
		for (i=0;i < 3;i++)
		{
			C.Font=m_AVoteText[i].m_Font;
			TextSize(C,m_AVoteText[i].Text,fWidth,fHeight);
			if ( fWidth > m_RVote.W - m_fOffsetTxtPos )
			{
				m_RVote.W=fWidth + m_fOffsetTxtPos;
			}
		}
		m_pPopUpBG.ModifyPopUpFrameWindow(szTitle,R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize(),m_RVote.X,m_RVote.Y,m_RVote.W,m_RVote.H);
	}
}

function KeyDown (int Key, float X, float Y)
{
	local R6MenuInGameMultiPlayerRootWindow R6CurrentRoot;
	local bool bCloseVoteMenu;

	R6CurrentRoot=R6MenuInGameMultiPlayerRootWindow(OwnerWindow);
	bCloseVoteMenu=True;
/*	switch (Key)
	{
		case R6CurrentRoot.Console.49:
		R6CurrentRoot.m_R6GameMenuCom.SetVoteResult(True);
		break;
		case R6CurrentRoot.Console.50:
		R6CurrentRoot.m_R6GameMenuCom.SetVoteResult(False);
		break;
		case R6CurrentRoot.Console.48:
		break;
		default:
		bCloseVoteMenu=False;
		break;
	}
	if ( bCloseVoteMenu )
	{
		R6CurrentRoot.ChangeWidget(0,True,False);
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
    m_RVote=(X=11149829,Y=570621952,W=80,H=0)
}
