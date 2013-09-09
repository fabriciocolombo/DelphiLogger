unit Delphi.IO.RollingFileWriter;

interface

uses System.Classes, System.Generics.Collections, System.SyncObjs, System.TimeSpan,
     System.SysUtils, System.IOUtils, Winapi.Windows;

type
  TRollingFileWriter = class(TThread)
  strict private
    var FEvent: TEvent;
  private
    FStreamWriter: TStreamWriter;
    FQueue: TThreadedQueue<string>;
    FFileStream: TFileStream;
    FMaxFileSize: Integer;
    FMaxFileNumber: Integer;
    FFileName: string;

    procedure InitLogFile;
    procedure ShiftFileNames;
  protected
    function GetLogFileName(FileIndex: Integer = 0): String;
    procedure Rotate;
    procedure Release;
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Append(const Value: String);

    property MaxFileSize: Integer read FMaxFileSize write FMaxFileSize;
    property MaxFileNumber: Integer read FMaxFileNumber write FMaxFileNumber;
    property FileName: string read FFileName write FFileName;

    procedure StartThread;
  end;

implementation

{ TRollingFileWriter }

procedure TRollingFileWriter.Append(const Value: String);
begin
  FQueue.PushItem(Value);
end;

constructor TRollingFileWriter.Create;
begin
  FQueue := TThreadedQueue<string>.Create(1000, MaxLongint, 100);
  FreeOnTerminate := False;
  FEvent := TEvent.Create();
  inherited Create(True);
end;

destructor TRollingFileWriter.Destroy;
begin
  Terminate;
  WaitFor;
  FEvent.WaitFor(TTimeSpan.FromMinutes(1));

  FQueue.Free;
  FEvent.Free;
  inherited;
end;

procedure TRollingFileWriter.Execute;
var
  s: String;
begin
  NameThreadForDebugging('TRollingFileWriter');
  Rotate;
  FEvent.SetEvent;
  try
    try
      repeat
        while FQueue.PopItem(s) <> wrTimeout do
        begin
          Rotate;
          FStreamWriter.WriteLine(s);
        end;
      until Terminated;
    finally
      Release;
    end;
  except
  end;
  FEvent.SetEvent;
end;

function TRollingFileWriter.GetLogFileName(FileIndex: Integer): String;
var
  vFile: string;
begin
  if FileIndex = 0 then
    vFile := FFileName
  else
    vFile := Format('%s%3.3d%s', [ExtractFileName(FFileName), FileIndex, ExtractFileExt(FFileName)]);

  Result := vFile;
end;

procedure TRollingFileWriter.InitLogFile;
begin
  if TFile.Exists(GetLogFileName) then
    FFileStream := TFileStream.Create(GetLogFileName, fmOpenReadWrite or fmShareDenyWrite)
  else
    FFileStream := TFileStream.Create(GetLogFileName, fmCreate or fmOpenWrite or fmShareDenyWrite);

  FFileStream.Seek(0, soEnd);
  FStreamWriter := TStreamWriter.Create(FFileStream, TEncoding.ANSI);
  FStreamWriter.OwnStream;
end;

procedure TRollingFileWriter.Release;
begin
  if Assigned(FStreamWriter) then
  begin
    FStreamWriter.Close;
    FStreamWriter.Free;
    FStreamWriter := nil;
  end;
end;

procedure TRollingFileWriter.Rotate;
begin
  if Assigned(FStreamWriter) then
  begin
    if FStreamWriter.BaseStream.Position >= FMaxFileSize then
    begin
      FreeAndNil(FStreamWriter);
      ShiftFileNames;
      InitLogFile;
    end;
  end
  else
  begin
    InitLogFile;
  end;
  Assert(Assigned(FStreamWriter));
end;

procedure TRollingFileWriter.ShiftFileNames;
var
  i: Integer;
begin
  DeleteFile(PChar(GetLogFileName(FMaxFileNumber)));
  for i := FMaxFileNumber - 1 downto 0 do
  begin
    RenameFile(GetLogFileName(i), GetLogFileName(i + 1))
  end;
end;

procedure TRollingFileWriter.StartThread;
begin
  Start;
  FEvent.WaitFor(TTimeSpan.FromSeconds(120));
end;

end.
