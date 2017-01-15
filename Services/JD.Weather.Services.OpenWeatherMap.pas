unit JD.Weather.Services.OpenWeatherMap;

interface

{$R 'OpenWeatherMapsRes.res' 'OpenWeatherMapsRes.rc'}

uses
  System.SysUtils,
  System.Classes,
  JD.Weather.Intf,
  JD.Weather.SuperObject,
  System.Generics.Collections;

const
  SVC_CAPTION = 'Open Weather Map';
  SVC_NAME = 'OpenWeatherMap';
  SVC_UID = '{12ECA995-0C16-49EB-AF76-83690B426A9D}';

  URL_MAIN = 'https://openweathermap.org/';
  URL_API = 'https://openweathermap.org/api';
  URL_REGISTER = 'https://home.openweathermap.org/users/sign_up';
  URL_LOGIN = 'https://home.openweathermap.org/users/sign_in';
  URL_LEGAL = 'http://openweathermap.org/terms';

  //Supported Pieces of Information
  SUP_INFO = [wiConditions, wiForecastSummary, wiForecastDaily, wiMaps];
  SUP_LOC = [wlZip, wlCityState, wlCoords, wlCityCode];
  SUP_LOGO = [ltColor, ltColorInvert, ltColorWide, ltColorInvertWide];
  SUP_COND_PROP = [wpIcon, wpCaption, wpDescription, wpTemp, wpTempMin,
    wpTempMax, wpWindDir, wpWindSpeed, wpPressure, wpHumidity, wpCloudCover,
    wpRainAmt, wpSnowAmt, wpSunrise, wpSunset];
  SUP_ALERT_TYPE = [];
  SUP_ALERT_PROP = [];
  SUP_FOR = [ftSummary, ftDaily];
  SUP_FOR_SUM = [wpIcon, wpCaption, wpDescription, wpTemp, wpTempMin, wpTempMax,
    wpWindDir, wpWindSpeed, wpPressure, wpPressureGround, wpPressureSea,
    wpHumidity, wpCloudCover, wpRainAmt, wpSnowAmt, wpPrecipPred];
  SUP_FOR_HOUR = [];
  SUP_FOR_DAY = [wpIcon, wpCaption, wpDescription, wpTemp, wpTempMin, wpTempMax,
    wpWindDir, wpWindSpeed, wpPressure, wpPressureGround, wpPressureSea,
    wpHumidity, wpCloudCover, wpRainAmt, wpSnowAmt];
  SUP_UNITS = [wuKelvin, wuImperial, wuMetric];
  SUP_MAP = [mpClouds, mpPrecip, mpPressureSea,
    mpWind, mpTemp, mpSnowCover];
  SUP_MAP_FOR = [wfPng, wfGif];

