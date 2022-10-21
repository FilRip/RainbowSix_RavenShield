//================================================================================
// R6WindowLookAndFeel.
//================================================================================
class R6WindowLookAndFeel extends UWindowLookAndFeel;

var int m_iCloseBoxOffsetX;
var int m_iCloseBoxOffsetY;
var int m_iListHPadding;
var int m_iListVPadding;
var int m_iSize_ScrollBarFrameW;
var int m_iVScrollerWidth;
var int m_iScrollerOffset;
var Texture m_R6ScrollTexture;
var Texture m_TButtonBackGround;
var RegionButton m_SBUp;
var RegionButton m_SBDown;
var RegionButton m_SBRight;
var RegionButton m_SBLeft;
var Region m_SBBackground;
var Region m_SBVBorder;
var Region m_SBHBorder;
var Region m_SBScroller;
var Region m_CloseBoxUp;
var Region m_CloseBoxDown;
var Region m_RButtonBackGround;
var Color m_CBorder;

function List_DrawBackground (UWindowListControl W, Canvas C);

function R6List_DrawBackground (R6WindowListBox W, Canvas C);

function DrawWinTop (R6WindowHSplitter W, Canvas C);

function DrawHSplitterT (R6WindowHSplitter W, Canvas C);

function DrawHSplitterB (R6WindowHSplitter W, Canvas C);

function Texture R6GetTexture (R6WindowFramedWindow W);

function R6FW_DrawWindowFrame (R6WindowFramedWindow W, Canvas C);

function R6FW_SetupFrameButtons (R6WindowFramedWindow W, Canvas C);

function Region R6FW_GetClientArea (R6WindowFramedWindow W);

function DrawSpecialButtonBorder (R6WindowButton B, Canvas C, float X, float Y);

function DrawButtonBorder (UWindowWindow W, Canvas C, optional bool _bDefineBorderColor);

function FrameHitTest R6FW_HitTest (R6WindowFramedWindow W, float X, float Y);

function DrawPopUpFrameWindow (R6WindowPopUpBox W, Canvas C);

function Button_SetupEnumSignChoice (UWindowButton W, int eRegionId);

function DrawBox (UWindowWindow W, Canvas C, float X, float Y, float Width, float Height);

function DrawBGShading (UWindowWindow W, Canvas C, float X, float Y, float Width, float Height);

function DrawInGamePlayerStats (UWindowWindow W, Canvas C, int _iPlayerStats, float _fX, float _fY, float _fHeight, float _fWidth);

function DrawMPFavoriteIcon (UWindowWindow W, Canvas C, float _fX, float _fY, float _fHeight);

function DrawMPLockedIcon (UWindowWindow W, Canvas C, float _fX, float _fY, float _fHeight);

function DrawMPDedicatedIcon (UWindowWindow W, Canvas C, float _fX, float _fY, float _fHeight);

function DrawMPSpectatorIcon (UWindowWindow W, Canvas C, float _fX, float _fY, float _fHeight);

function DrawPopUpTextBackGround (UWindowWindow W, Canvas C, float _fHeight);