unit Delphi.Log.Logger;

interface

uses Delphi.Log,
     System.Generics.Collections, System.SysUtils;

type
  TLogger = class(TInterfacedObject, ILogger)
  private
    FName: String;
    FAppenders: TList<Pointer>;
    FLogLevel: TLogLevel;

    function GetLogLevelName(ALogLevel: TLogLevel): string;
    function GetTimeStamp: string;

    procedure Log(Level: TLogLevel; value: string);

    function TranslateException(e: Exception): string;
  public
    function GetName: string;

    procedure AddAppender(Appender: ILogAppender);

    function GetIsDebugEnabled: Boolean;
    function GetIsInfoEnabled: Boolean;
    function GetIsWarnEnabled: Boolean;
    function GetIsErrorEnabled: Boolean;
    function GetIsTraceEnabled: Boolean;
    function GetIsFatalEnabled: Boolean;

    procedure SetLogLevel(const Value: TLogLevel);

    constructor Create(AName: String; ALevel: TLogLevel; AAppenders: TList<ILogAppender>);
    destructor Destroy;override;

    procedure Trace(const msg: string);
    procedure TraceFormat(const msg: string; const args: array of const);

    procedure Debug(const msg: string); overload;
    procedure Debug(const msg: string; e: Exception); overload;
    procedure DebugFormat(const msg: string; const args: array of const); overload;
    procedure DebugFormat(const msg: string; const args: array of const; e: Exception); overload;

    procedure Info(const msg: string);overload;
    procedure Info(const msg: string; e: Exception); overload;
    procedure InfoFormat(const msg: string; const args: array of const);overload;
    procedure InfoFormat(const msg: string; const args: array of const; e: Exception); overload;

    procedure Warn(const msg: string); overload;
    procedure Warn(const msg: string; e: Exception); overload;
    procedure WarnFormat(const msg: string; const args: array of const); overload;
    procedure WarnFormat(const msg: string; const args: array of const; e: Exception); overload;

    procedure Error(const msg: string); overload;
    procedure Error(const msg: string; e: Exception); overload;
    procedure ErrorFormat(const msg: string; const args: array of const); overload;
    procedure ErrorFormat(const msg: string; const args: array of const; e: Exception); overload;

    procedure Fatal(const msg: string); overload;
    procedure Fatal(const msg: string; e: Exception); overload;
    procedure FatalFormat(const msg: string; const args: array of const); overload;
    procedure FatalFormat(const msg: string; const args: array of const; e: Exception); overload;
  end;

implementation

const
  LOG_TRACE   = 'TRACE';
  LOG_INFO    = ' INFO';
  LOG_DEBUG   = 'DEBUG';
  LOG_WARNING = ' WARN';
  LOG_ERROR   = 'ERROR';

{ TLogger }

procedure TLogger.AddAppender(Appender: ILogAppender);
var
  vPointer: Pointer;
begin
  vPointer := Pointer(IInterface(Appender));

  if not FAppenders.Contains(vPointer) then
  begin
    FAppenders.Add(vPointer);
  end;
end;

constructor TLogger.Create(AName: String; ALevel: TLogLevel; AAppenders: TList<ILogAppender>);
var
  vAppender: ILogAppender;
begin
  FName := AName;
  FLogLevel := ALevel;
  FAppenders := TList<Pointer>.Create;

  for vAppender in AAppenders do
  begin
    AddAppender(vAppender);
  end;
end;

function TLogger.GetIsDebugEnabled: Boolean;
begin
  Result := (FLogLevel = TLogLevel.DEBUG);
end;

function TLogger.GetIsErrorEnabled: Boolean;
begin
  Result := (FLogLevel = TLogLevel.ERROR);
end;

function TLogger.GetIsFatalEnabled: Boolean;
begin
  Result := (FLogLevel = TLogLevel.FATAL);
end;

function TLogger.GetIsInfoEnabled: Boolean;
begin
  Result := (FLogLevel = TLogLevel.INFO);
end;

function TLogger.GetIsTraceEnabled: Boolean;
begin
  Result := (FLogLevel = TLogLevel.TRACE);
end;

function TLogger.GetIsWarnEnabled: Boolean;
begin
  Result := (FLogLevel = TLogLevel.WARNING);
end;

procedure TLogger.Log(Level: TLogLevel; value: string);
var
  vPointer: Pointer;
  vAppender: ILogAppender;
  vFullMessage: string;
