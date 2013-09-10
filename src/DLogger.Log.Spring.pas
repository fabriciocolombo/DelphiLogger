unit DLogger.Log.Spring;

interface

uses Spring.Services.Logging, Delphi.Log, Delphi.Log.Logger, Spring.Container, System.TypInfo;

type
  TSpringLogger = class(TLogger, Delphi.Log.ILogger, Spring.Services.Logging.ILogger)
  end;

  TSpringLoggerFactory = class(TLoggerFactory, Delphi.Log.ILoggerFactory, Spring.Services.Logging.ILoggerFactory)
  protected
    function CreateLogger(const Name: string): ILogger; override;
  public
    function GetDefaultLogger: Spring.Services.Logging.ILogger;
    function GetLogger(const name: string): Spring.Services.Logging.ILogger; overload;
    function GetLogger(typeInfo: PTypeInfo): Spring.Services.Logging.ILogger; overload;
  end;

implementation

{ TSpringLoggerFactory }

function TSpringLoggerFactory.CreateLogger(const Name: string): ILogger;
begin
  Result := TSpringLogger.Create(Name, GetLogLevel, GetAppenders);
end;

function TSpringLoggerFactory.GetDefaultLogger: Spring.Services.Logging.ILogger;
begin
  Result := inherited GetDefaultLogger as Spring.Services.Logging.ILogger;
end;

function TSpringLoggerFactory.GetLogger(const name: string): Spring.Services.Logging.ILogger;
begin
  Result := inherited GetLogger(name) as Spring.Services.Logging.ILogger;
end;

function TSpringLoggerFactory.GetLogger(typeInfo: PTypeInfo): Spring.Services.Logging.ILogger;
begin
  Result := inherited GetLogger(typeInfo) as Spring.Services.Logging.ILogger;
end;

initialization
  GlobalContainer.RegisterType<TSpringLoggerFactory>
                 .Implements<Spring.Services.Logging.ILoggerFactory>
                 .Implements<Delphi.Log.ILoggerFactory>
                 .AsSingleton;

end.
