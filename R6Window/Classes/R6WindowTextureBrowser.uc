//================================================================================
// R6WindowTextureBrowser.
//================================================================================
class R6WindowTextureBrowser extends UWindowDialogClientWindow;

var int m_iNbDisplayedElement;
var bool m_bSBInitialized;
var bool m_bBitMapInitialized;
var bool bShowLog;
var R6WindowBitMap m_CurrentSelection;
var UWindowHScrollbar m_HSB;
var R6WindowTextLabelExt m_pTextLabel;
var array<Texture> m_TextureCollection;
var array<Region> m_TextureRegionCollection;

function CreateBitmap (int X, int Y, int W, int H)
{
	if ( m_CurrentSelection == None )
	{
		m_CurrentSelection=R6WindowBitMap(CreateControl(Class'R6WindowBitMap',X,Y,W,H,self));
	}
	m_bBitMapInitialized=True;
}

function SetBitmapProperties (bool _bStretch, bool _bCenter, int _iDrawStyle, bool _bUseColor, optional Color _TextureColor)
{
	if ( m_CurrentSelection != None )
	{
		m_CurrentSelection.m_bUseColor=_bUseColor;
		m_CurrentSelection.m_TextureColor=_TextureColor;
		m_CurrentSelection.bStretch=_bStretch;
		m_CurrentSelection.bCenter=_bCenter;
		m_CurrentSelection.m_iDrawStyle=_iDrawStyle;
	}
}

function SetBitmapBorder (bool _bDrawBorder, Color _borderColor)
{
	if ( m_CurrentSelection != None )
	{
		m_CurrentSelection.m_bDrawBorder=_bDrawBorder;
		m_CurrentSelection.m_BorderColor=_borderColor;
	}
}

function CreateSB (int X, int Y, int W, int H)
{
	m_HSB=UWindowHScrollbar(CreateControl(Class'UWindowHScrollbar',X,Y,W,LookAndFeel.Size_ScrollbarWidth,self));
	m_HSB.SetRange(0.00,m_TextureCollection.Length,m_iNbDisplayedElement);
	m_bSBInitialized=True;
}

function CreateTextLabel (int X, int Y, int W, int H, string _szText, string _szToolTip)
{
	m_pTextLabel=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',X,Y,W,H,self));
	m_pTextLabel.bAlwaysBehind=True;
	m_pTextLabel.SetNoBorder();
	m_pTextLabel.m_Font=Root.Fonts[5];
	m_pTextLabel.m_vTextColor=Root.Colors.White;
//	m_pTextLabel.AddTextLabel(_szText,0.00,0.00,150.00,0,False);
	ToolTipString=_szToolTip;
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		switch (C)
		{
			case m_HSB.LeftButton:
			case m_HSB.RightButton:
			if ( bShowLog )
			{
				Log("Yo1 m_HSB.Pos" @ string(m_HSB.pos));
			}
			if ( m_TextureCollection.Length > 0 )
			{
				m_CurrentSelection.t=m_TextureCollection[m_HSB.pos];
				m_CurrentSelection.R=m_TextureRegionCollection[m_HSB.pos];
			}
			break;
			default:
		}
	}
	if ( E == 1 )
	{
		switch (C)
		{
			case m_HSB:
			if ( bShowLog )
			{
				Log("Yo2 m_HSB.Pos" @ string(m_HSB.pos));
			}
			if ( bShowLog )
			{
				Log("Yo2 m_TextureCollection.length" @ string(m_TextureCollection.Length));
			}
			if ( m_TextureCollection.Length > 0 )
			{
				m_CurrentSelection.t=m_TextureCollection[m_HSB.pos];
				m_CurrentSelection.R=m_TextureRegionCollection[m_HSB.pos];
				if ( bShowLog )
				{
					Log("m_CurrentSelection.T " @ string(m_CurrentSelection.t));
				}
				if ( bShowLog )
				{
					Log("m_CurrentSelection.R.W" @ string(m_CurrentSelection.R.W));
				}
			}
			break;
			default:
		}
	}
	if ( E == 12 )
	{
		switch (C)
		{
			case m_CurrentSelection:
			case m_HSB:
			if ( m_pTextLabel != None )
			{
				m_pTextLabel.ChangeColorLabel(Root.Colors.ButtonTextColor[2],0);
			}
			if ( m_CurrentSelection != None )
			{
				m_CurrentSelection.m_BorderColor=Root.Colors.ButtonTextColor[2];
			}
			if ( m_HSB != None )
			{
				m_HSB.m_NormalColor=Root.Colors.ButtonTextColor[2];
			}
			break;
			default:
		}
	}
	if ( E == 9 )
	{
		switch (C)
		{
			case m_CurrentSelection:
			case m_HSB:
			if ( m_pTextLabel != None )
			{
				m_pTextLabel.ChangeColorLabel(Root.Colors.White,0);
			}
			if ( m_CurrentSelection != None )
			{
				m_CurrentSelection.m_BorderColor=Root.Colors.White;
			}
			if ( m_HSB != None )
			{
				m_HSB.m_NormalColor=Root.Colors.White;
			}
			break;
			default:
		}
	}
}

