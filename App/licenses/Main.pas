unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, lic, Data.DB, MemDS,
  DBAccess, Uni, UniProvider, SQLiteUniProvider, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator, dxDateRanges,
  cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxSplitter, cxGroupBox, Vcl.Menus,
  cxButtons, cxTextEdit, addlic, strutils, clipbrd, cxCalendar, dxSkinsCore,
  dxScrollbarAnnotations, DAScript, UniScript, cxCheckBox, uniconhelper, jsonbuilder, IOUtils,
  cxMaskEdit, cxDropDownEdit, idhttp, IdSSLOpenSSL;

type
  TMainForm = class(TForm)
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    db: TUniConnection;
    SQLiteUniProvider1: TSQLiteUniProvider;
    Licenses: TUniTable;
    LicensesSrc: TUniDataSource;
    LicensesID: TLargeintField;
    LicensesDeviceID: TWideStringField;
    LicensesCompName: TWideStringField;
    LicensesTaxNum: TWideStringField;
    LicensesTradeReccord: TWideStringField;
    LicensesNotes: TWideStringField;
    LicensesComp: TWideStringField;
    LicensesCompMgr: TWideStringField;
    LicensesPhones: TWideStringField;
    LicensesAddress: TWideStringField;
    cxGroupBox2: TcxGroupBox;
    cxGroupBox1: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    Label1: TLabel;
    cxTextEdit1: TcxTextEdit;
    cxGrid1DBTableView1ID: TcxGridDBColumn;
    cxGrid1DBTableView1DeviceID: TcxGridDBColumn;
    cxGrid1DBTableView1CompName: TcxGridDBColumn;
    cxGrid1DBTableView1TaxNum: TcxGridDBColumn;
    cxGrid1DBTableView1TradeReccord: TcxGridDBColumn;
    cxGrid1DBTableView1Notes: TcxGridDBColumn;
    cxGrid1DBTableView1Comp: TcxGridDBColumn;
    cxGrid1DBTableView1CompMgr: TcxGridDBColumn;
    cxGrid1DBTableView1Phones: TcxGridDBColumn;
    cxGrid1DBTableView1Address: TcxGridDBColumn;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    LicensesLicDate: TDateField;
    LicensesLicEndDate: TDateField;
    cxGrid1DBTableView1LicDate: TcxGridDBColumn;
    cxGrid1DBTableView1LicEndDate: TcxGridDBColumn;
    UniScript1: TUniScript;
    LicensesHasPOS: TBooleanField;
    cxGrid1DBTableView1HasPOS: TcxGridDBColumn;
    LicensesNoQR: TBooleanField;
    cxGrid1DBTableView1NoQR: TcxGridDBColumn;
    LicensesActive: TBooleanField;
    cxButton1: TcxButton;
    N5: TMenuItem;
    cxGrid1DBTableView1Active: TcxGridDBColumn;
    Label2: TLabel;
    cxComboBox1: TcxComboBox;
    cxComboBox2: TcxComboBox;
    Label3: TLabel;
    LicensesLic: TWideStringField;
    N6: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure LicensesAfterInsert(DataSet: TDataSet);
    procedure cxGrid1DBTableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxTextEdit1PropertiesChange(Sender: TObject);
    procedure dbAfterConnect(Sender: TObject);
    procedure N5Click(Sender: TObject);
    function LocateCurrentID:LargeInt;
    procedure PopupMenu1Popup(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.cxButton1Click(Sender: TObject);
begin
  var ds:=db.SQLToDataSet('select DeviceID, Lic from Licenses where Active=1 and (LicEndDate is null or LicEndDate>:d)', [FormatDateTime('yyyy-MM-dd', now)]);
  var ss:=TStringStream.Create(buildJson.dataset(ds).json,TEncoding.UTF8);
  var SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  with TIdHTTP.Create(nil) do
  begin
    IOHandler := SSL;
    Request.ContentType := 'application/json';
    Request.CustomHeaders.Values['Bearer']:=
      'Bearer f8c7d6a3b04e49f6a112e3d0c79e1f96c5a7b2d1f3049a6b5c8e7d4f9a2c1d3e';
    Post('http://sallasync.arambs.com/mnrlic/u3636367yhdd654p.php', ss);
    Destroy;
  end;
  ssl.Destroy;
  ss.Destroy;
  ds.Destroy;
  MessageBox(handle, ' „ —›⁄ «· —«ŒÌ’ »‰Ã«Õ.', '—›⁄ «· —«ŒÌ’', mb_ok or mb_right or mb_rtlreading);
end;

procedure TMainForm.cxGrid1DBTableView1CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
n2.Click;
end;

procedure TMainForm.cxTextEdit1PropertiesChange(Sender: TObject);
var
AItemList: TcxFilterCriteriaItemList;
s:string;
begin
cxGrid1DBTableView1.DataController.Filter.BeginUpdate;
cxGrid1DBTableView1.DataController.Filter.Root.Clear;
cxGrid1DBTableView1.DataController.Filter.Root.BoolOperatorKind:=fboAnd;
if cxComboBox1.ItemIndex>0 then
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1Active, foEqual, cxComboBox1.ItemIndex=1,'');
if cxComboBox2.ItemIndex=1 then
begin
  var ldf:=cxGrid1DBTableView1.DataController.Filter.Root.AddItemList(fboOr);
  ldf.AddItem(cxGrid1DBTableView1LicEndDate, foInFuture, null,s);
  ldf.AddItem(cxGrid1DBTableView1LicEndDate, foEqual, null,s);
