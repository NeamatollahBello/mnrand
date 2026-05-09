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
  cxButtons, cxTextEdit, addlic, strutils, clipbrd, cxCalendar;

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
  private
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

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
if Trim(cxTextEdit1.Text)<>'' then
begin
  s:='%'+ReplaceStr(Trim(cxTextEdit1.Text),' ', '%')+'%';
  cxGrid1DBTableView1.DataController.Filter.Root.BoolOperatorKind:=fboOr;
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1DeviceID, foLike, s, s);
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1CompName, foLike, s,s);
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1TaxNum, foLike, s,s);
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1TradeReccord, foLike, s,s);
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1Notes, foLike, s,s);
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1Comp, foLike, s,s);
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1CompMgr, foLike, s,s);
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1Notes, foLike, s,s);
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1Phones, foLike, s,s);
  cxGrid1DBTableView1.DataController.Filter.Root.AddItem(cxGrid1DBTableView1Address, foLike, s,s);
end;
cxGrid1DBTableView1.DataController.Filter.EndUpdate;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
s:string;
begin
s:=IncludeTrailingBackslash(ExtractFileDir(Application.ExeName));
cxGrid1DBTableView1.RestoreFromIniFile(s+'grid.ini');
db.Database:=s+'Data';
db.Open;
Licenses.Open;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
cxGrid1DBTableView1.StoreToIniFile(IncludeTrailingBackslash(ExtractFileDir(Application.ExeName))+'grid.ini');
end;

procedure TMainForm.LicensesAfterInsert(DataSet: TDataSet);
begin
LicensesLicDate.Value:=Date;
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
Licenses.Append;
AddLicForm.ShowModal;
end;

procedure TMainForm.N2Click(Sender: TObject);
begin
if LicensesID.Value=0 then Exit;
Licenses.Edit;
AddLicForm.ShowModal;
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
if LicensesID.Value=0 then Exit;
if mrYes<>MessageBox(handle, 'Â·  —Ìœ »«· √ﬂÌœ Õ–› «· —ŒÌ’ «·„Õœœø','Õ–› «· —ŒÌ’',mb_yesno or mb_right or mb_rtlReading) then Exit;
Licenses.Delete;
end;

procedure TMainForm.N4Click(Sender: TObject);
var
s:string;
i:integer;
begin
if LicensesID.Value=0 then Exit;
if LicensesLicEndDate.IsNull then s:='noexp' else s:=FormatDateTime('yyyy-MM-dd', LicensesLicEndDate.Value);
Clipboard.AsText:=GenLic(LicensesDeviceID.Value.Trim, LicensesCompName.Value.Trim+#13#10+LicensesTaxNum.Value.Trim+#13#10+LicensesTradeReccord.Value.Trim+#13#10+s);
end;

end.
