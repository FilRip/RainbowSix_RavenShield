/*===========================================================================
    C++ class definitions exported from UnrealScript.
    This is automatically generated by the tools.
    DO NOT modify this manually! Edit the corresponding .uc files instead!
===========================================================================*/
#if SUPPORTS_PRAGMA_PACK
#pragma pack (push,4)
#endif

#ifndef FIRE_API
#define FIRE_API DLL_IMPORT
#endif

#ifndef NAMES_ONLY
#define AUTOGENERATE_NAME(name) extern FIRE_API FName FIRE_##name;
#define AUTOGENERATE_FUNCTION(cls,idx,name)
#endif


#ifndef NAMES_ONLY

enum PanningType
{
    SLIDE_Linear            =0,
    SLIDE_Circular          =1,
    SLIDE_Gestation         =2,
    SLIDE_WavyX             =3,
    SLIDE_WavyY             =4,
    SLIDE_MAX               =5,
};
enum TimingType
{
    TIME_FrameRateSync      =0,
    TIME_RealTimeScroll     =1,
    TIME_MAX                =2,
};

class FIRE_API UIceTexture : public UFractalTexture
{
public:
    BYTE PanningStyle;
    BYTE TimeMethod;
    BYTE HorizPanSpeed;
    BYTE VertPanSpeed;
    BYTE Frequency;
    BYTE Amplitude;
    BITFIELD MoveIce:1 GCC_PACK(4);
    FLOAT MasterCount GCC_PACK(4);
    FLOAT UDisplace;
    FLOAT VDisplace;
    FLOAT UPosition;
    FLOAT VPosition;
    class UTexture* GlassTexture;
    class UTexture* SourceTexture;
    INT OldUDisplace;
    INT OldVDisplace;
    INT LocalSource;
    INT ForceRefresh;
    FLOAT TickAccu;
    class UTexture* OldGlassTex;
    class UTexture* OldSourceTex;
    DECLARE_CLASS(UIceTexture,UFractalTexture,0,Fire)
    NO_DEFAULT_CONSTRUCTOR(UIceTexture)
};

enum WDrop
{
    DROP_FixedDepth         =0,
    DROP_PhaseSpot          =1,
    DROP_ShallowSpot        =2,
    DROP_HalfAmpl           =3,
    DROP_RandomMover        =4,
    DROP_FixedRandomSpot    =5,
    DROP_WhirlyThing        =6,
    DROP_BigWhirly          =7,
    DROP_HorizontalLine     =8,
    DROP_VerticalLine       =9,
    DROP_DiagonalLine1      =10,
    DROP_DiagonalLine2      =11,
    DROP_HorizontalOsc      =12,
    DROP_VerticalOsc        =13,
    DROP_DiagonalOsc1       =14,
    DROP_DiagonalOsc2       =15,
    DROP_RainDrops          =16,
    DROP_AreaClamp          =17,
    DROP_LeakyTap           =18,
    DROP_DrippyTap          =19,
    DROP_MAX                =20,
};

class FIRE_API UWaterTexture : public UFractalTexture
{
public:
    BYTE DropType;
    BYTE WaveAmp;
    BYTE FX_Frequency;
    BYTE FX_Phase;
    BYTE FX_Amplitude;
    BYTE FX_Speed;
    BYTE FX_Radius;
    BYTE FX_Size;
    BYTE FX_Depth;
    BYTE FX_Time;
    INT NumDrops;
    FADrop Drops[256];
    BYTE RenderTable[1028];
    BYTE WaterTable[1536];
    BYTE WaterParity;
    INT SourceFields;
    INT OldWaveAmp;
    DECLARE_CLASS(UWaterTexture,UFractalTexture,0,Fire)
    NO_DEFAULT_CONSTRUCTOR(UWaterTexture)
};


class FIRE_API UWetTexture : public UWaterTexture
{
public:
    class UTexture* SourceTexture;
    INT LocalSourceBitmap;
    class UTexture* OldSourceTex;
    DECLARE_CLASS(UWetTexture,UWaterTexture,0,Fire)
    NO_DEFAULT_CONSTRUCTOR(UWetTexture)
};


class FIRE_API UFluidTexture : public UWaterTexture
{
public:
    DECLARE_CLASS(UFluidTexture,UWaterTexture,0,Fire)
    NO_DEFAULT_CONSTRUCTOR(UFluidTexture)
};


class FIRE_API UWaveTexture : public UWaterTexture
{
public:
    BYTE BumpMapLight;
    BYTE BumpMapAngle;
    BYTE PhongRange;
    BYTE PhongSize;
    DECLARE_CLASS(UWaveTexture,UWaterTexture,0,Fire)
    NO_DEFAULT_CONSTRUCTOR(UWaveTexture)
};

enum ESpark
{
    SPARK_Burn              =0,
    SPARK_Sparkle           =1,
    SPARK_Pulse             =2,
    SPARK_Signal            =3,
    SPARK_Blaze             =4,
    SPARK_OzHasSpoken       =5,
    SPARK_Cone              =6,
    SPARK_BlazeRight        =7,
    SPARK_BlazeLeft         =8,
    SPARK_Cylinder          =9,
    SPARK_Cylinder3D        =10,
    SPARK_Lissajous         =11,
    SPARK_Jugglers          =12,
    SPARK_Emit              =13,
    SPARK_Fountain          =14,
    SPARK_Flocks            =15,
    SPARK_Eels              =16,
    SPARK_Organic           =17,
    SPARK_WanderOrganic     =18,
    SPARK_RandomCloud       =19,
    SPARK_CustomCloud       =20,
    SPARK_LocalCloud        =21,
    SPARK_Stars             =22,
    SPARK_LineLightning     =23,
    SPARK_RampLightning     =24,
    SPARK_SphereLightning   =25,
    SPARK_Wheel             =26,
    SPARK_Gametes           =27,
    SPARK_Sprinkler         =28,
    SPARK_MAX               =29,
};
enum DMode
{
    DRAW_Normal             =0,
    DRAW_Lathe              =1,
    DRAW_Lathe_2            =2,
    DRAW_Lathe_3            =3,
    DRAW_Lathe_4            =4,
    DRAW_MAX                =5,
};

class FIRE_API UFireTexture : public UFractalTexture
{
public:
    BYTE SparkType;
    BYTE RenderHeat;
    BYTE FX_Heat;
    BYTE FX_Size;
    BYTE FX_AuxSize;
    BYTE FX_Area;
    BYTE FX_Frequency;
    BYTE FX_Phase;
    BYTE FX_HorizSpeed;
    BYTE FX_VertSpeed;
    BYTE DrawMode;
    INT SparksLimit;
    INT NumSparks;
    BITFIELD bRising:1 GCC_PACK(4);
    BYTE RenderTable[1028] GCC_PACK(4);
    BYTE StarStatus;
    BYTE PenDownX;
    BYTE PenDownY;
    INT OldRenderHeat;
    TArrayNoInit<FSpark> Sparks;
    DECLARE_CLASS(UFireTexture,UFractalTexture,0,Fire)
    NO_DEFAULT_CONSTRUCTOR(UFireTexture)
};

#endif


#ifndef NAMES_ONLY
#undef AUTOGENERATE_NAME
#undef AUTOGENERATE_FUNCTION
#endif

#if SUPPORTS_PRAGMA_PACK
#pragma pack (pop)
#endif
