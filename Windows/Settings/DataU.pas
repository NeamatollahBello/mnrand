unit DataU;

interface

uses
  System.SysUtils, System.Classes, inifiles, uniconhelper, UniProvider,
  SQLServerUniProvider, Data.DB, DBAccess, Uni, dialogs, MemDS, winsvc,
  windows, JvStringHolder, DAScript, UniScript;

type
  TEData = class(TDataModule)
    SQLServerUniProvider1: TSQLServerUniProvider;
    db: TUniConnection;
    mnr: TUniConnection;
    Users: TUniTable;
    UsersID: TGuidField;
    UsersName: TWideStringField;
    UsersPassword: TWideStringField;
    UsersLastToken: TStringField;
    mnrMaterials: TUniQuery;
    mnrMaterialsID: TGuidField;
    mnrMaterialsName: TWideStringField;
    mnrGroups: TUniQuery;
    mnrGroupsId: TGuidField;
    mnrGroupsName: TWideStringField;
    mnrClients: TUniQuery;
    mnrClientsID: TGuidField;
    mnrClientsName: TWideStringField;
    UsersSrc: TUniDataSource;
    mnrMaterialsSrc: TUniDataSource;
    mnrGroupsSrc: TUniDataSource;
    mnrClientsSrc: TUniDataSource;
    mnrAccounts: TUniQuery;
    mnrAccountsID: TGuidField;
    mnrAccountsName: TWideStringField;
    mnrAccountsSrc: TUniDataSource;
    mnrBillType: TUniQuery;
    mnrBillTypeID: TGuidField;
    mnrBillTypeName: TWideStringField;
    mnrBillTypeSrc: TUniDataSource;
    mnrCurr: TUniQuery;
    mnrCurrID: TGuidField;
    mnrCurrName: TWideStringField;
    mnrCurrSrc: TUniDataSource;
    mnrStore: TUniQuery;
    mnrStoreID: TGuidField;
    mnrStoreName: TWideStringField;
    mnrStoreSrc: TUniDataSource;
    mnrUsers: TUniQuery;
    mnrUsersID: TGuidField;
    mnrUsersName: TWideStringField;
    mnrUsersSrc: TUniDataSource;
    mnrCost: TUniQuery;
    mnrCostID: TGuidField;
    mnrCostName: TWideStringField;
    mnrCostSrc: TUniDataSource;
    UsersPriceField: TWideStringField;
    mnrPayTypes: TUniQuery;
    mnrPayTypesSrc: TUniDataSource;
    mnrPayTypesID: TGuidField;
    mnrPayTypesName: TWideStringField;
    UsersSaleman: TGuidField;
    mnrSaleMan: TUniQuery;
    mnrSaleManSrc: TUniDataSource;
    mnrSaleManID: TGuidField;
    mnrSaleManName: TWideStringField;
    settings: TUniTable;
    settingsSellType: TGuidField;
    settingsReturnType: TGuidField;
    settingsCurrency: TGuidField;
    settingsDiscAcc: TGuidField;
    settingsDisc2Acc: TGuidField;
    settingsPayInType: TGuidField;
    settingsPayOutType: TGuidField;
    settingsDayType: TGuidField;
    settingsSrc: TUniDataSource;
    settingsSpendAcc: TGuidField;
    UsersCostCenter: TGuidField;
    UsersStore: TGuidField;
    UsersmnrUser: TGuidField;
    settingsCompAddress: TWideStringField;
    settingsCompLogo: TBlobField;
    settingsLic: TWideMemoField;
    UserspBill: TBooleanField;
    UserspReturn: TBooleanField;
    UserspPayIn: TBooleanField;
    UserspPayOut: TBooleanField;
    UserspDiscIn: TBooleanField;
    UserspDiscOut: TBooleanField;
    UserspSpent: TBooleanField;
    UserspPrice: TBooleanField;
    UserspStock: TBooleanField;
    settingsPriceType: TGuidField;
    settingsStockType: TGuidField;
    UserspCustReport: TBooleanField;
    UserspAllAcc: TBooleanField;
    UserspGLedger: TBooleanField;
    settingsDefaultPayedAccount: TGuidField;
    UserspOnlyPOS: TBooleanField;
    UserspEditPrice: TIntegerField;
    UserspQuantityType: TIntegerField;
    UserspOnlyAvailable: TBooleanField;
    settingsMatUpdateInterval: TIntegerField;
    updates: TJvMultiStringHolder;
    UserspAllMat: TBooleanField;
    UserspShowCost: TBooleanField;
    settingsmnrVersion: TWideStringField;
    UserspShowQuality: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure UsersBeforeDelete(DataSet: TDataSet);
    procedure UserspEditPriceGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure UserspEditPriceSetText(Sender: TField; const Text: string);
    procedure UsersAfterInsert(DataSet: TDataSet);
    procedure UserspQuantityTypeGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure UserspQuantityTypeSetText(Sender: TField; const Text: string);
    procedure settingsAfterPost(DataSet: TDataSet);
    procedure settingsBeforeEdit(DataSet: TDataSet);
    procedure UsersBeforePost(DataSet: TDataSet);
    procedure UsersAfterEdit(DataSet: TDataSet);
    procedure UsersAfterDelete(DataSet: TDataSet);
    procedure UsersAfterPost(DataSet: TDataSet);
    procedure UsersAfterCancel(DataSet: TDataSet);
    procedure UsersPriceFieldGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure UsersPriceFieldSetText(Sender: TField; const Text: string);
  private
    { Private declarations }
  public
  appPath:string;
  procedure Connect(Server, User, Password, mnrDBName:string);
  procedure ReadDBSettings(var Server, User, Password, mnrDBName:string);
  procedure SaveDBSettings(Server, User, Password, mnrDBName: string);
    { Public declarations }
  end;

