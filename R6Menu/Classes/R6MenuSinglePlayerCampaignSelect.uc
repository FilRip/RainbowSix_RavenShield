//================================================================================
// R6MenuSinglePlayerCampaignSelect.
//================================================================================
class R6MenuSinglePlayerCampaignSelect extends UWindowDialogClientWindow;

var Texture m_BGTexture;
var R6WindowTextListBox m_CampaignListBox;
var R6WindowTextLabelCurved m_LCampaignTitle;

function Created ()
{
//	m_BGTexture=Texture(DynamicLoadObject("R6MenuTextures.Gui_BoxScroll",Class'Texture'));
	m_LCampaignTitle=R6WindowTextLabelCurved(CreateWindow(Class'R6WindowTextLabelCurved',0.00,0.00,WinWidth,31.00,self));
	m_LCampaignTitle.Text=Localize("SinglePlayer","TitleCampaign","R6Menu");
	m_LCampaignTitle.align=ta_center;
	m_LCampaignTitle.m_Font=Root.Fonts[8];
	m_LCampaignTitle.TextColor=Root.Colors.White;
	m_CampaignListBox=R6WindowTextListBox(CreateControl(Class'R6WindowTextListBox',0.00,30.00,WinWidth,WinHeight - m_LCampaignTitle.WinHeight,self));
	m_CampaignListBox.ListClass=Class'R6WindowListBoxItem';
//	m_CampaignListBox.SetCornerType(3);
	m_CampaignListBox.ToolTipString=Localize("Tip","CampaignListBox","R6Menu");
	m_CampaignListBox.m_fXItemRightPadding=5.00;
}

function RefreshListBox ()
{
	local int iFiles;
	local int i;
	local string szFileName;
	local string szDir;
	local R6PlayerCampaign PC;
	local R6MenuRootWindow RootWindow;

	m_CampaignListBox.Clear();
	RootWindow=R6MenuRootWindow(Root);
	if ( RootWindow.m_pFileManager == None )
	{
		Log("R6MenuRootWindow(Root).m_pFileManager == NONE");
		iFiles=0;
	}
	else
	{
		szDir="..\\save\\campaigns\\" $ Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szCampaignDir $ "\\";
		iFiles=RootWindow.m_pFileManager.GetNbFile(szDir,"cmp");
	}
	i=0;
JL00D9:
	if ( i < iFiles )
	{
		RootWindow.m_pFileManager.GetFileName(i,szFileName);
		if ( szFileName != "" )
		{
			LoadCampaign(szFileName);
		}
		i++;
		goto JL00D9;
	}
	if ( m_CampaignListBox.Items.Count() > 0 )
	{
		m_CampaignListBox.SetSelectedItem(R6WindowListBoxItem(m_CampaignListBox.Items.Next));
		m_CampaignListBox.MakeSelectedVisible();
		PC=R6PlayerCampaign(R6WindowListBoxItem(m_CampaignListBox.m_SelectedItem).m_Object);
		if ( PC != None )
		{
			R6MenuSinglePlayerWidget(OwnerWindow).UpdateSelectedCampaign(PC);
		}
	}
	else
	{
		R6MenuSinglePlayerWidget(OwnerWindow).UpdateSelectedCampaign(None);
	}
}

function DeleteCampaign ()
{
	local string temp;
	local string szDir;

	if ( m_CampaignListBox.m_SelectedItem != None )
	{
		szDir="..\\save\\campaigns\\" $ Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szCampaignDir $ "\\";
		temp=szDir $ m_CampaignListBox.m_SelectedItem.HelpText $ ".cmp";
		if ( R6MenuRootWindow(Root).m_pFileManager.DeleteFile(temp) )
		{
			RefreshListBox();
		}
	}
}

function LoadCampaign (string szCampaignName)
{
	local R6PlayerCampaign WorkCampaign;
	local R6WindowListBoxItem NewItem;

	if ( (R6MenuRootWindow(Root) != None) && (R6MenuSinglePlayerWidget(OwnerWindow).m_pFileManager != None) )
	{
		WorkCampaign=new Class'R6PlayerCampaign';
		WorkCampaign.m_FileName=Left(szCampaignName,InStr(szCampaignName,"."));
		WorkCampaign.m_OperativesMissionDetails=None;
		WorkCampaign.m_OperativesMissionDetails=new Class'R6MissionRoster';
		if ( R6MenuSinglePlayerWidget(OwnerWindow).m_pFileManager.LoadCampaign(WorkCampaign) )
		{
			NewItem=R6WindowListBoxItem(m_CampaignListBox.Items.Append(m_CampaignListBox.ListClass));
			NewItem.HelpText=WorkCampaign.m_FileName;
			NewItem.m_Object=WorkCampaign;
		}
	}
}

function bool SetupCampaign ()
{
	local R6PlayerCampaign PC;

	if ( m_CampaignListBox.m_SelectedItem != None )
	{
		PC=R6PlayerCampaign(R6WindowListBoxItem(m_CampaignListBox.m_SelectedItem).m_Object);
		if ( PC != None )
		{
			R6Console(Root.Console).m_PlayerCampaign=PC;
			return True;
		}
		else
		{
			return False;
		}
	}
	return False;
}

function Notify (UWindowDialogControl C, byte E)
{
	local R6PlayerCampaign PC;

	if ( (C == m_CampaignListBox) && (E == 2) )
	{
		if ( m_CampaignListBox.m_SelectedItem != None )
		{
			PC=R6PlayerCampaign(R6WindowListBoxItem(m_CampaignListBox.m_SelectedItem).m_Object);
			if ( PC != None )
			{
				R6MenuSinglePlayerWidget(OwnerWindow).UpdateSelectedCampaign(PC);
			}
		}
	}
}