function int AddTexture (Texture _Texture, Region _Region)
{
	if ( bShowLog )
	{
		Log("AddTexture inserting at" @ string(m_TextureCollection.Length));
	}
	if ( _Texture != None )
	{
		m_TextureRegionCollection[m_TextureCollection.Length]=_Region;
		m_TextureCollection[m_TextureCollection.Length]=_Texture;
		if ( m_HSB != None )
		{
			m_HSB.SetRange(0.00,m_TextureCollection.Length,m_iNbDisplayedElement);
		}
		if ( bShowLog )
		{
			Log("m_TextureCollection[m_TextureCollection.length -1]" @ string(m_TextureCollection[m_TextureCollection.Length - 1]));
		}
		if ( bShowLog )
		{
			Log("m_TextureRegionCollection[m_TextureCollection.length -1].W" @ string(m_TextureRegionCollection[m_TextureCollection.Length - 1].W));
		}
		if ( bShowLog )
		{
			Log("m_TextureCollection.length" @ string(m_TextureCollection.Length));
		}
		return m_TextureCollection.Length - 1;
	}
	return -1;
}

function RemoveTexture (Texture _Texture)
{
	if ( m_HSB != None )
	{
		m_HSB.SetRange(0.00,Max(0,m_TextureCollection.Length - 1),m_iNbDisplayedElement);
	}
	return;
}

function RemoveTextureFromIndex (int _index)
{
	m_TextureCollection.Remove (_index,_index);
	m_TextureRegionCollection.Remove (_index,_index);
	if ( m_HSB != None )
	{
		m_HSB.SetRange(0.00,Max(0,m_TextureCollection.Length - 1),m_iNbDisplayedElement);
	}
}

function int GetTextureIndex (Texture _Texture)
{
	return -1;
}

function int GetCurrentTextureIndex ()
{
	if ( m_TextureCollection.Length > 0 )
	{
		if ( m_HSB != None )
		{
			return m_HSB.pos;
		}
		else
		{
			return 0;
		}
	}
	else
	{
		return -1;
	}
}

function SetCurrentTextureFromIndex (int _index)
{
	if ( m_TextureCollection.Length > _index )
	{
		m_HSB.Show(_index);
	}
}

function Texture GetTextureAtIndex (int _index)
{
	return None;
}

function GetCurrentSelectedTexture ()
{
	return;
}

function Clear ()
{
	m_TextureCollection.Remove (0,m_TextureCollection.Length);
	m_TextureRegionCollection.Remove (0,m_TextureCollection.Length);
	m_HSB.SetRange(0.00,0.00,m_iNbDisplayedElement);
}

defaultproperties
{
    m_iNbDisplayedElement=1
}