end;
if cxComboBox2.ItemIndex=2 then
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1LicEndDate, foInPast, null,s);
if Trim(cxTextEdit1.Text)<>'' then
begin
  s:='%'+ReplaceStr(Trim(cxTextEdit1.Text),' ', '%')+'%';
  var tf:=cxGrid1DBTableView1.DataController.Filter.Root.AddItemList(fboOr);
  tf.AddItem(cxGrid1DBTableView1DeviceID, foLike, s, s);
  tf.AddItem(cxGrid1DBTableView1CompName, foLike, s,s);
  tf.AddItem(cxGrid1DBTableView1TaxNum, foLike, s,s);
  tf.AddItem(cxGrid1DBTableView1TradeReccord, foLike, s,s);
  tf.AddItem(cxGrid1DBTableView1Notes, foLike, s,s);
  tf.AddItem(cxGrid1DBTableView1Comp, foLike, s,s);
  tf.AddItem(cxGrid1DBTableView1CompMgr, foLike, s,s);
  tf.AddItem(cxGrid1DBTableView1Notes, foLike, s,s);
  tf.AddItem(cxGrid1DBTableView1Phones, foLike, s,s);
  tf.AddItem(cxGrid1DBTableView1Address, foLike, s,s);
end;
cxGrid1DBTableView1.DataController.Filter.EndUpdate;
end;

procedure TMainForm.dbAfterConnect(Sender: TObject);
begin
if UniScript1.Tag=0 then Exit;
UniScript1.Execute;
ShowMessage(' „  ÕœÌÀ ﬁ«⁄œ… «·»Ì«‰« ° Ì—ÃÏ Õ–› „·› «· ÕœÌÀ.');
ExitProcess(0);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
s:string;
begin
s:=IncludeTrailingBackslash(ExtractFileDir(Application.ExeName));
cxGrid1DBTableView1.RestoreFromIniFile(s+'grid.ini');
db.Database:=s+'Data';
db.Open;
with db.SQLToDataSet('select * from Licenses where ID=1') do
begin
  var ff:boolean:=true;
  try FieldByName('Active') except ff:=False; end;
  if not ff then
  begin
    db.GetDBValue('ALTER TABLE Licenses ADD COLUMN Active INTEGER');
    db.GetDBValue('ALTER TABLE Licenses ADD COLUMN Lic TEXT');
    db.GetDBValue('ALTER TABLE Licenses ADD COLUMN NoQR INTEGER');
    with db.SQLToDataSet('select * from Licenses') do
    begin
      First;
      while not Eof do
      begin
        Edit;
        FieldByName('Active').Value:=1;
        FieldByName('NoQR').Value:=0;
        var s1:='noexp'; if not FieldByName('LicEndDate').IsNull then s1:=FormatDateTime('yyyy-MM-dd', FieldByName('LicEndDate').Value);
        var s2:='pos'; if FieldByName('HasPOS').Value<>1 then s2:='nopos';
        var s3:='noqr'; if FieldByName('NoQR').Value<>1 then s3:='qr';
        FieldByName('lic').Value:=GenLic(Trim(MainForm.LicensesDeviceID.Value),
        Trim(FieldByName('CompName').Value)+#13#10+
        Trim(FieldByName('TaxNum').Value)+#13#10+
        Trim(FieldByName('TradeReccord').Value)+#13#10+
        s1+#13#10+
        s2+#13#10+
        s3);
        Post;
        Next;
      end;
      Destroy;
    end;
  end;
  Destroy;
