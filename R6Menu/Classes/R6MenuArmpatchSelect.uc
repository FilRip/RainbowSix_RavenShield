//================================================================================
// R6MenuArmpatchSelect.
//================================================================================
class R6MenuArmpatchSelect extends UWindowDialogClientWindow;

var R6WindowTextListBox m_ArmPatchListBox;
var R6WindowTextLabelExt m_pTextLabel;
var UWindowBitmap m_ArmpatchBitmap;
var Texture m_TDefaultTexture;
var Texture m_TBlankTexture;
var Texture m_TInvalidTexture;
var R6WindowListBoxItem m_DefaultItem;
var R6FileManager m_pFileManager;
var Region m_RBlankTexture;
var string m_path;
var string m_Ext;

function CreateListBox (int X, int Y, int W, int H)
{
	if ( m_ArmPatchListBox != None )
	{
		return;
	}
	m_pFileManager=new Class'R6FileManager';
	m_ArmPatchListBox=R6WindowTextListBox(CreateControl(Class'R6WindowTextListBox',X,Y,W,H,self));
	m_ArmPatchListBox.ListClass=Class'R6WindowListBoxItem';
//	m_ArmPatchListBox.SetCornerType(0);
}

function CreateTextLabel (int X, int Y, int W, int H, string _szText, string _szToolTip)
{
	if ( m_pTextLabel != None )
	{
		return;
	}
	m_pTextLabel=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',X,Y,W,H,self));
	m_pTextLabel.bAlwaysBehind=True;
	m_pTextLabel.SetNoBorder();
	m_pTextLabel.m_Font=Root.Fonts[5];
	m_pTextLabel.m_vTextColor=Root.Colors.White;
//	m_pTextLabel.AddTextLabel(_szText,0.00,0.00,150.00,0,False);
	ToolTipString=_szToolTip;
}

function CreateArmPatchBitmap (int X, int Y, int W, int H)
{
	if ( m_ArmpatchBitmap != None )
	{
		return;
	}
	m_ArmpatchBitmap=UWindowBitmap(CreateWindow(Class'UWindowBitmap',X,Y,W,H,self));
//	m_ArmpatchBitmap.m_iDrawStyle=1;
	m_ArmpatchBitmap.t=m_TBlankTexture;
	m_ArmpatchBitmap.R=m_RBlankTexture;
}

function RefreshListBox ()
{
	local int iFiles;
	local int i;
	local string szFileName;
	local R6WindowListBoxItem NewItem;

	if ( m_ArmPatchListBox == None )
	{
		return;
	}
	m_ArmPatchListBox.Items.Clear();
	if ( m_pFileManager == None )
	{
		Log("m_pFileManager == NONE");
		iFiles=0;
	}
	else
	{
		iFiles=m_pFileManager.GetNbFile(m_path,m_Ext);
	}
	m_DefaultItem=R6WindowListBoxItem(m_ArmPatchListBox.Items.Append(m_ArmPatchListBox.ListClass));
	m_DefaultItem.HelpText=Localize("Options","DEFAULT","R6Menu");
	m_DefaultItem.m_szToolTip="";
	i=0;
JL00E8:
	if ( i < iFiles )
	{
		m_pFileManager.GetFileName(i,szFileName);
		if ( szFileName != "" )
		{
			NewItem=R6WindowListBoxItem(m_ArmPatchListBox.Items.Append(m_ArmPatchListBox.ListClass));
			NewItem.HelpText=Left(szFileName,Len(szFileName) - 4);
			NewItem.m_szToolTip=Caps(szFileName);
		}
		i++;
		goto JL00E8;
	}
	if ( m_ArmPatchListBox.Items.Count() > 0 )
	{
		m_ArmPatchListBox.SetSelectedItem(R6WindowListBoxItem(m_ArmPatchListBox.Items.Next));
		m_ArmPatchListBox.MakeSelectedVisible();
	}
}

function SetDesiredSelectedArmpatch (string _ArmPatchName)
{
	local int i;
	local bool Found;
	local R6WindowListBoxItem CurItem;
	local string inString;

	if ( m_ArmPatchListBox.Items == None )
	{
		return;
	}
	inString=Caps(_ArmPatchName);
	CurItem=R6WindowListBoxItem(m_ArmPatchListBox.Items.Next);
	i=0;
JL004C:
	if ( (i < m_ArmPatchListBox.Items.Count()) && (Found == False) )
	{
		if ( CurItem.m_szToolTip == inString )
		{
			Found=True;
		}
		else
		{
			CurItem=R6WindowListBoxItem(CurItem.Next);
		}
		i++;
		goto JL004C;
	}
	if ( Found )
	{
		m_ArmPatchListBox.SetSelectedItem(CurItem);
	}
}

function string GetSelectedArmpatch ()
{
	if ( m_ArmPatchListBox.m_SelectedItem != None )
	{
		if ( Class'Actor'.static.ReplaceTexture(m_path $ m_ArmPatchListBox.m_SelectedItem.m_szToolTip,m_ArmpatchBitmap.t) == True )
		{
			return m_ArmPatchListBox.m_SelectedItem.m_szToolTip;
		}
		else
		{
			return "";
		}
	}
	else
	{
		return "";
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	switch (E)
	{
		case 12:
		if ( C == m_ArmPatchListBox )
		{
			m_pTextLabel.ChangeColorLabel(Root.Colors.ButtonTextColor[2],0);
		}
		break;
		case 9:
		if ( C == m_ArmPatchListBox )
		{
			m_pTextLabel.ChangeColorLabel(Root.Colors.White,0);
		}
		break;
		case 2:
		if ( C == m_ArmPatchListBox )
		{
			if ( m_ArmPatchListBox.m_SelectedItem != None )
			{
				if ( R6WindowListBoxItem(m_ArmPatchListBox.m_SelectedItem) == m_DefaultItem )
				{
					m_ArmpatchBitmap.t=m_TDefaultTexture;
				}
				else
				{
					m_ArmpatchBitmap.t=m_TBlankTexture;
					if ( Class'Actor'.static.ReplaceTexture(m_path $ m_ArmPatchListBox.m_SelectedItem.m_szToolTip,m_ArmpatchBitmap.t) == False )
					{
						m_ArmpatchBitmap.t=m_TInvalidTexture;
					}
				}
			}
		}
		break;
		default:
	}
}

function SetToolTip (string _InString)
{
	m_ArmPatchListBox.ToolTipString=_InString;
}

defaultproperties
{
    m_RBlankTexture=(X=4203012,Y=570621952,W=64,H=0)
    m_path="..\\ArmPatches\\"
    m_Ext="TGA"
}
/*
    m_TDefaultTexture=Texture'R6Characters_T.Rainbow.R6armpatch'
    m_TBlankTexture=Texture'R6MenuTextures.R6armpatchblank'
    m_TInvalidTexture=Texture'R6MenuTextures.NotValid'
*/

