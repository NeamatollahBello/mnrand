unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataU, Vcl.StdCtrls, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxGroupBox, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxNavigator, dxDateRanges, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxTextEdit, DBAccess, Uni, MemDS, cxDBLookupComboBox, cxDBEdit,
  cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, uniconhelper,
  cxImage, Vcl.ExtDlgs, cxMemo, clipbrd, lic, jsonbuilder, shellapi, winsvc,
  Vcl.Menus, Vcl.ExtCtrls, cxButtons, cxCheckBox, dxSkinsCore,
  dxScrollbarAnnotations, cxSpinEdit, dxBarBuiltInMenu, cxPC, dxBevel;

type
  TMainForm = class(TForm)
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    Clients: TUniQuery;
    ClientsID: TGuidField;
    ClientsUserID: TGuidField;
    ClientsClientID: TGuidField;
    ClientsSrc: TUniDataSource;
    Materials: TUniQuery;
    MaterialsID: TGuidField;
    MaterialsUserID: TGuidField;
    MaterialsMatID: TGuidField;
    MaterialsSrc: TUniDataSource;
    Groups: TUniQuery;
    GroupsID: TGuidField;
    GroupsUserID: TGuidField;
    GroupsGroupID: TGuidField;
    GroupsSrc: TUniDataSource;
    PayTypes: TUniQuery;
    PayTypesID: TGuidField;
    PayTypesName: TWideStringField;
    PayTypesAccount: TGuidField;
    PayTypesUserID: TGuidField;
    PayTypesSrc: TUniDataSource;
    OpenPictureDialog1: TOpenPictureDialog;
    PopupMenu2: TPopupMenu;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    Timer1: TTimer;
    Accounts: TUniQuery;
    AccountsID: TGuidField;
    AccountsUserID: TGuidField;
    AccountsAccountID: TGuidField;
    AccountsSrc: TUniDataSource;
    cxTabSheet2: TcxTabSheet;
    cxTabSheet3: TcxTabSheet;
    cxGroupBox3: TcxGroupBox;
    Button1: TButton;
    Button5: TButton;
    cxButton2: TcxButton;
    cxGroupBox4: TcxGroupBox;
    Label10: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    cxDBLookupComboBox4: TcxDBLookupComboBox;
    cxDBLookupComboBox9: TcxDBLookupComboBox;
    cxDBLookupComboBox2: TcxDBLookupComboBox;
    cxDBLookupComboBox3: TcxDBLookupComboBox;
    cxDBLookupComboBox5: TcxDBLookupComboBox;
    cxDBLookupComboBox11: TcxDBLookupComboBox;
    cxDBLookupComboBox6: TcxDBLookupComboBox;
    cxDBLookupComboBox7: TcxDBLookupComboBox;
    Label11: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    cxDBLookupComboBox1: TcxDBLookupComboBox;
    cxDBLookupComboBox12: TcxDBLookupComboBox;
    cxDBLookupComboBox10: TcxDBLookupComboBox;
    cxDBImage1: TcxDBImage;
    cxDBMemo1: TcxDBMemo;
    Button3: TButton;
    cxMemo1: TcxMemo;
    Button4: TButton;
    cxDBLookupComboBox8: TcxDBLookupComboBox;
    cxDBSpinEdit1: TcxDBSpinEdit;
    dxBevel1: TdxBevel;
    Label2: TLabel;
    Label3: TLabel;
    dxBevel2: TdxBevel;
    Label22: TLabel;
    dxBevel3: TdxBevel;
    Label23: TLabel;
    dxBevel4: TdxBevel;
    Label24: TLabel;
    dxBevel5: TdxBevel;
    cxDBMemo2: TcxDBMemo;
    Label25: TLabel;
    dxBevel6: TdxBevel;
    Button2: TButton;
    Button6: TButton;
    cxGroupBox1: TcxGroupBox;
    cxPageControl2: TcxPageControl;
    cxTabSheet4: TcxTabSheet;
    cxTabSheet5: TcxTabSheet;
    cxGrid4: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    cxGridDBColumn3: TcxGridDBColumn;
    cxGridDBColumn4: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridDBColumn1: TcxGridDBColumn;
    cxGridDBColumn2: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxTabSheet6: TcxTabSheet;
    cxGrid5: TcxGrid;
    cxGridDBTableView4: TcxGridDBTableView;
    cxGridDBTableView4ID: TcxGridDBColumn;
    cxGridDBTableView4Name: TcxGridDBColumn;
    cxGridDBTableView4Account: TcxGridDBColumn;
    cxGridDBTableView4UserID: TcxGridDBColumn;
    cxGridLevel4: TcxGridLevel;
    cxGrid3: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridDBTableView1UserID: TcxGridDBColumn;
    cxGridDBTableView1ClientID: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxGrid6: TcxGrid;
    cxGridDBTableView5: TcxGridDBTableView;
    cxGridDBColumn5: TcxGridDBColumn;
    cxGridDBColumn6: TcxGridDBColumn;
    cxGridLevel5: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1DBTableView1ID: TcxGridDBColumn;
    cxGrid1DBTableView1Name: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
    cxButton1: TcxButton;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
    cxButton6: TcxButton;
    cxButton3: TcxButton;
    cxButton7: TcxButton;
    cxButton8: TcxButton;
    cxButton9: TcxButton;
    cxButton10: TcxButton;
    cxButton11: TcxButton;
    cxButton12: TcxButton;
    cxButton13: TcxButton;
    cxButton14: TcxButton;
    cxButton15: TcxButton;
    Label26: TLabel;
    cxDBTextEdit1: TcxDBTextEdit;
    Label27: TLabel;
    cxDBTextEdit2: TcxDBTextEdit;
    cxComboBox1: TcxDBComboBox;
    Label28: TLabel;
    cxDBLookupComboBox13: TcxDBLookupComboBox;
    Label29: TLabel;
    Label30: TLabel;
    cxDBLookupComboBox14: TcxDBLookupComboBox;
    Label31: TLabel;
    cxDBLookupComboBox15: TcxDBLookupComboBox;
    Label32: TLabel;
    cxDBLookupComboBox16: TcxDBLookupComboBox;
    cxDBCheckBox1: TcxDBCheckBox;
    cxDBCheckBox2: TcxDBCheckBox;
    cxDBCheckBox3: TcxDBCheckBox;
    cxDBCheckBox4: TcxDBCheckBox;
    cxDBCheckBox5: TcxDBCheckBox;
    cxDBCheckBox6: TcxDBCheckBox;
    cxDBCheckBox7: TcxDBCheckBox;
    cxDBCheckBox8: TcxDBCheckBox;
    cxDBCheckBox9: TcxDBCheckBox;
    cxDBCheckBox10: TcxDBCheckBox;
    cxDBCheckBox11: TcxDBCheckBox;
    cxDBCheckBox12: TcxDBCheckBox;
    cxDBCheckBox13: TcxDBCheckBox;
    Label33: TLabel;
    cxComboBox2: TcxDBComboBox;
    Label34: TLabel;
    cxComboBox3: TcxDBComboBox;
    cxDBCheckBox14: TcxDBCheckBox;
    cxDBCheckBox15: TcxDBCheckBox;
    cxDBCheckBox16: TcxDBCheckBox;
    Label15: TLabel;
    cxDBCheckBox17: TcxDBCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure ClientsAfterInsert(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure ClientsBeforePost(DataSet: TDataSet);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxGrid3Enter(Sender: TObject);
    procedure cxGrid2Enter(Sender: TObject);
    procedure MaterialsAfterInsert(DataSet: TDataSet);
    procedure MaterialsBeforePost(DataSet: TDataSet);
    procedure cxGrid4Enter(Sender: TObject);
    procedure GroupsAfterInsert(DataSet: TDataSet);
    procedure GroupsBeforePost(DataSet: TDataSet);
    procedure PayTypesAfterInsert(DataSet: TDataSet);
    procedure PayTypesBeforePost(DataSet: TDataSet);
    procedure cxGrid5Enter(Sender: TObject);
    procedure cxGrid1Enter(Sender: TObject);
    procedure cxDBImage1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure cxButton2DropDownMenuPopup(Sender: TObject;
      var APopupMenu: TPopupMenu; var AHandled: Boolean);
    procedure AccountsAfterInsert(DataSet: TDataSet);
    procedure AccountsBeforePost(DataSet: TDataSet);
    procedure cxGrid6Enter(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure cxPageControl1PageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure cxButton6Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton7Click(Sender: TObject);
    procedure cxButton9Click(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);
    procedure cxButton11Click(Sender: TObject);
    procedure cxButton10Click(Sender: TObject);
    procedure cxButton13Click(Sender: TObject);
    procedure cxButton12Click(Sender: TObject);
    procedure cxButton15Click(Sender: TObject);
    procedure cxButton14Click(Sender: TObject);
    procedure cxPageControl2PageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
  private
    sm:SC_HANDLE;
    DeviceID:string;
    procedure UpdateUserData;
    procedure UpdateLicStatus;
    procedure ExecWait(FileName, CommandLine, Directory: string; Hide:boolean=True);
    procedure StartService;
    procedure StopService;
    procedure PostUnsavedLists;
    { Private declarations }
  public
    { Public declarations }
  function GetServiceState:integer;
  procedure ToggleUserEdit;
  end;

var
  MainForm: TMainForm;

implementation
uses SelectServer;
{$R *.dfm}

procedure TMainForm.AccountsAfterInsert(DataSet: TDataSet);
begin
if EData.UsersID.IsNull then Accounts.Cancel else
AccountsUserID.Value:=EData.UsersID.Value;
cxGrid6.SetFocus;
end;

procedure TMainForm.AccountsBeforePost(DataSet: TDataSet);
begin
if AccountsAccountID.IsNull then Accounts.Cancel
else AccountsID.Value:=CreateNewGuid;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if MainForm.GetServiceState in [0, SERVICE_STOPPED] then else
  begin
    MessageBox(MainForm.Handle, 'Ì—ÃÏ ≈Ìﬁ«› «·Œœ„… Õ Ï   „ﬂ‰ „‰  €ÌÌ— «·≈⁄œ«œ« .','«·≈⁄œ«œ« ',mb_ok or mb_right or mb_rtlreading);
    Exit;
  end;
  SelectServerForm.cxTextEdit1.Text:=EData.db.Server;
  SelectServerForm.cxTextEdit2.Text:=EData.db.Username;
  SelectServerForm.cxTextEdit3.Text:=EData.db.Password;
  SelectServerForm.cxComboBox1.Text:=EData.mnr.Database;
  SelectServerForm.ShowModal;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  if Edata.settings.State in [dsEdit, dsInsert] then EData.settings.Post;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
if EData.settings.State in [dsEdit,dsInsert] then else Edata.settings.Edit;
Edata.settingsLic.Value:=Clipboard.AsText;
Edata.settings.Post;
UpdateLicStatus;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
Clipboard.asText:=cxMemo1.Text;
end;

procedure TMainForm.ExecWait(FileName, CommandLine, Directory: string; Hide:boolean=True);
var
sei:SHELLEXECUTEINFO;
begin
  ZeroMemory(@sei, sizeof(sei));
  sei.cbSize:=sizeof(sei);
  sei.Wnd:=handle;
  sei.lpVerb:='runas';
  sei.lpFile:=PChar(FileName);
  sei.lpParameters:=PChar(CommandLine);
  sei.lpDirectory:=PChar(Directory);
  if Hide then sei.nShow:=SW_HIDE else sei.nShow:=SW_SHOWNORMAL;
  sei.fMask:=SEE_MASK_NOCLOSEPROCESS;
  ShellExecuteEx(@sei);
  while WaitForSingleObject(sei.hProcess, 100)=WAIT_TIMEOUT do Application.ProcessMessages;
  CloseHandle(sei.hProcess);
end;

procedure TMainForm.Button5Click(Sender: TObject);
const
  netsh_fw_command2='advfirewall firewall delete rule name=mnrandport';
  netsh_fw_command3='advfirewall firewall add rule name=mnrandport dir=in action=allow protocol=TCP enable=yes localport=8030';
begin
  ExecWait('netsh', netsh_fw_command2, '');
  ExecWait('netsh', netsh_fw_command3, '');
  MessageBox(handle,' „ ÷»ÿ ≈⁄œ«œ«  Ãœ«— «·Õ„«Ì….','Ãœ«— «·Õ„«Ì…', mb_ok or mb_right or mb_rtlreading);
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  if Edata.settings.State in [dsEdit, dsInsert] then EData.settings.Cancel;
end;

procedure TMainForm.ClientsAfterInsert(DataSet: TDataSet);
begin
if EData.UsersID.Value='' then Clients.Cancel else
ClientsUserID.Value:=EData.UsersID.Value;
cxGrid3.SetFocus;
end;

procedure TMainForm.ClientsBeforePost(DataSet: TDataSet);
begin
if (ClientsUserID.Value='')or(ClientsClientID.Value='') then Clients.Cancel
else ClientsID.Value:=CreateNewGuid;
end;

procedure TMainForm.cxButton10Click(Sender: TObject);
begin
  PayTypes.Delete;
end;

procedure TMainForm.cxButton11Click(Sender: TObject);
begin
if EData.Users.State=dsInsert then
begin
  MessageBox(handle, 'Ì—ÃÏ Õ›Ÿ «·„” Œœ„ √Ê·«.', '«·„” Œœ„Ì‰', mb_ok or mb_right or mb_rtlreading);
  Exit;
end;
PayTypes.Append;
end;

procedure TMainForm.cxButton12Click(Sender: TObject);
begin
Groups.Delete;
end;

procedure TMainForm.cxButton13Click(Sender: TObject);
begin
if EData.Users.State=dsInsert then
begin
  MessageBox(handle, 'Ì—ÃÏ Õ›Ÿ «·„” Œœ„ √Ê·«.', '«·„” Œœ„Ì‰', mb_ok or mb_right or mb_rtlreading);
  Exit;
end;
Groups.Append;
end;

procedure TMainForm.cxButton14Click(Sender: TObject);
begin
Materials.Delete;
end;

procedure TMainForm.cxButton15Click(Sender: TObject);
begin
if EData.Users.State=dsInsert then
begin
  MessageBox(handle, 'Ì—ÃÏ Õ›Ÿ «·„” Œœ„ √Ê·«.', '«·„” Œœ„Ì‰', mb_ok or mb_right or mb_rtlreading);
  Exit;
end;
Materials.Append;
end;

procedure TMainForm.cxButton1Click(Sender: TObject);
begin
  EData.Users.Append;
end;

procedure TMainForm.cxButton2DropDownMenuPopup(Sender: TObject;
  var APopupMenu: TPopupMenu; var AHandled: Boolean);
var
st:integer;
begin
st:=GetServiceState;
n10.Visible:=st=SERVICE_STOPPED;
n11.Visible:=(st=SERVICE_RUNNING)or(st=SERVICE_PAUSED);
n12.Visible:=st=SERVICE_STOPPED;
n13.Visible:=st=0;

end;

procedure TMainForm.cxButton3Click(Sender: TObject);
begin
if EData.Users.State=dsInsert then
begin
  MessageBox(handle, 'Ì—ÃÏ Õ›Ÿ «·„” Œœ„ √Ê·«.', '«·„” Œœ„Ì‰', mb_ok or mb_right or mb_rtlreading);
  Exit;
end;
Clients.Append;
end;

procedure TMainForm.cxButton4Click(Sender: TObject);
begin
  if EData.UsersID.Value='' then Exit;
//  if EData.db.GetDBValue('select count(*) from OpLog where [UserID]=:user', [EData.UsersID.Value])[0]>0 then
//  begin
//    MessageBox(handle, '·« Ì„ﬂ‰ Õ–› «·„” Œœ„ «·„Õœœ »”»» ÊÃÊœ ⁄„·Ì«  „— »ÿ… »Â', '«·„” Œœ„Ì‰', mb_yesno or mb_right or mb_rtlreading);
//    Exit;
//  end;
  if mrYes<>MessageBox(handle, PChar('Â·  —Ìœ »«· √ﬂÌœ Õ–› «·„” Œœ„: '+EData.UsersName.Value+'ø'), '«·„” Œœ„Ì‰', mb_yesno or mb_right or mb_rtlreading) then Exit;
  EData.Users.Delete;
end;

procedure TMainForm.cxButton5Click(Sender: TObject);
begin
  if EData.UsersName.Value.Trim.IsEmpty or EData.UsersPassword.Value.IsEmpty or
  EData.UsersPriceField.Value.IsEmpty or EData.UsersmnrUser.IsNull or
  EData.UsersStore.IsNull then
  begin
    MessageBox(handle, 'Ì—ÃÏ ÷»ÿ «·«”„ Êﬂ·„… «·„—Ê— Ê„” Œœ„ «·„‰«—… ÊÕﬁ· «·”⁄— Ê«·„” Êœ⁄.', '«·„” Œœ„Ì‰', mb_ok or mb_right or mb_rtlreading);
    Exit;
  end;
  EData.Users.Post;
end;

procedure TMainForm.cxButton6Click(Sender: TObject);
begin
EData.Users.Cancel;
end;

procedure TMainForm.cxButton7Click(Sender: TObject);
begin
  Clients.Delete;
end;

procedure TMainForm.cxButton8Click(Sender: TObject);
begin
Accounts.Delete;
end;

procedure TMainForm.cxButton9Click(Sender: TObject);
begin
if EData.Users.State=dsInsert then
begin
  MessageBox(handle, 'Ì—ÃÏ Õ›Ÿ «·„” Œœ„ √Ê·«.', '«·„” Œœ„Ì‰', mb_ok or mb_right or mb_rtlreading);
  Exit;
end;
Accounts.Append;
end;

procedure TMainForm.cxDBImage1Click(Sender: TObject);
var
bs:TStream;
fs:TFileStream;
begin
  if not OpenPictureDialog1.Execute then Exit;
  EData.settings.Edit;
  fs:=TFileStream.Create(OpenPictureDialog1.FileName, fmOpenRead or fmShareDenyNone);
  bs:=EData.settings.CreateBlobStream(EData.settingsCompLogo, bmwrite);
  bs.CopyFrom(fs);
  bs.Destroy;
  fs.Destroy;
  Edata.settings.Post;
end;

procedure TMainForm.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  UpdateUserData;
end;

procedure TMainForm.cxGrid1Enter(Sender: TObject);
begin
if EData.Users.RecordCount=0 then EData.Users.Append;
end;

procedure TMainForm.cxGrid2Enter(Sender: TObject);
begin
if Materials.Active then
if Materials.RecordCount=0 then
if not EData.UsersID.isnull then
   Materials.Append;
end;

procedure TMainForm.cxGrid3Enter(Sender: TObject);
begin
if Clients.Active then
if Clients.RecordCount=0 then
if EData.UsersID.Value<>'' then
  Clients.Append;
end;

procedure TMainForm.cxGrid4Enter(Sender: TObject);
begin
if Groups.Active then
if Groups.RecordCount=0 then
if not EData.UsersID.isnull then
   Groups.Append;
end;

procedure TMainForm.cxGrid5Enter(Sender: TObject);
begin
if PayTypes.Active then
if PayTypes.RecordCount=0 then
if not EData.UsersID.IsNull then
  PayTypes.Append;
end;

procedure TMainForm.cxGrid6Enter(Sender: TObject);
begin
if Accounts.Active then
if Accounts.RecordCount=0 then
if not EData.UsersID.isnull then
  Accounts.Append;
end;

procedure TMainForm.cxPageControl1PageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  AllowChange:=not ((cxPageControl1.ActivePage=cxTabSheet1) and Button2.Visible);
  if not AllowChange then MessageBox(handle,'Ì—ÃÏ Õ›Ÿ «· ⁄œÌ·«  √Ê ≈·€«¡Â« «·Œ—ÊÃ „‰ «·’›Õ….','«·≈⁄œ«œ« ', mb_ok or mb_right or mb_rtlreading);
end;

procedure TMainForm.cxPageControl2PageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  if (cxPageControl2.ActivePage=cxTabSheet5)or(cxPageControl2.ActivePage=cxTabSheet6) then PostUnsavedLists;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if Button2.Visible or cxButton5.Enabled then
begin
  MessageBox(handle,'Ì—ÃÏ Õ›Ÿ «· ⁄œÌ·«  √Ê ≈·€«¡Â« «·Œ—ÊÃ „‰ «·’›Õ….','«·≈⁄œ«œ« ', mb_ok or mb_right or mb_rtlreading);
  Action:=TCloseAction.caNone;
  Exit;
end;
PostUnsavedLists;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  cxMemo1.Text:=GetDeviceID;
  sm:=OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  Timer1Timer(Timer1);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  CloseServiceHandle(sm);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
UpdateUserData;
UpdateLicStatus;
ToggleUserEdit;
end;

procedure TMainForm.GroupsAfterInsert(DataSet: TDataSet);
begin
if EData.UsersID.isnull then Groups.Cancel else
GroupsUserID.Value:=EData.UsersID.Value;
cxGrid4.SetFocus;
end;

procedure TMainForm.GroupsBeforePost(DataSet: TDataSet);
begin
if GroupsGroupID.IsNull then Groups.Cancel
else GroupsID.Value:=CreateNewGuid;
end;

procedure TMainForm.MaterialsAfterInsert(DataSet: TDataSet);
begin
if EData.UsersID.isnull then Materials.Cancel else
MaterialsUserID.Value:=EData.UsersID.Value;
cxGrid2.SetFocus;
end;

procedure TMainForm.MaterialsBeforePost(DataSet: TDataSet);
begin
if (MaterialsUserID.IsNull)or(MaterialsMatID.IsNull) then Materials.Cancel
else MaterialsID.Value:=CreateNewGuid;
end;

procedure TMainForm.StartService;
var
svc:SC_HANDLE;
p:pwidechar;
begin
  svc:=OpenService(sm, 'MnrAndService', SERVICE_ALL_ACCESS);
  p:=nil;
  winsvc.StartService(svc,0,p);
  CloseServiceHandle(svc);
end;

procedure TMainForm.StopService;
var
svc:SC_HANDLE;
ss:SERVICE_STATUS;
begin
  svc:=OpenService(sm, 'MnrAndService', SERVICE_ALL_ACCESS);
  winsvc.ControlService(svc,SERVICE_CONTROL_STOP,ss);
  CloseServiceHandle(svc);
end;


procedure TMainForm.N10Click(Sender: TObject);
begin
StartService;
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
StopService;
end;


procedure TMainForm.N12Click(Sender: TObject);
begin
ExecWait(IncludeTrailingBackslash(ExtractFilePath(GetModuleName(HInstance)))+'MnrAndSVC.exe',
'"'+IncludeTrailingBackslash(ExtractFilePath(GetModuleName(HInstance)))+'MnrAndSvc.exe" /uninstall /silent',
'');
end;

procedure TMainForm.N13Click(Sender: TObject);
begin
ExecWait(IncludeTrailingBackslash(ExtractFilePath(GetModuleName(HInstance)))+'MnrAndSVC.exe',
'"'+IncludeTrailingBackslash(ExtractFilePath(GetModuleName(HInstance)))+'MnrAndSvc.exe" /install /silent',
'');
end;

procedure TMainForm.PayTypesAfterInsert(DataSet: TDataSet);
begin
if EData.UsersID.isnull then PayTypes.Cancel else
PayTypesUserID.Value:=EData.UsersID.Value;
cxGrid5.SetFocus;
cxGridDBTableView4Name.FocusWithSelection;
end;

procedure TMainForm.PayTypesBeforePost(DataSet: TDataSet);
begin
if PayTypesUserID.isnull or (PayTypesAccount.IsNull) or
(PayTypesName.Value.Trim.IsEmpty) then
  PayTypes.Cancel
else PayTypesID.Value:=CreateNewGuid;
end;

procedure TMainForm.PostUnsavedLists;
begin
if Clients.State in [dsInsert, dsEdit] then Clients.Post;
if Accounts.State in [dsInsert, dsEdit] then Accounts.Post;
if Materials.State in [dsInsert, dsEdit] then Materials.Post;
if Groups.State in [dsInsert, dsEdit] then Groups.Post;
if PayTypes.State in [dsInsert, dsEdit] then PayTypes.Post;
end;

function TMainForm.GetServiceState:integer;
//return -1 if could not get Service State
//Return 0 if service is not installed
//Return
var
svc:SC_HANDLE;
ss:SERVICE_STATUS;
begin
  svc:=OpenService(sm, 'MnrAndService', SERVICE_ALL_ACCESS);
  if (svc=ERROR_ACCESS_DENIED)or(svc=ERROR_INVALID_HANDLE)or
     (svc=ERROR_INVALID_NAME) then
  begin
    CloseServiceHandle(svc);
    Result:=-1;
    Exit;
  end;

  if svc=ERROR_SERVICE_DOES_NOT_EXIST then
  begin
    CloseServiceHandle(svc);
    Result:=0;
    Exit;
  end;

  FillMemory(@ss, sizeof(ss), 0);
  QueryServiceStatus(svc, ss);

  if ss.dwCurrentState=0 then
  begin
    CloseServiceHandle(svc);
    Result:=0;
    Exit;
  end;



  Result:=ss.dwCurrentState;
  CloseServiceHandle(svc);
end;


procedure TMainForm.Timer1Timer(Sender: TObject);
var
st:integer;
begin
Timer1.Enabled:=False;
st:=GetServiceState;
if st=-1 then cxButton2.Caption:='Œÿ√ ›Ì Õ«·… «·Œœ„…' else
if st=0 then cxButton2.Caption:='«·Œœ„… €Ì— „À» …' else
if st=SERVICE_STOPPED then cxButton2.Caption:='«·Œœ„… „ Êﬁ›…' else
if st=SERVICE_START_PENDING then cxButton2.Caption:='«·Œœ„… »«‰ Ÿ«— «· ‘€Ì·' else
if st=SERVICE_STOP_PENDING then cxButton2.Caption:='«·Œœ„… »«‰ Ÿ«— «·≈Ìﬁ«›' else
if st=SERVICE_RUNNING then cxButton2.Caption:='«·Œœ„… ﬁÌœ «· ‘€Ì·' else
if st=SERVICE_CONTINUE_PENDING then cxButton2.Caption:='«·Œœ„… »«‰ Ÿ«— «· ‘€Ì·' else
if st=SERVICE_PAUSE_PENDING then cxButton2.Caption:='«·Œœ„… »«‰ Ÿ«— «·≈Ìﬁ«›' else
if st=SERVICE_PAUSED then cxButton2.Caption:='«·Œœ„… „ Êﬁ›… „ƒﬁ «';
Timer1.Enabled:=True
end;

procedure TMainForm.ToggleUserEdit;
begin
cxButton5.Enabled:=EData.Users.State in [dsEdit, dsInsert];
cxButton6.Enabled:=cxButton5.Enabled;
cxButton1.Enabled:=not cxButton5.Enabled;
cxButton4.Enabled:=(not cxButton5.Enabled)and(EData.UsersID.Value<>'');
cxGrid1.Enabled:=not cxButton5.Enabled;
end;

procedure TMainForm.UpdateLicStatus;
var
s:string;
d:TDate;
begin
  s:=DecodeLic(cxMemo1.Text, Edata.settingsLic.Value);
  if s.IsEmpty then
  begin
    Label15.Caption:='«· —ŒÌ’ €Ì— ’«·Õ';
    Label15.Font.Color:=clRed;
    Exit;
  end;
  s:=s.Substring(s.LastIndexOf(#13#10)+2);
  if s='noexp' then
  begin
    Label15.Caption:='’·«ÕÌ… œ«∆„…';
    Label15.Font.Color:=clGreen;
    Exit;
  end;
  try d:=StrToDate(s, jsonDateFormat); except s:=''; end;
  if s='' then
  begin
    Label15.Caption:='«· —ŒÌ’ €Ì— ’«·Õ';
    Label15.Font.Color:=clRed;
    Exit;
  end;
  Label15.Caption:=FormatDateTime('dd / MM / yyyy',d);
  if d<Now then
    Label15.Font.Color:=clRed
  else
    Label15.Font.Color:=clGreen;
end;

procedure TMainForm.UpdateUserData;
begin
  PostUnsavedLists;
  Clients.Close;
  Clients.ParamByName('id').AsString:=Edata.UsersID.Value;
  if not EData.UsersID.isnull then Clients.Open;

  Accounts.Close;
  Accounts.ParamByName('id').AsString:=Edata.UsersID.Value;
  if not EData.UsersID.isnull then Accounts.Open;

  Materials.Close;
  Materials.ParamByName('id').AsString:=Edata.UsersID.Value;
  if not EData.UsersID.IsNull then Materials.Open;

  Groups.Close;
  Groups.ParamByName('id').AsString:=Edata.UsersID.Value;
  if not EData.UsersID.isnull then Groups.Open;

  PayTypes.Close;
  PayTypes.ParamByName('id').AsString:=Edata.UsersID.Value;
  if not EData.UsersID.isnull then PayTypes.Open;
end;

end.