end;
Licenses.Open;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
cxGrid1DBTableView1.StoreToIniFile(IncludeTrailingBackslash(ExtractFileDir(Application.ExeName))+'grid.ini');
end;

procedure TMainForm.LicensesAfterInsert(DataSet: TDataSet);
begin
LicensesLicDate.Value:=Date;
LicensesHasPOS.Value:=False;
LicensesNoQR.Value:=False;
LicensesActive.Value:=True;
end;

function TMainForm.LocateCurrentID: LargeInt;
begin
if cxGrid1DBTableView1.Controller.SelectedRowCount=0 then Exit(0);
if not Licenses.Locate('ID', cxGrid1DBTableView1.Controller.SelectedRows[0].Values[cxGrid1DBTableView1ID.Index], []) then Exit(0);
Exit(LicensesID.Value);
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
Licenses.Append;
AddLicForm.ShowModal;
end;

procedure TMainForm.N2Click(Sender: TObject);
begin
if LocateCurrentID=0 then Exit;
Licenses.Edit;
AddLicForm.ShowModal;
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
if LocateCurrentID=0 then Exit;
if mrYes<>MessageBox(handle, 'Â·  —Ìœ »«· √ﬂÌœ Õ–› «· —ŒÌ’ «·„Õœœø','Õ–› «· —ŒÌ’',mb_yesno or mb_right or mb_rtlReading) then Exit;
Licenses.Delete;
end;

procedure TMainForm.N4Click(Sender: TObject);
var
s1, s2, s3:string;
begin
if LocateCurrentID=0 then Exit;
Clipboard.AsText:=Licenseslic.Value;
end;

procedure TMainForm.N5Click(Sender: TObject);
begin
if LocateCurrentID=0 then Exit;
Licenses.Edit;
LicensesActive.Value:=not LicensesActive.Value;
Licenses.Post;
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
if LocateCurrentID=0 then Exit;
var compname:=LicensesCompName.Value;
var tax:=LicensesTaxNum.Value;
var trade:=LicensesTradeReccord.Value;
var notes:=LicensesNotes.Value;
var comp:=LicensesComp.Value;
var compmgr:=LicensesCompMgr.Value;
var phones:=LicensesPhones.Value;
var address:=LicensesAddress.Value;
var enddate:=LicensesLicEndDate.AsVariant;
var haspos:=LicensesHasPOS.Value;
var noqr:=LicensesNoQR.Value;
Licenses.Append;
LicensesCompName.Value:=compname;
LicensesTaxNum.Value:=tax;
LicensesTradeReccord.Value:=trade;
LicensesNotes.Value:=notes;
LicensesComp.Value:=comp;
LicensesCompMgr.Value:=compmgr;
LicensesPhones.Value:=phones;
LicensesAddress.Value:=address;
LicensesLicEndDate.AsVariant:=enddate;
LicensesHasPOS.Value:=haspos;
LicensesNoQR.Value:=noqr;
AddLicForm.ShowModal;
end;

procedure TMainForm.PopupMenu1Popup(Sender: TObject);
begin
if LocateCurrentID=0 then
begin
  n5.Caption:=' ⁄ÿÌ·';
  n5.Enabled:=False;
end
else
begin
  if LicensesActive.Value then n5.Caption:=' ⁄ÿÌ·' else n5.Caption:=' „ﬂÌ‰';
  n5.Enabled:=True;
end;
end;

end.