type
  TWeatherSupport = class(TInterfacedObject, IWeatherSupport)
  public
    function GetSupportedLogos: TWeatherLogoTypes;
    function GetSupportedUnits: TWeatherUnitsSet;
    function GetSupportedInfo: TWeatherInfoTypes;
    function GetSupportedLocations: TWeatherLocationTypes;
    function GetSupportedAlerts: TWeatherAlertTypes;
    function GetSupportedAlertProps: TWeatherAlertProps;
    function GetSupportedConditionProps: TWeatherPropTypes;
    function GetSupportedForecasts: TWeatherForecastTypes;
    function GetSupportedForecastSummaryProps: TWeatherPropTypes;
    function GetSupportedForecastHourlyProps: TWeatherPropTypes;
    function GetSupportedForecastDailyProps: TWeatherPropTypes;
    function GetSupportedMaps: TWeatherMapTypes;
    function GetSupportedMapFormats: TWeatherMapFormats;

    property SupportedLogos: TWeatherLogoTypes read GetSupportedLogos;
    property SupportedUnits: TWeatherUnitsSet read GetSupportedUnits;
    property SupportedInfo: TWeatherInfoTypes read GetSupportedInfo;
    property SupportedLocations: TWeatherLocationTypes read GetSupportedLocations;
    property SupportedAlerts: TWeatherAlertTypes read GetSupportedAlerts;
    property SupportedAlertProps: TWeatherAlertProps read GetSupportedAlertProps;
    property SupportedConditionProps: TWeatherPropTypes read GetSupportedConditionProps;
    property SupportedForecasts: TWeatherForecastTypes read GetSupportedForecasts;
    property SupportedForecastSummaryProps: TWeatherPropTypes read GetSupportedForecastSummaryProps;
    property SupportedForecastHourlyProps: TWeatherPropTypes read GetSupportedForecastHourlyProps;
    property SupportedForecastDailyProps: TWeatherPropTypes read GetSupportedForecastDailyProps;
    property SupportedMaps: TWeatherMapTypes read GetSupportedMaps;
    property SupportedMapFormats: TWeatherMapFormats read GetSupportedMapFormats;
  end;

  TWeatherURLs = class(TInterfacedObject, IWeatherURLs)
  public
    function GetMainURL: WideString;
    function GetApiURL: WideString;
    function GetLoginURL: WideString;
    function GetRegisterURL: WideString;
    function GetLegalURL: WideString;

    property MainURL: WideString read GetMainURL;
    property ApiURL: WideString read GetApiURL;
    property LoginURL: WideString read GetLoginURL;
    property RegisterURL: WideString read GetRegisterURL;
    property LegalURL: WideString read GetLegalURL;
  end;

  TWeatherServiceInfo = class(TInterfacedObject, IWeatherServiceInfo)
  private
    FSupport: TWeatherSupport;
    FURLs: TWeatherURLs;
    FLogos: TLogoArray;
    procedure SetLogo(const LT: TWeatherLogoType; const Value: IWeatherGraphic);
    procedure LoadLogos;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function GetCaption: WideString;
    function GetName: WideString;
    function GetUID: WideString;
    function GetURLs: IWeatherURLs;
    function GetSupport: IWeatherSupport;
    function GetLogo(const LT: TWeatherLogoType): IWeatherGraphic;

    property Logos[const LT: TWeatherLogoType]: IWeatherGraphic read GetLogo write SetLogo;

    property Caption: WideString read GetCaption;
    property Name: WideString read GetName;
    property UID: WideString read GetUID;
    property Support: IWeatherSupport read GetSupport;
    property URLs: IWeatherURLs read GetURLs;
  end;

  TWeatherService = class(TWeatherServiceBase, IWeatherService)
  private
    FInfo: TWeatherServiceInfo;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    function GetInfo: IWeatherServiceInfo;

    function GetMultiple(const Info: TWeatherInfoTypes): IWeatherMultiInfo;
    function GetLocation: IWeatherLocation;
    function GetConditions: IWeatherProps;
    function GetAlerts: IWeatherAlerts;
    function GetForecastSummary: IWeatherForecast;
    function GetForecastHourly: IWeatherForecast;
    function GetForecastDaily: IWeatherForecast;
    function GetMaps: IWeatherMaps;

    property Info: IWeatherServiceInfo read GetInfo;
  end;

implementation

{ TWeatherSupport }

function TWeatherSupport.GetSupportedUnits: TWeatherUnitsSet;
begin
  Result:= SUP_UNITS;
end;

function TWeatherSupport.GetSupportedLocations: TWeatherLocationTypes;
begin
  Result:= SUP_LOC;
end;

function TWeatherSupport.GetSupportedLogos: TWeatherLogoTypes;
begin
  Result:= SUP_LOGO;
end;

function TWeatherSupport.GetSupportedAlertProps: TWeatherAlertProps;
begin
  Result:= SUP_ALERT_PROP;
end;

function TWeatherSupport.GetSupportedAlerts: TWeatherAlertTypes;
begin
  Result:= SUP_ALERT_TYPE;
end;

function TWeatherSupport.GetSupportedConditionProps: TWeatherPropTypes;
begin
  Result:= SUP_COND_PROP;
end;

function TWeatherSupport.GetSupportedForecasts: TWeatherForecastTypes;
begin
  Result:= SUP_FOR;
end;

function TWeatherSupport.GetSupportedForecastDailyProps: TWeatherPropTypes;
begin
  Result:= SUP_FOR_DAY;
end;

function TWeatherSupport.GetSupportedForecastHourlyProps: TWeatherPropTypes;
begin
  Result:= SUP_FOR_HOUR;
end;

function TWeatherSupport.GetSupportedForecastSummaryProps: TWeatherPropTypes;
begin
  Result:= SUP_FOR_SUM;
end;

function TWeatherSupport.GetSupportedInfo: TWeatherInfoTypes;
begin
  Result:= SUP_INFO;
end;

function TWeatherSupport.GetSupportedMapFormats: TWeatherMapFormats;
begin
  Result:= SUP_MAP_FOR;
end;

function TWeatherSupport.GetSupportedMaps: TWeatherMapTypes;
begin
  Result:= SUP_MAP;
end;

{ TWeatherURLs }

function TWeatherURLs.GetApiURL: WideString;
begin
  Result:= URL_API;
end;

function TWeatherURLs.GetLegalURL: WideString;
begin
  Result:= URL_LEGAL;
end;

