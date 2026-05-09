unit addlic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxGroupBox, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxMemo, cxDBEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, db, dxSkinsCore, cxCheckBox, lic;

type
  TAddLicForm = class(TForm)
    cxGroupBox1: TcxGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cxDBTextEdit1: TcxDBTextEdit;
    cxDBTextEdit2: TcxDBTextEdit;
    cxDBTextEdit3: TcxDBTextEdit;
    cxDBMemo1: TcxDBMemo;
    cxDBMemo2: TcxDBMemo;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    cxDBTextEdit4: TcxDBTextEdit;
    cxDBTextEdit5: TcxDBTextEdit;
    cxDBTextEdit6: TcxDBTextEdit;
    Label10: TLabel;
    cxDBDateEdit1: TcxDBDateEdit;
    Label11: TLabel;
    cxDBTextEdit7: TcxDBTextEdit;
    cxDBDateEdit2: TcxDBDateEdit;
    Label12: TLabel;
    Label13: TLabel;
    cxCheckBox1: TcxDBCheckBox;
    cxDBCheckBox1: TcxDBCheckBox;
    cxDBCheckBox2: TcxDBCheckBox;
    procedure cxButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxDBTextEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cxDBTextEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure cxButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddLicForm: TAddLicForm;

implementation
uses Main;

{$R *.dfm}

procedure TAddLicForm.cxButton1Click(Sender: TObject);
var s1,s2,s3:string;
begin
if MainForm.LicensesCompName.Value.Trim.IsEmpty or
MainForm.LicensesDeviceID.Value.Trim.IsEmpty or
MainForm.LicensesCompName.Value.Trim.IsEmpty or
MainForm.LicensesCompName.Value.Trim.IsEmpty or
MainForm.LicensesCompName.Value.Trim.IsEmpty or MainForm.LicensesLicDate.IsNull then
begin
  MessageBox(handle, 'Ì—ÃÏ  ÕœÌœ „⁄·Ê„«  «· —ŒÌ’ Ê«”„ «·‘—ﬂ….','Õ›Ÿ «· —ŒÌ’',mb_ok or mb_right or mb_rtlReading);
  Exit;
end;

if MainForm.LicensesLicEndDate.IsNull then s1:='noexp' else s1:=FormatDateTime('yyyy-MM-dd', MainForm.LicensesLicEndDate.Value);
if MainForm.LicensesHasPOS.Value then s2:='pos' else s2:='nopos';
if MainForm.LicensesNoQR.Value then s3:='noqr' else s3:='qr';
MainForm.Licenseslic.Value:=GenLic(MainForm.LicensesDeviceID.Value.Trim,
MainForm.LicensesCompName.Value.Trim+#13#10+
MainForm.LicensesTaxNum.Value.Trim+#13#10+
MainForm.LicensesTradeReccord.Value.Trim+#13#10+
s1+#13#10+
s2+#13#10+
s3);

MainForm.Licenses.Post;
Close;
end;


procedure TAddLicForm.cxButton2Click(Sender: TObject);
begin
Close;
end;

procedure TAddLicForm.cxDBTextEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Key=13)and(not (ssCtrl in Shift)) then
  PostMessage(handle, WM_NEXTDLGCTL, integer(ssshift in Shift) ,0);
end;

procedure TAddLicForm.cxDBTextEdit1KeyPress(Sender: TObject; var Key: Char);
begin
if key=#13 then Key:=#0;
end;

procedure TAddLicForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if MainForm.Licenses.State in [dsEdit, dsInsert] then MainForm.Licenses.Cancel;

end;

procedure TAddLicForm.FormShow(Sender: TObject);
begin
ActiveControl:=cxDBTextEdit1;
if MainForm.LicensesID.Value=0 then
Caption:='≈÷«›…  —ŒÌ’ ÃœÌœ' else Caption:=' ⁄œÌ· «· —ŒÌ’';
end;

end.
