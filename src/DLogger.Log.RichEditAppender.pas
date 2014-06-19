unit DLogger.Log.RichEditAppender;

interface

uses DLogger.Log, Vcl.ComCtrls, Vcl.Graphics, Vcl.Forms, System.Classes;

type
  TRichEditAppender = class(TInterfacedObject, ILogAppender)
  private
    type
      TNotification = class(TComponent)
      private
        FAppender: TRichEditAppender;
      protected
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      end;
  private
    FRichEdit: TRichEdit;
    FNotification: TNotification;
  public
    constructor Create(ARichEdit: TRichEdit);
    destructor Destroy; override;

    procedure Append(const Level: TLogLevel; const Value: string);
  end;

implementation



{ TRichEditAppender }

constructor TRichEditAppender.Create(ARichEdit: TRichEdit);
begin
  FNotification := TNotification.Create(nil);
  FNotification.FAppender := Self;

  FRichEdit := ARichEdit;
  FRichEdit.FreeNotification(FNotification);
end;

destructor TRichEditAppender.Destroy;
begin
  FNotification.Free;
  inherited;
end;

procedure TRichEditAppender.Append(const Level: TLogLevel; const Value: string);
begin
  if FRichEdit = nil then
  begin
    Exit;
  end;

  case Level of
    TLogLevel.ERROR,
    TLogLevel.FATAL: FRichEdit.SelAttributes.Color := clRed;
  else
    FRichEdit.SelAttributes.Color := clWindowText;
  end;

  FRichEdit.Lines.Add(Value);

  FRichEdit.Refresh;

  Application.ProcessMessages;
end;

{ TRichEditAppender.TNotification }

procedure TRichEditAppender.TNotification.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FAppender.FRichEdit) then
  begin
    FAppender.FRichEdit := nil;
  end;
end;

end.