var
  EData: TEData;

function CreateNewGuid:string;

implementation
uses SelectServer, main;
const mnrVersion='1.02';
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


function PassToEnc(pass:string):string;
begin
  var b:TBytes:=TEncoding.Unicode.GetBytes(pass);
  for var i:=0 to Length(b)-1 do b[i]:=b[i] xor 35;
  Result:='';
  for var i:=0 to Length(b)-1 do Result:=Result+IntToHex(b[i], 2);
end;

function EncToPass(enc:string):string;
begin
  var b:TBytes;
  SetLength(b, Length(enc) div 2);
  for var i:=0 to Length(b)-1 do b[i]:=StrToInt('$'+copy(enc, i*2+1, 2));
  for var i:=0 to Length(b)-1 do b[i]:=b[i] xor 35;
  Result:=TEncoding.Unicode.GetString(b);
end;

function CreateNewGuid:string;
var
g:TGuid;
begin
  CreateGUID(g);
  Result:=GUIDToString(g);
end;

procedure TEData.Connect(Server, User, Password, mnrDBName: string);
begin
  db.Close;
  db.Server:=Server;
  db.Username:=User;
  db.Password:=Password;
  db.Database:='mnrand';
  db.ProviderName:='SQL Server';
  db.SpecificOptions.Values['ConnectionTimeout']:='5';
  db.Open;
  mnr.Close;
  mnr.Server:=Server;
  mnr.Username:=User;
  mnr.Password:=Password;
  mnr.Database:=mnrDBName;
  mnr.Open;
  SaveDBSettings(db.Server, db.Username, db.Password, mnr.Database);
  db.GetDBValue('if COL_LENGTH(''settings'', ''mnrVersion'') is null alter table settings add mnrVersion nvarchar(50) not null default ''0''');
  var it:TJvMultiStringHolderCollectionItem:=nil;
  try it:=updates.ItemByName[db.GetDBValue('select top 1 mnrVersion from settings')[0]]; except end;
  if it<>nil then
  begin
    for var i:=it.Index to updates.MultipleStrings.Count-1 do
      with TUniScript.Create(Self) do
      begin
        Connection:=db;
        SQL.Text:=updates.MultipleStrings.Items[i].Strings.Text;
        Execute;
        Destroy;
      end;

    db.GetDBValue('update settings set mnrVersion=:v',[mnrVersion]);
  end;
  Users.Open;
  settings.Open;
  mnrMaterials.Open;
  mnrGroups.Open;
  mnrClients.Open;
  mnrAccounts.Open;
  mnrBillType.Open;
  mnrCurr.Open;
  mnrStore.Open;
  mnrUsers.Open;
  mnrCost.Open;
  mnrPayTypes.Open;
  mnrSaleMan.Open;
end;

procedure TEData.DataModuleCreate(Sender: TObject);
var
Server, User, Password, Database:string;
begin
appPath:=ExcludeTrailingBackslash(ExtractFilePath(GetModuleName(hInstance)));
ReadDBSettings(Server, User, Password, Database);
SelectServerForm:=TSelectServerForm.Create(nil);
try
  Connect(Server, User, Password, Database);
except
  SelectServerForm.cxTextEdit1.Text:=Server;
  SelectServerForm.cxTextEdit2.Text:=User;
  SelectServerForm.cxTextEdit3.Text:=Password;
  SelectServerForm.cxComboBox1.Text:=Database;
  SelectServerForm.ShowModal;
end;
end;

procedure TEData.DataModuleDestroy(Sender: TObject);
begin
  SelectServerForm.Destroy;
end;

procedure TEData.ReadDBSettings(var Server, User, Password, mnrDBName: string);
begin
with TIniFile.Create(apppath+'\settings.ini') do
begin
  Server:=ReadString('db', 'server', '');
  User:=ReadString('db', 'user', '');
  try Password:=EncToPAss(ReadString('db', 'password', '')); except Password:=''; end;
  mnrDBName:=ReadString('db', 'database', '');
  Destroy;
end;
end;

procedure TEData.SaveDBSettings(Server, User, Password, mnrDBName: string);
begin
with TIniFile.Create(apppath+'\settings.ini') do
begin
  WriteString('db', 'server', server);
  WriteString('db', 'user', user);
  WriteString('db', 'password', PassToEnc(Password));
  WriteString('db', 'database', mnrDBName);
  Destroy;
