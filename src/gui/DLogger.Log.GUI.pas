unit DLogger.Log.GUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, DLogger.Log,
  Vcl.ExtCtrls;

type
  TOnHideLog = reference to procedure;

  TFrm_Log = class(TForm)
    Memo_Log: TRichEdit;
    Panel1: TPanel;
    btnFechar: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormHide(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFecharClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  strict private
    class var Instance: TFrm_Log;
  private
    FOnHide: TOnHideLog;

    procedure DoOnHide;
  public
    constructor Create(AOwner: TComponent); override;

    class procedure ShowLog;overload;
    class procedure ShowLog(AOnHide: TOnHideLog);overload;
    class procedure HideLog;
  end;

implementation

uses
  DLogger.Log.RichEditAppender;

{$R *.dfm}

{ TFrm_Log }

procedure TFrm_Log.btnFecharClick(Sender: TObject);
begin
  HideLog;
end;

constructor TFrm_Log.Create(AOwner: TComponent);
begin
  inherited;
  TFrm_Log.Instance := Self;

  LoggerFactory.AddAppender(TRichEditAppender.Create(Memo_Log));
end;

procedure TFrm_Log.DoOnHide;
begin
  if Assigned(FOnHide) then
  begin
    FOnHide();
  end;
end;

procedure TFrm_Log.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DoOnHide;
end;

procedure TFrm_Log.FormHide(Sender: TObject);
begin
  DoOnHide;
end;

procedure TFrm_Log.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Char(Key) = 'L') then
  begin
    HideLog;
  end;
end;

procedure TFrm_Log.FormResize(Sender: TObject);
begin
  Memo_Log.Refresh;
end;

class procedure TFrm_Log.HideLog;
begin
  TFrm_Log.Instance.Hide;
end;

class procedure TFrm_Log.ShowLog(AOnHide: TOnHideLog);
begin
  TFrm_Log.Instance.FOnHide := AOnHide;
  TFrm_Log.Instance.Show;
end;

class procedure TFrm_Log.ShowLog;
begin
  ShowLog(nil);
end;

initialization
  TFrm_Log.Create(Application);

end.
