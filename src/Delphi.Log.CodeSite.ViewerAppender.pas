unit Delphi.Log.CodeSite.ViewerAppender;

interface

uses CodeSiteLogging, Delphi.Log;

type
  TCodeSiteViewerAppender = class(TInterfacedObject, ILogAppender)
  private
    FCodeSiteDestination: TCodeSiteDestination;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;

    procedure Append(const Level: TLogLevel; const Value: string);
  end;

implementation

{ TCodeSiteViewerAppender }

procedure TCodeSiteViewerAppender.AfterConstruction;
begin
  inherited;
  FCodeSiteDestination := TCodeSiteDestination.Create(nil);
  FCodeSiteDestination.Viewer.Active := true;
  FCodeSiteDestination.LogFile.Active := false;
  CodeSite.Destination := FCodeSiteDestination;
end;

procedure TCodeSiteViewerAppender.Append(const Level: TLogLevel;const Value: string);
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

destructor TCodeSiteViewerAppender.Destroy;
begin
  FCodeSiteDestination.Free;
  inherited;
end;

initialization
  LoggerFactory.AddAppender(TCodeSiteViewerAppender.Create);

end.
