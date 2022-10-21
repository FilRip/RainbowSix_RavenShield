//================================================================================
// R6MenuSinglePlayerCampaignCreate.
//================================================================================
class R6MenuSinglePlayerCampaignCreate extends UWindowDialogClientWindow;

var bool bShowLog;
var R6WindowTextLabel m_CampaignName;
var R6WindowTextLabel m_Difficulty;
var R6WindowTextLabel m_Difficulty1;
var R6WindowTextLabel m_Difficulty2;
var R6WindowTextLabel m_Difficulty3;
var R6MenuDiffCustomMissionSelect m_pDiffSelection;
var R6WindowEditControl m_CampaignNameEdit;

function Created ()
{
	local Color LabelTextColor;

	LabelTextColor=Root.Colors.White;
	m_CampaignName=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',5.00,0.00,WinWidth - 5,25.00,self));
	m_CampaignName.Text=Localize("SinglePlayer","CampaignName","R6Menu");
	m_CampaignName.Align=TA_Left;
	m_CampaignName.m_Font=Root.Fonts[5];
	m_CampaignName.TextColor=LabelTextColor;
	m_CampaignName.m_BGTexture=None;
	m_CampaignName.m_bDrawBorders=False;
	m_CampaignNameEdit=R6WindowEditControl(CreateControl(Class'R6WindowEditControl',3.00,24.00,WinWidth - 6,15.00,self));
	m_CampaignNameEdit.SetValue(Localize("SinglePlayer","DefaultCampaignName","R6Menu"));
	m_CampaignNameEdit.EditBox.Font=5;
	m_CampaignNameEdit.ForceCaps(True);
	m_CampaignNameEdit.SetEditBoxTip(Localize("Tip","CampaignDefaultName","R6Menu"));
	m_CampaignNameEdit.EditBox.SelectAll();
	m_CampaignNameEdit.SetMaxLength(30);
	m_Difficulty=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,59.00,WinWidth,30.00,self));
	m_Difficulty.Text=Localize("SinglePlayer","Difficulty","R6Menu");
	m_Difficulty.Align=TA_Center;
	m_Difficulty.m_Font=Root.Fonts[8];
	m_Difficulty.TextColor=LabelTextColor;
	m_Difficulty.m_bDrawBorders=False;
	m_pDiffSelection=R6MenuDiffCustomMissionSelect(CreateWindow(Class'R6MenuDiffCustomMissionSelect',0.00,m_Difficulty.WinTop + m_Difficulty.WinHeight,WinWidth,WinHeight - m_Difficulty.WinTop + m_Difficulty.WinHeight,self));
	m_pDiffSelection.m_pButLevel1.WinTop=m_pDiffSelection.m_pButLevel1.WinTop + 1;
	m_pDiffSelection.m_pButLevel2.WinTop=m_pDiffSelection.m_pButLevel2.WinTop + 12;
	m_pDiffSelection.m_pButLevel3.WinTop=m_pDiffSelection.m_pButLevel3.WinTop + 23;
	bAlwaysAcceptsFocus=True;
}

function KeyDown (int Key, float X, float Y)
{
	Super.KeyDown(Key,X,Y);
/*	if ( (Key == Root.Console.13) && (m_CampaignNameEdit.GetValue() != "") )
	{
		R6MenuSinglePlayerWidget(OwnerWindow).ButtonClicked(R6MenuSinglePlayerWidget(OwnerWindow).3);
	}*/
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( (C == m_CampaignNameEdit) && (E == 7) && (m_CampaignNameEdit.GetValue() != "") )
	{
//		R6MenuSinglePlayerWidget(OwnerWindow).ButtonClicked(R6MenuSinglePlayerWidget(OwnerWindow).3);
	}
}

