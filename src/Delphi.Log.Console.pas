unit Delphi.Log.Console;

interface

uses Delphi.Log, WinApi.Windows;

type
  TConsoleAppender = class(TInterfacedObject, ILogAppender)
  private
    FStdOut : THandle;
    FHasConsole: Boolean;
  public
    procedure Append(const Level: TLogLevel; const Value: string);
    procedure AfterConstruction; override;
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

initialization
  Delphi.Log.LoggerFactory.AddAppender(TConsoleAppender.Create);

end.