end;
end;

procedure TEData.settingsAfterPost(DataSet: TDataSet);
begin
  MainForm.Button2.Visible:=Dataset.State in [dsEdit, dsInsert];
  MainForm.Button6.Visible:=Dataset.State in [dsEdit, dsInsert];
end;

procedure TEData.settingsBeforeEdit(DataSet: TDataSet);
begin
if MainForm.GetServiceState in [0, SERVICE_STOPPED] then else
begin
  MessageBox(MainForm.Handle, 'Ì—ÃÏ ≈Ìﬁ«› «·Œœ„… Õ Ï   „ﬂ‰ „‰  €ÌÌ— «·≈⁄œ«œ« .','«·≈⁄œ«œ« ',mb_ok or mb_right or mb_rtlreading);
  abort;
end;
end;

procedure TEData.UsersAfterCancel(DataSet: TDataSet);
begin
  MainForm.ToggleUserEdit;
end;

procedure TEData.UsersAfterDelete(DataSet: TDataSet);
begin
  MainForm.ToggleUserEdit;
end;

procedure TEData.UsersAfterEdit(DataSet: TDataSet);
begin
  MainForm.ToggleUserEdit;
end;

procedure TEData.UsersAfterInsert(DataSet: TDataSet);
begin
  UsersID.Value:=CreateNewGuid;
  MainForm.ToggleUserEdit;
end;

procedure TEData.UsersAfterPost(DataSet: TDataSet);
begin
  MainForm.ToggleUserEdit;
end;

procedure TEData.UsersBeforeDelete(DataSet: TDataSet);
begin
db.ExecSQL('delete from UserMaterials where UserID=:uid',[UsersID.Value]);
db.ExecSQL('delete from UserAccounts where UserID=:uid',[UsersID.Value]);
db.ExecSQL('delete from UserClients where UserID=:uid',[UsersID.Value]);
db.ExecSQL('delete from UserGroups where UserID=:uid',[UsersID.Value]);
db.ExecSQL('delete from UserPayTypes where UserID=:uid',[UsersID.Value]);
end;

procedure TEData.UsersBeforePost(DataSet: TDataSet);
begin
  UsersLastToken.Value:=''; //force logout
  db.GetDBValue('update users set LastToken='''' where ID=:id', [UsersID.Value]);
end;

procedure TEData.UserspEditPriceGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsInteger=2 then Text:='··√⁄·Ï ›ﬁÿ'
  else if Sender.AsInteger=3 then Text:='·« Ì„ﬂ‰'
  else Text:='„„ﬂ‰';
end;

procedure TEData.UserspEditPriceSetText(Sender: TField; const Text: string);
begin
  if Text='··√⁄·Ï ›ﬁÿ' then Sender.AsInteger:=2
  else if Text='·« Ì„ﬂ‰'then Sender.AsInteger:=3
  else Sender.AsInteger:=1;
end;

procedure TEData.UserspQuantityTypeGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsInteger=2 then Text:='Ã„Ì⁄ «·„” Êœ⁄« ' else Text:='„” Êœ⁄ «·„” Œœ„';
end;

procedure TEData.UserspQuantityTypeSetText(Sender: TField; const Text: string);
begin
  if Text='Ã„Ì⁄ «·„” Êœ⁄« ' then Sender.AsInteger:=2 else Sender.AsInteger:=1;
end;

procedure TEData.UsersPriceFieldGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsWideString='EndUser' then Text:='«·„” Â·ﬂ' else
  if Sender.AsWideString='Vendor' then Text:='«· Ê“Ì⁄' else
  if Sender.AsWideString='General' then Text:='«·⁄«„' else
  if Sender.AsWideString='Dealer' then Text:='«·ÊﬂÌ·' else
  if Sender.AsWideString='Import' then Text:='«·«” Ì—«œ' else
  if Sender.AsWideString='Export' then Text:='«· ’œÌ—' else
  if Sender.AsWideString='Retail' then Text:='«·„›—ﬁ' else
  if Sender.AsWideString='Whole' then Text:='«·Ã„·…' else
  Text:='«·„” Â·ﬂ';
end;

procedure TEData.UsersPriceFieldSetText(Sender: TField; const Text: string);
begin
  if Text='«·„” Â·ﬂ' then Sender.AsWideString:='EndUser' else
  if Text='«· Ê“Ì⁄' then Sender.AsWideString:='Vendor' else
  if Text='«·⁄«„' then Sender.AsWideString:='General' else
  if Text='«·ÊﬂÌ·' then Sender.AsWideString:='Dealer' else
  if Text='«·«” Ì—«œ' then Sender.AsWideString:='Import' else
  if Text='«· ’œÌ—' then Sender.AsWideString:='Export' else
  if Text='«·„›—ﬁ' then Sender.AsWideString:='Retail' else
  if Text='«·Ã„·…' then Sender.AsWideString:='Whole' else
  Sender.AsWideString:='EndUser';
end;

end.
