unit DLogger.Log.RollingFileAppender;

interface

uses DLogger.Log, DLogger.IO.RollingFileWriter, System.SysUtils, Winapi.Windows;

const
  MAX_FILE_SIZE = 1024 * 1024 * 10; //10MB;
  MAX_FILE_NUMBER = 5;

type
  TRollingFileAppender = class(TInterfacedObject, ILogAppender)
  strict private
    FWriter: TRollingFileWriter;
  public
    destructor Destroy; override;

    constructor Create(const AMaxFileSize: Integer = MAX_FILE_SIZE; const AMaxFileNumber: Integer = MAX_FILE_NUMBER);

    procedure Append(const Level: TLogLevel; const Value: String);
  end;

implementation

{ TRollingFileAppender }

procedure TRollingFileAppender.Append(const Level: TLogLevel; const Value: String);
begin
  FWriter.Append(Value);
end;

constructor TRollingFileAppender.Create(const AMaxFileSize,AMaxFileNumber: Integer);
begin
  FWriter := TRollingFileWriter.Create;
  FWriter.FileName := ExtractFileName(ChangeFileExt(GetModuleName(HInstance), '_log.log'));
  FWriter.MaxFileSize := AMaxFileSize;
  FWriter.MaxFileNumber := AMaxFileNumber;
  FWriter.StartThread;
end;

destructor TRollingFileAppender.Destroy;
begin
  FWriter.Free;
  inherited;
end;

end.
