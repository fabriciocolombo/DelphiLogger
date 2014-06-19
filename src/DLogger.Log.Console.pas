unit DLogger.Log.Console;

interface

uses DLogger.Log, WinApi.Windows;

type
  TConsoleAppender = class(TInterfacedObject, ILogAppender)
  private
    FStdOut : THandle;
    FHasConsole: Boolean;
  public
    procedure Append(const Level: TLogLevel; const Value: string);
    procedure AfterConstruction; override;

    class procedure RegisterAppender;static;
  end;

implementation

{ TConsoleAppender }

procedure TConsoleAppender.AfterConstruction;
begin
  inherited;
  FHasConsole := IsConsole or AllocConsole;
  FStdOut := GetStdHandle(STD_OUTPUT_HANDLE);
end;

procedure TConsoleAppender.Append(const Level: TLogLevel; const Value: string);
var
  vColor: Word;
begin
  if FHasConsole then
  begin
    case Level of
      TLogLevel.ERROR,
      TLogLevel.FATAL: vColor := FOREGROUND_RED OR FOREGROUND_INTENSITY;
      TLogLevel.WARNING: vColor := FOREGROUND_GREEN or FOREGROUND_RED OR FOREGROUND_INTENSITY;
    else
      vColor := FOREGROUND_BLUE or FOREGROUND_GREEN or FOREGROUND_RED;
    end;

    SetConsoleTextAttribute(FStdOut, vColor);

    Writeln(Value);
  end;
end;

class procedure TConsoleAppender.RegisterAppender;
begin
	DLogger.Log.LoggerFactory.AddAppender(TConsoleAppender.Create);
end;

end.
