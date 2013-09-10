unit DLogger.Log.RichEditAppender;

interface

uses DLogger.Log, Vcl.ComCtrls, Vcl.Graphics, Vcl.Forms;

type
  TRichEditAppender = class(TInterfacedObject, ILogAppender)
  private
    FRichEdit: TRichEdit;
  public
    constructor Create(ARichEdit: TRichEdit);

    procedure Append(const Level: TLogLevel; const Value: string);
  end;

implementation

uses
  DLogger.Log.DelegateAppender;

{ TRichEditAppender }

constructor TRichEditAppender.Create(ARichEdit: TRichEdit);
begin
  FRichEdit := ARichEdit;
end;

procedure TRichEditAppender.Append(const Level: TLogLevel; const Value: string);
begin
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

end.
