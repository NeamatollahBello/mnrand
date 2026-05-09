unit SelectServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, cxTextEdit,
  Vcl.StdCtrls, cxButtons, cxMaskEdit, cxDropDownEdit, cxGroupBox, Data.DB,
  DBAccess, Uni, uniconhelper, dxSkinsCore;

type
  TSelectServerForm = class(TForm)
    cxGroupBox1: TcxGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cxComboBox1: TcxComboBox;
    Label4: TLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxTextEdit1: TcxTextEdit;
    cxTextEdit2: TcxTextEdit;
    cxTextEdit3: TcxTextEdit;
    con: TUniConnection;
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxComboBox1PropertiesInitPopup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectServerForm: TSelectServerForm;

implementation
uses DataU;
{$R *.dfm}

procedure TSelectServerForm.cxButton1Click(Sender: TObject);
begin
con.Server:=cxTextEdit1.Text;
con.Username:=cxTextEdit2.Text;
con.Password:=cxTextEdit3.Text;
con.Database:=cxComboBox1.Text;
try
  con.Open;
except
end;
if con.Connected then
begin
  if EData.db.Connected and EData.mnr.Connected then
    if mrYes<>MessageBox(handle, 'Â·  —Ìœ ›’· «·« ’«· «·Õ«·Ì Ê«·« ’«· »ﬁ«⁄œ… «·»Ì«‰«  «·„Õœœ…ø', 'ﬁ«⁄œ… «·»Ì«‰« ',mb_yesno or mb_rtlreading or mb_right) then
      Exit;
  EData.Connect(cxTextEdit1.Text,cxTextEdit2.Text,cxTextEdit3.Text,cxComboBox1.Text);
  Close;
end
else
  MessageBox(handle, '·« Ì„ﬂ‰ «·« ’«· »ﬁ«⁄œ… «·»Ì«‰«  «·„Õœœ…° Ì—ÃÏ «· √ﬂœ „‰ ≈⁄œ«œ«  «·« ’«·. ', 'ﬁ«⁄œ… «·»Ì«‰« ',mb_ok or mb_rtlreading or mb_right);
end;

procedure TSelectServerForm.cxButton2Click(Sender: TObject);
begin
  if EData.db.Connected and EData.mnr.Connected then else ExitProcess(0);
  Close;
end;

procedure TSelectServerForm.cxComboBox1PropertiesInitPopup(Sender: TObject);
begin
cxComboBox1.Properties.Items.Clear;
con.Server:=cxTextEdit1.Text;
con.Username:=cxTextEdit2.Text;
con.Password:=cxTextEdit3.Text;
con.Database:='master';
with con.SQLToDataSet('select * from sys.databases') do
begin
  First;
  while not Eof do
  begin
    cxComboBox1.Properties.Items.Add(Fields[0].AsWideString);
    Next;
  end;
end;
end;

procedure TSelectServerForm.FormShow(Sender: TObject);
begin
ActiveControl:=cxTextEdit1;
end;

end.