begin
  if Level >= FLogLevel then
  begin
    vFullMessage := Format('%s %s %s - %s', [GetTimeStamp, GetLogLevelName(Level), FName, Value]);

    for vPointer in FAppenders do
    begin
      vAppender := ILogAppender(vPointer);

      vAppender.Append(Level, vFullMessage);
    end;
  end;
end;

procedure TLogger.SetLogLevel(const Value: TLogLevel);
begin
  FLogLevel := Value;
end;

procedure TLogger.Trace(const msg: string);
begin
  Log(TLogLevel.TRACE, msg);
end;

procedure TLogger.TraceFormat(const msg: string; const args: array of const);
begin
  Log(TLogLevel.TRACE, format(msg, args));
end;

function TLogger.TranslateException(e: Exception): string;
begin
  Result := Format(' Exception: %s: %s ', [e.ClassName, Trim(e.ToString)]);

  Result := Result + sLineBreak + e.StackTrace
end;

procedure TLogger.Warn(const msg: string);
begin
  Log(TLogLevel.WARNING, msg);
end;

procedure TLogger.WarnFormat(const msg: string; const args: array of const);
begin
  Log(TLogLevel.WARNING, format(msg, args));
end;

procedure TLogger.Debug(const msg: string);
begin
  Log(TLogLevel.DEBUG, msg);
end;

procedure TLogger.DebugFormat(const msg: string; const args: array of const);
begin
  Log(TLogLevel.DEBUG, format(msg, args));
end;

destructor TLogger.Destroy;
begin
  FAppenders.Free;
  inherited;
end;

procedure TLogger.Error(const msg: string);
begin
  Log(TLogLevel.ERROR, msg);
end;

procedure TLogger.Error(const msg: string; e: Exception);
begin
  Log(TLogLevel.ERROR, msg + TranslateException(e));
end;

procedure TLogger.ErrorFormat(const msg: string; const args: array of const; e: Exception);
begin
  Log(TLogLevel.ERROR, format(msg, args) + TranslateException(e));
end;

procedure TLogger.Fatal(const msg: string);
begin
  FatalFormat(msg, []);
end;

procedure TLogger.Fatal(const msg: string; e: Exception);
begin
  FatalFormat(msg, [], e);
end;

procedure TLogger.FatalFormat(const msg: string; const args: array of const);
begin
  Log(TLogLevel.FATAL, Format(msg, args));
end;

procedure TLogger.FatalFormat(const msg: string; const args: array of const; e: Exception);
begin
  Log(TLogLevel.FATAL, format(msg, args) + TranslateException(e));
end;

procedure TLogger.ErrorFormat(const msg: string; const args: array of const);
begin
  Log(TLogLevel.ERROR, format(msg, args));
end;

function TLogger.GetLogLevelName(ALogLevel: TLogLevel): string;
begin
  case ALogLevel of
    TLogLevel.TRACE : Result := LOG_TRACE;
    TLogLevel.DEBUG : Result := LOG_DEBUG;
    TLogLevel.INFO  : Result := LOG_INFO;
    TLogLevel.WARNING : Result := LOG_WARNING;
    TLogLevel.ERROR : Result := LOG_ERROR;
  end;
end;

function TLogger.GetName: string;
begin
  Result := FName;
end;

function TLogger.GetTimeStamp: string;
begin
  Result := FormatDateTime('DD-MM-YYYY HH:NN:SS', Now)
end;

procedure TLogger.Info(const msg: string);
begin
  Log(TLogLevel.INFO, msg);
end;

procedure TLogger.InfoFormat(const msg: string; const args: array of const);
begin
  Log(TLogLevel.INFO, format(msg, args));
end;

procedure TLogger.Debug(const msg: string; e: Exception);
begin
  Log(TLogLevel.DEBUG, msg + TranslateException(e));
end;

procedure TLogger.DebugFormat(const msg: string; const args: array of const; e: Exception);
begin
  Log(TLogLevel.DEBUG, format(msg, args) + TranslateException(e));
end;

procedure TLogger.Info(const msg: string; e: Exception);
begin
  Log(TLogLevel.INFO, msg + TranslateException(e));
end;

procedure TLogger.InfoFormat(const msg: string; const args: array of const; e: Exception);
begin
  Log(TLogLevel.INFO, format(msg, args) + TranslateException(e));
end;

procedure TLogger.Warn(const msg: string; e: Exception);
begin
  Log(TLogLevel.WARNING, msg + TranslateException(e));
end;

procedure TLogger.WarnFormat(const msg: string; const args: array of const; e: Exception);
begin
  Log(TLogLevel.WARNING, format(msg, args) + TranslateException(e));
end;

end.