function Reset ()
{
	m_CampaignNameEdit.SetValue(Localize("SinglePlayer","DefaultCampaignName","R6Menu"));
	m_CampaignNameEdit.EditBox.SelectAll();
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=4;
//	DrawStretchedTextureSegment(C,m_Difficulty.WinLeft,m_Difficulty.WinTop,m_Difficulty.WinWidth,m_Difficulty.WinHeight,77.00,0.00,4.00,29.00,Texture'Gui_BoxScroll');
	C.Style=5;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
/*	DrawStretchedTexture(C,0.00,m_Difficulty.WinTop,WinWidth,1.00,Texture'WhiteTexture');
	DrawStretchedTexture(C,0.00,m_Difficulty.WinTop + m_Difficulty.WinHeight,WinWidth,1.00,Texture'WhiteTexture');*/
}

function bool CreateCampaign ()
{
	local R6MenuRootWindow r6Root;
	local int iNbArrayElements;
	local int iNbTotalOperatives;
	local int i;
	local R6Operative tmpOperative;
	local Class<R6Operative> tmpOperativeClass;
	local R6PlayerCampaign PlayerCampaign;
	local R6ModMgr pModManager;

	pModManager=Class'Actor'.static.GetModMgr();
	r6Root=R6MenuRootWindow(Root);
	iNbArrayElements=0;
	if ( (m_CampaignNameEdit.GetValue() != "") && (r6Root != None) && (R6MenuSinglePlayerWidget(OwnerWindow).m_pFileManager != None) )
	{
		PlayerCampaign=R6Console(r6Root.Console).m_PlayerCampaign;
		PlayerCampaign.m_FileName=m_CampaignNameEdit.GetValue();
		PlayerCampaign.m_iDifficultyLevel=m_pDiffSelection.GetDifficulty();
		PlayerCampaign.m_CampaignFileName=R6Console(r6Root.Console).m_CurrentCampaign.m_szCampaignFile;
		PlayerCampaign.m_iNoMission=0;
		PlayerCampaign.m_OperativesMissionDetails=None;
		PlayerCampaign.m_OperativesMissionDetails=new Class'R6MissionRoster';
		iNbArrayElements=R6Console(r6Root.Console).m_CurrentCampaign.m_OperativeClassName.Length;
		i=0;
JL0164:
		if ( i < iNbArrayElements )
		{
			tmpOperative=new Class<R6Operative>(DynamicLoadObject(R6Console(r6Root.Console).m_CurrentCampaign.m_OperativeClassName[i],Class'Class'));
			PlayerCampaign.m_OperativesMissionDetails.m_MissionOperatives[i]=tmpOperative;
			if ( bShowLog )
			{
				Log("adding" @ string(tmpOperative) @ "to default player campaign roster");
			}
			i++;
			goto JL0164;
		}
		iNbTotalOperatives=i;
		i=0;
JL0238:
		if ( i < pModManager.GetPackageMgr().GetNbPackage() )
		{
			tmpOperativeClass=Class<R6Operative>(pModManager.GetPackageMgr().GetFirstClassFromPackage(i,Class'R6Operative'));
JL0289:
			if ( tmpOperativeClass != None )
			{
				tmpOperative=new tmpOperativeClass;
				if ( tmpOperative != None )
				{
					PlayerCampaign.m_OperativesMissionDetails.m_MissionOperatives[iNbTotalOperatives]=tmpOperative;
					iNbTotalOperatives++;
				}
				tmpOperativeClass=Class<R6Operative>(pModManager.GetPackageMgr().GetNextClassFromPackage());
				goto JL0289;
			}
			i++;
			goto JL0238;
		}
		if ( R6MenuSinglePlayerWidget(OwnerWindow).m_pFileManager.SaveCampaign(PlayerCampaign) == False )
		{
			r6Root.SimplePopUp(Localize("POPUP","FILEERROR","R6Menu"),PlayerCampaign.m_FileName @ ":" @ Localize("POPUP","FILEERRORPROBLEM","R6Menu"),EPopUpID_FileWriteError,1);
			return False;
		}
		else
		{
			return True;
		}
	}
	return False;
}
