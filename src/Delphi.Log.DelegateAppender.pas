unit Delphi.Log.DelegateAppender;

interface

uses Delphi.Log;

type
  TOnLogMessage = procedure (const Level: TLogLevel; const Value: string) of object;
  TOnLogMessageDelegate = reference to procedure (const Level: TLogLevel; const Value: string);

  TDelegateAppender = class(TInterfacedObject, ILogAppender)
  private
    FOnLogMessage: TOnLogMessage;
    FOnLogMessageDelegate: TOnLogMessageDelegate;
  public
    constructor Create(AOnLogMessage: TOnLogMessage);overload;
    constructor Create(AOnLogMessageDelegate: TOnLogMessageDelegate);overload;

    procedure Append(const Level: TLogLevel; const Value: string);
  end;

implementation

{ TDelegateAppender }

procedure TDelegateAppender.Append(const Level: TLogLevel; const Value: string);
begin
  if Assigned(FOnLogMessage) then
  begin
    FOnLogMessage(Level,Value);
  end;

  if Assigned(FOnLogMessageDelegate) then
  begin
    FOnLogMessageDelegate(Level, Value);
  end;
end;

constructor TDelegateAppender.Create(AOnLogMessage: TOnLogMessage);
begin
  FOnLogMessage := AOnLogMessage;
end;

constructor TDelegateAppender.Create(AOnLogMessageDelegate: TOnLogMessageDelegate);
begin
  FOnLogMessageDelegate := AOnLogMessageDelegate;
end;

end.
