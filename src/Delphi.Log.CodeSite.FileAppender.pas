unit Delphi.Log.CodeSite.FileAppender;

interface

uses CodeSiteLogging, Delphi.Log;

type
  TCodeSiteFileAppender = class(TInterfacedObject, ILogAppender)
  private
    FCodeSiteDestination: TCodeSiteDestination;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;

    procedure Append(const Level: TLogLevel; const Value: string);
  end;

implementation

uses
  System.SysUtils;

{ TCodeSiteLogger }

procedure TCodeSiteFileAppender.AfterConstruction;
begin
  inherited;
  FCodeSiteDestination := TCodeSiteDestination.Create(nil);
  FCodeSiteDestination.Viewer.Active := false;
  FCodeSiteDestination.LogFile.Active := true;
  FCodeSiteDestination.LogFile.FilePath := ExtractFilePath(GetModuleName(HInstance));
  FCodeSiteDestination.LogFile.FileName := ExtractFileName(ChangeFileExt(GetModuleName(HInstance), '_log.log'));
  FCodeSiteDestination.LogFile.MaxSize := 1024 * 1024 * 10; //10MB
  FCodeSiteDestination.LogFile.MaxParts := 5;
  CodeSite.Destination := FCodeSiteDestination;
end;

procedure TCodeSiteFileAppender.Append(const Level: TLogLevel; const Value: string);
begin
  case Level of
    TRACE,
    DEBUG,
    INFO: CodeSite.Send(Value);
    WARNING: CodeSite.SendWarning(Value);
    ERROR,
    FATAL: CodeSite.SendError(Value);
    OFF: ;
  end;
end;

destructor TCodeSiteFileAppender.Destroy;
begin
  FCodeSiteDestination.Free;
  inherited;
end;

initialization
  LoggerFactory.AddAppender(TCodeSiteFileAppender.Create);

end.