function TWeatherURLs.GetLoginURL: WideString;
begin
  Result:= URL_LOGIN;
end;

function TWeatherURLs.GetMainURL: WideString;
begin
  Result:= URL_MAIN;
end;

function TWeatherURLs.GetRegisterURL: WideString;
begin
  Result:= URL_REGISTER;
end;

{ TWeatherServiceInfo }

constructor TWeatherServiceInfo.Create;
var
  LT: TWeatherLogoType;
begin
  FSupport:= TWeatherSupport.Create;
  FSupport._AddRef;
  FURLs:= TWeatherURLs.Create;
  FURLs._AddRef;
  for LT:= Low(TWeatherLogoType) to High(TWeatherLogoType) do begin
    FLogos[LT]:= TWeatherGraphic.Create;
    FLogos[LT]._AddRef;
  end;
  LoadLogos;
end;

destructor TWeatherServiceInfo.Destroy;
var
  LT: TWeatherLogoType;
begin
  for LT:= Low(TWeatherLogoType) to High(TWeatherLogoType) do begin
    FLogos[LT]._Release;
  end;
  FURLs._Release;
  FURLs:= nil;
  FSupport._Release;
  FSupport:= nil;
  inherited;
end;

function TWeatherServiceInfo.GetCaption: WideString;
begin
  Result:= SVC_CAPTION;
end;

function TWeatherServiceInfo.GetName: WideString;
begin
  Result:= SVC_NAME;
end;

function TWeatherServiceInfo.GetSupport: IWeatherSupport;
begin
  Result:= FSupport;
end;

function TWeatherServiceInfo.GetUID: WideString;
begin
  Result:= SVC_UID;
end;

function TWeatherServiceInfo.GetURLs: IWeatherURLs;
begin
  Result:= FURLs;
end;

function TWeatherServiceInfo.GetLogo(const LT: TWeatherLogoType): IWeatherGraphic;
begin
  Result:= FLogos[LT];
end;

procedure TWeatherServiceInfo.SetLogo(const LT: TWeatherLogoType;
  const Value: IWeatherGraphic);
begin
  FLogos[LT].Base64:= Value.Base64;
end;

procedure TWeatherServiceInfo.LoadLogos;
  function Get(const N, T: String): IWeatherGraphic;
  var
    S: TResourceStream;
    R: TStringStream;
  begin
    Result:= TWeatherGraphic.Create;
    if ResourceExists(N, T) then begin
      S:= TResourceStream.Create(HInstance, N, PChar(T));
      try
        R:= TStringStream.Create;
        try
          S.Position:= 0;
          R.LoadFromStream(S);
          R.Position:= 0;
          Result.Base64:= R.DataString;
        finally
          FreeAndNil(R);
        end;
      finally
        FreeAndNil(S);
      end;
    end;
  end;
begin
  SetLogo(ltColor, Get('LOGO_COLOR', 'PNG'));
  SetLogo(ltColorInvert, Get('LOGO_COLOR_INVERT', 'PNG'));
  SetLogo(ltColorWide, Get('LOGO_COLOR_WIDE', 'PNG'));
  SetLogo(ltColorInvertWide, Get('LOGO_COLOR_INVERT_WIDE', 'PNG'));
  SetLogo(ltColorLeft, Get('LOGO_COLOR_LEFT', 'PNG'));
  SetLogo(ltColorRight, Get('LOGO_COLOR_RIGHT', 'PNG'));
end;

{ TWeatherService }

constructor TWeatherService.Create;
begin
  inherited;
  FInfo:= TWeatherServiceInfo.Create;
  FInfo._AddRef;
end;

destructor TWeatherService.Destroy;
begin
  FInfo._Release;
  FInfo:= nil;
  inherited;
end;

function TWeatherService.GetInfo: IWeatherServiceInfo;
begin
  Result:= FInfo;
end;

function TWeatherService.GetLocation: IWeatherLocation;
begin
  //TODO
end;

function TWeatherService.GetMultiple(
  const Info: TWeatherInfoTypes): IWeatherMultiInfo;
begin
  //TODO
end;

function TWeatherService.GetConditions: IWeatherProps;
begin
  //TODO
end;

function TWeatherService.GetAlerts: IWeatherAlerts;
begin
  //TODO
end;

function TWeatherService.GetForecastDaily: IWeatherForecast;
begin
  //TODO
end;

function TWeatherService.GetForecastHourly: IWeatherForecast;
begin
  //TODO
end;

function TWeatherService.GetForecastSummary: IWeatherForecast;
begin
  //TODO
end;

function TWeatherService.GetMaps: IWeatherMaps;
begin
  //TODO
end;

end.