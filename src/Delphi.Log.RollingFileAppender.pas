unit Delphi.Log.RollingFileAppender;

interface

uses Delphi.Log, Delphi.IO.RollingFileWriter, System.SysUtils, Winapi.Windows;

type
  TRollingFileAppender = class(TInterfacedObject, ILogAppender)
  strict private
    FWriter: TRollingFileWriter;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;

    procedure Append(const Level: TLogLevel; const Value: String);
  end;

implementation

{ TRollingFileAppender }

procedure TRollingFileAppender.AfterConstruction;
begin
  inherited;
  FWriter := TRollingFileWriter.Create;
  FWriter.FileName := ExtractFileName(ChangeFileExt(GetModuleName(HInstance), '_log.log'));
  FWriter.MaxFileSize := 1024 * 1024 * 10; //10MB
  FWriter.MaxFileNumber := 5;
  FWriter.StartThread;
end;

procedure TRollingFileAppender.Append(const Level: TLogLevel; const Value: String);
begin
  FWriter.Append(Value);
end;

destructor TRollingFileAppender.Destroy;
begin
  FWriter.Free;
  inherited;
end;

initialization
  Delphi.Log.LoggerFactory.AddAppender(TRollingFileAppender.Create);

end.
