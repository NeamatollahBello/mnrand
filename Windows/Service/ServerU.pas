unit ServerU;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, windows,
  UniProvider, SQLServerUniProvider, Data.DB, DBAccess, Uni, MemDS,
  JvStringHolder, json, uniconhelper, activex, variants, jsonbuilder, idcontext,
  dialogs, inifiles, dateutils, VirtualTable, lic, log;

type
  TServer = class(TDataModule)
    actions: TWebDispatcher;
    db: TUniConnection;
    SQLServerUniProvider1: TSQLServerUniProvider;
    strs: TJvMultiStringHolder;
    UniQuery1: TUniQuery;
    AddItem: TUniQuery;
    Entry: TUniQuery;
    EditBill: TUniQuery;
    AddBill: TUniQuery;
    billdisc: TUniQuery;
    billpay: TUniQuery;
    addop: TUniQuery;
    kashf: TVirtualTable;
    kashfDoc: TWideStringField;
    kashfDocNotes: TWideStringField;
    kashfMadeen: TWideStringField;
    kashfDaen: TWideStringField;
    kashfQuantity: TWideStringField;
    kashfPrice: TWideStringField;
    kashfTotal: TWideStringField;
    kashfAdd: TWideStringField;
    kashfDisc: TWideStringField;
    kashfDate: TWideStringField;
    Teacher: TVirtualTable;
    TeacherDate: TWideStringField;
    TeacherNotes: TWideStringField;
    TeacherMadeen: TWideStringField;
    TeacherDaen: TWideStringField;
    TeacherBalance: TWideStringField;
    TeacherNum: TWideStringField;
    UniQuery2: TUniQuery;
    UniQuery3: TUniQuery;
    procedure actions404Action(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsloginAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsclientlistAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionspaytypelistAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionssettingsAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsaddbillAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsaddopAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsoplogAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsopdetAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionslogoAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionskashfAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsteacherAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsacclistAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsmatlist1Action(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsBeforeDispatch(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsAfterDispatch(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure actionsException(Sender: TObject; E: Exception;
      var Handled: Boolean);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

TAuthHandler=class
  procedure onAuth(AContext: TIdContext; const AAuthType, AAuthData: String; var VUsername, VPassword: String; var VHandled: Boolean);
  private
    procedure onException(AContext: TIdContext; AException: Exception);
end;

procedure StartServer;
procedure StopServer;

implementation
{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses IdHTTPWebBrokerBridge, webreq;
var
  jfs : TFormatSettings;
  server: TIdHTTPWebBrokerBridge;
  authHandler:TAuthHandler;

//settings
var
SellType, ReturnType, PriceType, StockType, Currency,
mnrDB, DiscAcc, Disc2Acc, dbserver, dbuser, dbpass, PayInType, PayOutType,
DayType, SpendAcc, Lic:string;
CertValidTo:TDateTime;

const
nullid:string='{00000000-0000-0000-0000-000000000000}';
function CreateNewGuid:string;
var
g:TGuid;
begin
  CreateGUID(g);
  Result:=GUIDToString(g);
end;

function jsonToDateTime(JSONDate: string): TDatetime;
var Year, Month, Day, Hour, Minute, Second: Word;
begin
  Year        := StrToInt(Copy(JSONDate, 1, 4));
  Month       := StrToInt(Copy(JSONDate, 6, 2));
  Day         := StrToInt(Copy(JSONDate, 9, 2));
  Hour        := StrToInt(Copy(JSONDate, 12, 2));
  Minute      := StrToInt(Copy(JSONDate, 15, 2));
  Second      := StrToInt(Copy(JSONDate, 18, 2));

  Result :=
  EncodeDate(Year, Month, Day)+
  EncodeTime(Hour, Minute, Second, 0);
end;

function CheckCert:TDateTime;
var
s:string;
begin
  s:=DecodeLic(GetDeviceID, Lic);
  if s.IsEmpty then Exit(IncDay(Now, -10));
  s:=s.Substring(s.LastIndexOf(#13#10)+2);
  if s='noexp' then Exit(IncYear(Now));
  try Result:=StrToDate(s, jsonDateFormat); except s:=''; end;
  if s='' then Exit(IncDay(Now, -10));
end;

function getToken(r:TWebRequest):string;
begin
  Result:=r.Authorization;
  if not Result.StartsWith('Bearer ') then Exit('');
  Delete(Result, 1, 7);
end;

function EncToPass(enc:string):string;
begin
  var b:TBytes;
  SetLength(b, Length(enc) div 2);
  for var i:=0 to Length(b)-1 do b[i]:=StrToInt('$'+copy(enc, i*2+1, 2));
  for var i:=0 to Length(b)-1 do b[i]:=b[i] xor 35;
  Result:=TEncoding.Unicode.GetString(b);
end;

procedure StartServer;
var
v:variant;
begin
  with TIniFile.Create(IncludeTrailingBackslash(ExtractFilePath(GetModuleName(HInstance)))+'settings.ini') do
  begin
    with TUniConnection.Create(nil) do
    begin
      ProviderName:='SQL Server';
      SpecificOptions.Values['ConnectionTimeout']:='5';
      Server:=ReadString('db', 'server', '');
      Username:=ReadString('db', 'user', '');
      try Password:=EncToPass(ReadString('db', 'password', '')); except Password:=''; end;
      Database:='mnrand';
      try Connect; except end;
      if not Connected then
      begin
        Sleep(10000);
        Connect;
      end;
      v:=GetDBValue('select SellType, ReturnType, Currency, DiscAcc, Disc2Acc, PayInType, PayOutType, DayType, SpendAcc, Lic, PriceType, StockType from settings');
      if v[0]=null then SellType:=nullid else SellType:=v[0];
      if v[1]=null then ReturnType:=nullid else ReturnType:=v[1];
      if v[2]=null then Currency:=nullid else Currency:=v[2];
      if v[3]=null then DiscAcc:=nullid else DiscAcc:=v[3];
      if v[4]=null then Disc2Acc:=nullid else Disc2Acc:=v[4];
      if v[5]=null then PayInType:=nullid else PayInType:=v[5];
      if v[6]=null then PayOutType:=nullid else PayOutType:=v[6];
      if v[7]=null then DayType:=nullid else DayType:=v[7];
      if v[8]=null then SpendAcc:=nullid else SpendAcc:=v[8];
      if v[9]=null then Lic:='' else Lic:=v[9];
      if v[10]=null then PriceType:=nullid else PriceType:=v[10];
      if v[11]=null then StockType:=nullid else StockType:=v[11];
      CertValidTo:=CheckCert;
      if CertValidTo>Now then GetDBValue('update users set LastToken=''''');
      Disconnect;
      Database:=ReadString('db', 'database', '');
      Connect;
      dbserver:=Server;
      dbuser:=UserName;
      dbpass:=Password;
      mnrDB:=Database;
      Destroy;
    end;
    Destroy;
  end;
  WebRequestHandler.WebModuleClass := TServer;
  authHandler:=TAuthHandler.Create;
  server:=TIdHTTPWebBrokerBridge.Create(nil);
  server.OnParseAuthentication:=authHandler.onAuth;
  server.DefaultPort:=8030;
  server.Bindings.Clear;
  server.Active:=True;
end;

procedure StopServer;
begin
server.Active:=False;
server.Bindings.Clear;
server.Destroy;
authHandler.Destroy;
end;

procedure TServer.actions404Action(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  Response.Content:='{"e":"com"}';
  Handled:=True;
end;

procedure TServer.actionsacclistAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
q:TUniQuery;
token:string;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  token:=getToken(Request);
  q:=db.SQLToDataSet(strs.StringsByName['acclist'].Text.Replace('MnrAccDB001', mnrDB), [token]);
  if q.Fields[0].FieldName='e' then Response.Content:=buildJson.row(q).json
  else Response.Content:=buildJson
  .start
    .prop('e', 'ok')
    .dataset('data', q)
  .finish
  .json;
  q.Destroy;
  Handled:=True;
end;

procedure TServer.actionsaddbillAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
j:TJsonObject;
ja:TJSONArray;
i, billnum:Int64;
itemsum, disc, payed, remain, vatrate, vat, net:double;
token, payacc, billid, optypetext, materialsText:string;
acc:variant;
qty1:variant;
v:variant;
ttc:boolean;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  token:=getToken(Request);
  if token.IsEmpty then Exit;
  var HasNewTaxes:=db.GetDBValue('select COL_LENGTH('''+mnrdb+'.dbo.mnrBillItem'',''Tax3'')')[0]<>Null;
  if HasNewTaxes then
  begin
    AddBill.SQL.Text:=strs.ItemByName['addbill2'].Strings.Text.Replace('MnrAccDB001', mnrDB);
    AddItem.SQL.Text:=strs.ItemByName['additem2'].Strings.Text.Replace('MnrAccDB001', mnrDB);
  end
  else
  begin
    AddBill.SQL.Text:=strs.ItemByName['addbill'].Strings.Text.Replace('MnrAccDB001', mnrDB);
    AddItem.SQL.Text:=strs.ItemByName['additem'].Strings.Text.Replace('MnrAccDB001', mnrDB);
  end;
  Entry.SQL.Text:=strs.ItemByName['entry'].Strings.Text.Replace('MnrAccDB001', mnrDB);
  AddBill.ParamByName('token').Value:=token;
  AddBill.ParamByName('appbilltype').AsInteger:=j.GetValue('btype', 1);
  j:=TJSONObject.ParseJSONValue(Request.Content) as TJsonObject;
  itemsum:=0;
  ja:=j.GetValue('items') as TJSONArray;
  for i:=0 to ja.Count-1 do
  begin
    itemsum:=itemsum+ja[i].GetValue<double>('amount',0)*ja[i].GetValue<double>('price', 0);
  end;
  itemsum:=round(itemsum*100)/100;
  payacc:=j.GetValue('payacc', '');
  ttc:=j.GetValue('ttc', false);
  payed:=j.GetValue<double>('payed', 0);
  disc:=j.GetValue<double>('disc', 0);
  vatrate:=j.GetValue<double>('vatrate', 0);
  if not ttc then
  begin
    net:=itemsum-disc;
    net:=round(net*100)/100;
    vat:=round(net*vatrate)/100;
    net:=net+vat;
    net:=round(net*100)/100;
  end
  else
  begin
    net:=itemsum-disc;
    net:=round(net*100)/100;
    vat:=net*vatrate/(100+vatrate);
    vat:=round(vat*100)/100;
  end;
  AddBill.Close;
  billid:=CreateNewGuid;
  AddBill.ParamByName('billid').value:=billid;
  AddBill.ParamByName('dt').Value:=DateOf(jsonToDateTime(j.GetValue('time', '')));
  AddBill.ParamByName('dtt').Value:=jsonToDateTime(j.GetValue('time', ''));
  AddBill.ParamByName('accid').Value:=j.GetValue('account', '');
  if (payAcc<>'')and((net-payed)<0.01) then //totally paid
  begin
    AddBill.ParamByName('payacc').Value:=payacc;
    AddBill.ParamByName('paytype').Value:=0;
  end
  else
  begin
    AddBill.ParamByName('payacc').Value:=j.GetValue('account', '');;
    AddBill.ParamByName('paytype').Value:=1;
  end;
  AddBill.ParamByName('curr').Value:=Currency;
  if j.GetValue('btype', 1)=2 then
  begin
    opTypeText:='„. „»Ì⁄« ';
    AddBill.ParamByName('billtype').value:=ReturnType;
  end
  else if j.GetValue('btype', 1)=3 then
  begin
    opTypeText:='⁄—÷ ”⁄—';
    AddBill.ParamByName('billtype').value:=PriceType;
  end
  else if j.GetValue('btype', 1)=4 then
  begin
    opTypeText:='„Õ÷— Ã—œ';
    AddBill.ParamByName('billtype').value:=StockType;
  end
  else //if j.GetValue('btype', 1)=1 then
  begin
    opTypeText:='„»Ì⁄« ';
    AddBill.ParamByName('billtype').value:=SellType;
  end;
  v:=db.GetDBValue('select bNoEntry, bNoPost, bAutoPost from '+mnrdb+'.dbo.mnrBillType where ID=:id', [AddBill.ParamByName('billtype').value]);
  var doesNeedEntry:=not v[0];
  var isposted:=0;
  if not v[1] then if v[2] then isposted:=1;
  AddBill.ParamByName('notes').Value:=j.GetValue('notes', '');
  AddBill.ParamByName('net').AsFloat:=net;
  AddBill.ParamByName('isposted').AsInteger:=isposted;
  AddBill.ParamByName('itemsum').AsFloat:=itemsum;
  AddBill.ParamByName('payed').AsFloat:=payed;
  AddBill.ParamByName('vat').AsFloat:=vat;
  AddBill.ParamByName('disc').AsFloat:=disc;
  AddBill.ParamByName('nulldate').AsDateTime:=TDateTime(0);
  AddBill.ParamByName('nullid').AsString:=nullid;
  AddBill.Open;
  if AddBill.Fields[0].FieldName='e' then
  begin
    Response.Content:=buildJson.row(AddBill).json;
    Exit;
  end;
  BillNum:=Round(AddBill.FieldByName('Num').AsFloat);
  materialsText:='';
  for i:=0 to ja.Count-1 do
  begin
    MaterialsText:=MaterialsText+ja[i].GetValue('name', '')+#13;
    AddItem.Close;
    AddItem.ParamByName('itemid').Value:=CreateNewGUID;
    AddItem.ParamByName('billid').Value:=billid;
    AddItem.ParamByName('itemno').Value:=i;
    AddItem.ParamByName('matid').Value:=ja[i].GetValue('id', '');
    if ja[i].GetValue<double>('unit', 1)=1 then qty1:=ja[i].GetValue<double>('amount', 0) else
    qty1:=db.GetDBValue('select :qty*Unit'+ja[i].GetValue<double>('unit', 1).ToString+'Rate from '+mnrDB+'..mnrMaterial where ID=:id', [ja[i].GetValue<double>('amount', 0), ja[i].GetValue('id', '')])[0];
    v:=db.GetDBValue('select case  when Unit2Rate>0 then :qty/Unit2Rate else 0 end, case  when Unit3Rate>0 then :qty/Unit3Rate else 0 end, case  when Unit4Rate>0 then :qty/Unit4Rate else 0 end, case  when Unit5Rate>0 then :qty/Unit5Rate else 0 end from '+mnrDB+'..mnrMaterial where ID=:id',[qty1, ja[i].GetValue('id', '')]);
    AddItem.ParamByName('qty1').Value:=qty1;
    AddItem.ParamByName('qty2').Value:=v[0];
    AddItem.ParamByName('qty3').Value:=v[1];
    AddItem.ParamByName('qty4').Value:=v[2];
    AddItem.ParamByName('qty5').Value:=v[3];
    AddItem.ParamByName('unit').Value:=ja[i].GetValue<double>('unit', 1);
    AddItem.ParamByName('oneprice').Value:=ja[i].GetValue<double>('price', 0);
    AddItem.ParamByName('notes').Value:=ja[i].GetValue('notes', '');
    AddItem.ParamByName('storeid').Value:=AddBill.FieldByName('store').Value;
    AddItem.ParamByName('costjobid').Value:=AddBill.FieldByName('costcenter').Value;
    AddItem.ParamByName('saleman').Value:=AddBill.FieldByName('saleman').Value;
    AddItem.ParamByName('nulldate').Value:=TDateTime(0);
    AddItem.ParamByName('vatratio').Value:=vatrate;
    if not ttc then
    begin
      AddItem.ParamByName('vat').Value:=ja[i].GetValue<double>('amount', 0)*ja[i].GetValue<double>('price', 0)*vatrate/100;
    end
    else
    begin
      AddItem.ParamByName('vat').Value:=ja[i].GetValue<double>('amount', 0)*ja[i].GetValue<double>('price', 0)*vatrate/(100+vatrate);
    end;
    AddItem.Execute;
  end;
  MaterialsText:=MaterialsText.Trim;

  i:=0;
  if disc>0.01 then
  begin
    db.ExecSQL(strs.ItemByName['billdisc'].Strings.Text.Replace('MnrAccDB001', mnrDB),
    [CreateNewGuid, billid, i, discacc, disc, 0, currency,AddBill.FieldByName('costcenter').Value, AddBill.FieldByName('saleman').Value]);
    i:=i+1;
  end;

  if (payAcc<>'')and((net-payed)>=0.01) then
  if j.GetValue('btype', 1)=1 then
  begin
    db.ExecSQL(strs.ItemByName['billpay'].Strings.Text.Replace('MnrAccDB001', mnrDB),
    [CreateNewGuid, billid, 0, payacc, payed,0, currency,AddBill.FieldByName('costcenter').Value, AddBill.FieldByName('saleman').Value]);
  end
  else
  begin
    db.ExecSQL(strs.ItemByName['billpay'].Strings.Text.Replace('MnrAccDB001', mnrDB),
    [CreateNewGuid, billid, 0, payacc, 0,payed, currency, AddBill.FieldByName('costcenter').Value, AddBill.FieldByName('saleman').Value]);
  end;

  if doesNeedEntry then
  begin
    Entry.ParamByName('billid').Value:=billid;
    Entry.ParamByName('newentryid').Value:=CreateNewGUID;
    Entry.Execute;
  end;

  //log operation
  acc:=j.GetValue('account', '');
  if acc='' then acc:=Null;
  j.AddPair('num', TJSONNumber.Create(BillNum));
  with db.SQLToDataSet('insert into OpLog(ID, UserID, Date, Operation, Num, ClientID, ClientNum, ClientName, Notes, Materials, Details) values (:p0, '+
  '(select ID from Users where LastToken=:p1)'+', :p2, :p3, (select N'''+opTypeText+'° ''+LTrim(Str(:p4))), :p5, :p6, :p7, :p8, :p9, :p10)',
  [CreateNewGuid,token, jsonToDateTime(j.GetValue('time', '')), optypetext, billNum,
  j.GetValue('account', ''), j.GetValue('acccode', ''), j.GetValue('accname', ''),
  j.GetValue('notes', ''), materialsText, ''], true) do
  begin
    with ParamByName('p10') do
    begin
      DataType:=ftWideMemo;
      AsWideString:=j.ToJSON;
    end;
    Execute;
    Destroy;
  end;
  Response.Content:='{"e":"ok", "num":'+billnum.ToString+'}';
  j.Destroy;
end;

procedure TServer.actionsaddopAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
token:string;
optype:byte; //0 general, 1 payin, 2 payout, 3 spend, 4 discout, 5 discin
j:TJsonObject;
optypetext, mnrTypeText:string;
acc:variant;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  token:=getToken(Request);
  if token.IsEmpty then Exit;
  addop.SQL.Text:=strs.ItemByName['addop'].Strings.Text.Replace('MnrAccDB001', mnrDB);
  j:=TJSONObject.ParseJSONValue(Request.Content) as TJsonObject;
  optype:=j.GetValue<byte>('optype', 0);
  with addop do
  begin
    Close;
    ParamByName('token').Value:=token;
    ParamByName('curr').Value:=Currency;
    ParamByName('dt').Value:=DateOf(jsonToDateTime(j.GetValue('time', '')));
    ParamByName('notes').AsWideString:=j.GetValue('notes', '');
    ParamByName('amount').AsFloat:=j.GetValue<Double>('amount', 0);
    ParamByName('nullid').Value:=nullid;

    opTypeText:='';
    mnrTypeText:='ÌÊ„Ì…';
    if optype=0 then
    begin
      opTypeText:='ﬁÌœ ⁄«„';
      ParamByName('daytype').Value:=DayType;
      ParamByName('optype').Value:=0;
      ParamByName('daen').Value:=j.GetValue('acc1', '');
      ParamByName('madeen').Value:=j.GetValue('acc2', '');
    end;

    if optype=1 then
    begin
      opTypeText:='ﬁ»÷';
      mnrTypeText:='ﬁ»÷';
      ParamByName('daytype').Value:=PayInType;
      ParamByName('optype').Value:=1;
      ParamByName('daen').Value:=j.GetValue('acc1', '');
      ParamByName('madeen').Value:=j.GetValue('acc2', '');
    end;

    if optype=2 then
    begin
      opTypeText:='œ›⁄';
      mnrTypeText:='œ›⁄';
      ParamByName('daytype').Value:=PayOutType;
      ParamByName('optype').Value:=2;
      ParamByName('daen').Value:=j.GetValue('acc2', '');
      ParamByName('madeen').Value:=j.GetValue('acc1', '');
    end;

    if optype=3 then
    begin
      opTypeText:='„’—Ê›';
      ParamByName('daytype').Value:=DayType;
      ParamByName('optype').Value:=0;
      ParamByName('daen').Value:=j.GetValue('acc1', '');
      ParamByName('madeen').Value:=SpendAcc;
    end;

    if optype=4 then
    begin
      opTypeText:='Õ”„ „„‰ÊÕ';
      ParamByName('daytype').Value:=DayType;
      ParamByName('optype').Value:=0;
      ParamByName('daen').Value:=j.GetValue('acc1', '');
      ParamByName('madeen').Value:=DiscAcc;
    end;

    if optype=5 then
    begin
      opTypeText:='Õ”„ „ﬂ ”»';
      ParamByName('daytype').Value:=DayType;
      ParamByName('optype').Value:=0;
      ParamByName('daen').Value:=Disc2Acc;
      ParamByName('madeen').Value:=j.GetValue('acc1', '');
    end;
    Open;

    //log operation
    acc:=j.GetValue('account', '');
    if acc='' then acc:=Null;
    db.GetDBValue('insert into OpLog(ID, UserID, Date, Operation, Num, ClientID, ClientNum, ClientName, Notes, Materials, Details) values (:p0, '+
    '(select ID from Users where LastToken=:p1)'+', :p2, :p3, (select N'''+mnrTypeText+'° ''+LTrim(Str(Number)) from '+mnrDB+'.dbo.mnrPay where ID=:p4), :p5, :p6, :p7, :p8, :p9, :p10)',
    [CreateNewGuid,token, jsonToDateTime(j.GetValue('time', '')), optypetext, Fields[0].AsWideString,
    acc, j.GetValue('acccode', ''), j.GetValue('accname', ''),
    j.GetValue('notes', ''), '', j.ToJSON]);


    Response.Content:='{"e":"ok", "opid":"'+Fields[0].AsWideString+'"}';
    j.Destroy;
  end;
end;

procedure TServer.actionsAfterDispatch(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
  if Assigned(db) then
  begin
    try
      if db.InTransaction then db.Commit;
    finally
      if db.Connected then db.Disconnect;
    end;
  end;
  CoUninitialize;
end;

procedure TServer.actionsBeforeDispatch(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
try
  coinitializeex(nil, 2);
  if db.Connected then db.Disconnect;
  db.Server:=dbServer;
  db.Username:=dbuser;
  db.Password:=dbpass;
  db.Open;
  db.ExecSQL('SET XACT_ABORT ON;');
  db.StartTransaction;
except on e:Exception do
begin
   LogStr(e.Message);
   Response.Content:=buildJson.start.prop('e', 'sql').prop('error', e.Message).finish.json;
   Handled:=True;
end;
end;
end;

procedure TServer.actionsclientlistAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
q:TUniQuery;
token:string;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  token:=getToken(Request);
  q:=db.SQLToDataSet(strs.StringsByName['clientlist'].Text.Replace('MnrAccDB001', mnrDB), [token]);
  if q.Fields[0].FieldName='e' then Response.Content:=buildJson.row(q).json
  else Response.Content:=buildJson
  .start
    .prop('e', 'ok')
    .dataset('data', q)
  .finish
  .json;
  q.Destroy;
  Handled:=True;
end;

procedure TServer.actionsException(Sender: TObject; E: Exception;
  var Handled: Boolean);
begin
  if Assigned(db) and db.InTransaction then db.Rollback;
  LogStr(e.Message);
  if Assigned(actions.Response) then
  begin
    actions.Response.StatusCode:=200;
    actions.Response.Content:=buildJson.start.prop('e', 'sql').prop('error', e.Message).finish.json;
  end;
  Handled:=True;
end;

procedure TServer.actionskashfAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
token,s:string;
j:TJSONObject;
d1, d2:string;
cust:string;
q:TUniQuery;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  token:=getToken(Request);
  j:=TJSONObject.ParseJSONValue(Request.Content) as TJsonObject;
  d1:=j.GetValue('d1', '');
  d2:=j.GetValue('d2', '');
  cust:=j.GetValue('cust', '');
  var sbd:=j.GetValue('sbd', integer(1));
  q:=db.SQLToDataSet(strs.StringsByName['kashf'].Text.Replace('MnrAccDB001', mnrDB), [token, cust,Currency, d1, d2, sbd]);
  q.First;
//  logstr(buildJson.start.dataset('data', q).finish.json);
  q.First;
  if q.Fields[0].FieldName='e' then Response.Content:=buildJson.row(q).json else
  begin

    kashf.Clear;
    q.First;
    while not q.Eof do
    begin
      kashf.Append;

      kashfDocNotes.Value:='';
      if q.FieldByName('BillTotal').AsFloat<>0 then
        if q.FieldByName('MatName').AsWideString.Trim.IsEmpty then
        begin
          if q.FieldByName('PayType').AsInteger=1 then
            kashfDocNotes.Value:='¬Ã·'
          else
            kashfDocNotes.Value:='‰ﬁœÌ';
          if not q.FieldByName('Notes').AsWideString.Trim.IsEmpty then
            kashfDocNotes.Value:=q.FieldByName('Notes').AsWideString+' / '+kashfDocNotes.Value;
        end;

      if q.FieldByName('TypeName').AsWideString.Trim.IsEmpty then kashfDoc.Value:='' else
      kashfDoc.Value:=q.FieldByName('TypeName').AsWideString.Trim+' - '+q.FieldByName('Number').AsWideString;

      if q.FieldByName('TypeID').IsNull then kashfDate.Value:='«·—’Ìœ «·”«»ﬁ' else
      if q.FieldByName('TypeName').AsWideString.Trim.IsEmpty then kashfDate.Value:='' else
      kashfDate.Value:=FormatDateTime('dd / MM / yyyy', q.FieldByName('Date').AsDateTime);

      if q.FieldByName('Debit').AsFloat=0 then kashfMadeen.Value:='' else
      kashfMadeen.Value:=FormatFloat(',#.##', q.FieldByName('Debit').AsFloat);

      if q.FieldByName('Credit').AsFloat=0 then kashfDaen.Value:='' else
      kashfDaen.Value:=FormatFloat(',#.##', q.FieldByName('Credit').AsFloat);

      if q.FieldByName('PayType').AsInteger=0{kashfDocNotes.Value.Contains('‰ﬁœÌ')} then
      begin
        if kashfMadeen.Value.IsEmpty then kashfMadeen.Value:=kashfDaen.Value;
        if kashfDaen.Value.IsEmpty then kashfDaen.Value:=kashfMadeen.Value;
      end;

      if not q.FieldByName('MatName').AsWideString.Trim.IsEmpty then
      begin
        kashfDocNotes.Value:=q.FieldByName('MatCode').AsWideString.Trim+'-'+q.FieldByName('MatName').AsWideString.Trim;
        if not q.FieldByName('Notes').AsWideString.Trim.IsEmpty then kashfDocNotes.Value:=kashfDocNotes.Value+' - '+q.FieldByName('Notes').AsWideString;
      end;

      if kashfDocNotes.Value='' then kashfDocNotes.Value:=q.FieldByName('Notes').AsWideString;


      if q.FieldByName('ItemQty').AsFloat=0 then kashfQuantity.Value:='' else
      kashfQuantity.Value:=FormatFloat(',#.##', q.FieldByName('ItemQty').AsFloat);

      if q.FieldByName('ItemPrice').AsFloat=0 then kashfPrice.Value:='' else
      kashfPrice.Value:=FormatFloat(',#.##', q.FieldByName('ItemPrice').AsFloat);

      if (q.FieldByName('ItemQty').AsFloat*q.FieldByName('ItemPrice').AsFloat)=0 then kashfTotal.Value:='' else
      kashfTotal.Value:=FormatFloat(',,#.##', q.FieldByName('ItemQty').AsFloat*q.FieldByName('ItemPrice').AsFloat);

      if q.FieldByName('Disc').AsFloat=0 then kashfDisc.Value:='' else
      kashfDisc.Value:=FormatFloat(',#.##', q.FieldByName('Disc').AsFloat);

      if q.FieldByName('Extra').AsFloat=0 then kashfAdd.Value:='' else
      kashfAdd.Value:=FormatFloat(',#.##', q.FieldByName('Extra').AsFloat);

      kashf.Post;
      q.Next;
    end;

    Response.Content:=buildJson
    .start
      .prop('e', 'ok')
      .dataset('data', kashf)
    .finish
    .json;
  end;
  q.Destroy;
  Handled:=True;
end;

procedure TServer.actionsloginAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
user, pass:string;
v:variant;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  with TJsonObject.ParseJSONValue(Request.Content) do
  begin
    user:=GetValue<string>('user');
    pass:=GetValue<string>('pass');
    Destroy;
  end;
  v:=db.GetDBValue('exec dbo.login :u, :p', [user, pass])[0];
  if v=null then
    Response.Content:='{"e":"login"}'
  else
    Response.Content:='{"token":"'+v+'", "e":"ok"}';
  Handled:=True;
end;

procedure TServer.actionslogoAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
token:string;
j:TJSONObject;
q:TUniQuery;
bs:TStream;
begin
try
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  Response.FreeContentStream:=false;
  Handled:=False;
  token:=getToken(Request);
  q:=db.SQLToDataSet(strs.StringsByName['logo'].Text.Replace('MnrAccDB001', mnrDB), [token]);
  if q.Fields[0].FieldName<>'e' then
  begin
    bs:=q.CreateBlobStream(q.Fields[0], bmRead);
    Response.ContentLength:=bs.Size;
    Response.ContentStream:=bs;
    Response.SendResponse;
    bs.Destroy;
    Handled:=True;
  end
  else
  begin
    Response.ContentType:='application/octet-stream';
    Response.ContentLength:=0;
    Response.SendResponse;
    Handled:=True;
  end;
  q.Destroy;
except on e:Exception do
begin
   LogStr(e.Message);
    Response.ContentType:='application/octet-stream';
    Response.ContentLength:=0;
    Response.SendResponse;
    Handled:=True;
end;
end;
end;

procedure TServer.actionsmatlist1Action(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
token:string;
var matids, matdetails:TDataSet;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;

  token:=getToken(Request);
  var v:=db.GetDBValue('select ID, isnull(Store, :nullid), PriceField, pQuantityType, pOnlyAvailable from Users where LastToken=:token', [nullid, token]);
  if v[0]=Null then
  begin
    Response.Content:=buildJson.start.prop('e', 'login').finish.json;
    Handled:=True;
    Exit;
  end;
  var uid:string:=v[0];
  var StoreID:string:=v[1];
  var PriceField:string:=v[2];
  var QuantityType:integer:=v[3];
  if QuantityType=2 then StoreID:=nullid;
  var OnlyAvailable:boolean:=v[4];


  matids:=db.SQLToDataSet(strs.StringsByName['matlist1'].Text.Replace('MnrAccDB001', mnrDB).Replace('<Price>', PriceField), [uid]);
  var stcheck:=1;
  if StoreID=nullid then stcheck:=0;
  matDetails:=db.SQLToDataSet(strs.StringsByName['matlist2'].Text.Replace('MnrAccDB001', mnrDB),
  [stcheck, StoreID]);
  var customBarcodes:=db.SQLToDataSet(strs.StringsByName['barcodes'].Text.Replace('MnrAccDB001', mnrDB));


  var MatIDField:=matDetails.FieldByName('MatID');
  var StoreIDField:=matDetails.FieldByName('StoreID');
  var StoreNameField:=matDetails.FieldByName('StoreName');
  var QtyField:=matDetails.FieldByName('Qty');

  var jmat:=buildJson.startarr;
  var jbarcodes:=buildJson.startarr;
  matids.First;
  matdetails.First;
  matdetails.Prior;
  while not matids.Eof do
  begin
    var av:=matDetails.Locate('MatID', matids.Fields[0].AsWideString, []);
    var sumq:double:=0;
    var jqty:=buildjson.startarr;
    if av then
    begin
      av:=False;
      repeat
        if QtyField.AsFloat>0 then
        begin
          av:=True;
          jqty.start
            .prop('storeid', StoreIDField.AsWideString)
            .prop('storename', StoreNameField.AsWideString)
            .prop('qty', (QtyField.AsFloat*1000)/1000)
          .finish;
          sumq:=sumq+QtyField.AsFloat;
        end;
        matDetails.Next;
      until matDetails.Eof or (MatIDField.AsWideString<>matids.Fields[0].AsWideString);
      matdetails.Prior;
    end;
    jqty.finish;

    if OnlyAvailable and (not av) then
    begin
      matids.Next;
      continue;
    end;

    //barcodes
    for var i:=1 to 5 do
    begin
      var s:=matids.Fields[i+13].AsWideString.Trim;
      if s.IsEmpty then continue;
      jbarcodes.start
      .prop('matid', matids.Fields[0].AsWideString)
      .prop('unit', i)
      .prop('barcode', s)
      .finish;
    end;

    jmat.start
      .prop('id', matids.Fields[0].AsWideString)
      .prop('name', matids.Fields[1].AsWideString)
      .prop('code', matids.Fields[2].AsWideString)
      .prop('group', matids.Fields[3].AsWideString)
      .prop('price1', matids.Fields[4].AsFloat)
      .prop('price2', matids.Fields[5].AsFloat)
      .prop('price3', matids.Fields[6].AsFloat)
      .prop('price4', matids.Fields[7].AsFloat)
      .prop('price5', matids.Fields[8].AsFloat)
      .prop('unit1', matids.Fields[9].AsWideString)
      .prop('unit2', matids.Fields[10].AsWideString)
      .prop('unit3', matids.Fields[11].AsWideString)
      .prop('unit4', matids.Fields[12].AsWideString)
      .prop('unit5', matids.Fields[13].AsWideString)
      .prop('barcode1', matids.Fields[14].AsWideString)        // it is needed for search by barcode in POS (limited suport - only main unit)
      .prop('cost', Round(matids.Fields[19].AsFloat*100)/100)
      .prop('quality', matids.Fields[20].AsWideString)
      .prop('qtys', jqty.json)
      .prop('qty', sumq)
    .finish;

    matids.Next;
  end;

  //custom barcodes
  customBarcodes.First;
  while not customBarcodes.Eof do
  begin
    var s:=customBarcodes.Fields[2].AsWideString.Trim;
    if s.IsEmpty then continue;
    jbarcodes.start
    .prop('matid', customBarcodes.Fields[0].AsWideString)
    .prop('unit', customBarcodes.Fields[1].AsInteger)
    .prop('barcode', s)
    .finish;
    customBarcodes.Next;
  end;

  jmat.finish;
  jbarcodes.finish;
  Response.Content:=buildJson.start
    .prop('e', 'ok')
    .prop('data', jmat.json, True)
    .prop('barcodes', jbarcodes.json, True)
  .finish.json;
  matids.Destroy;
  matDetails.Destroy;
  Handled:=True;
end;

procedure TServer.actionsopdetAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
token:string;
j:TJSONObject;
q:TUniQuery;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  token:=getToken(Request);
  j:=TJSONObject.ParseJSONValue(Request.Content) as TJsonObject;
  q:=db.SQLToDataSet(strs.StringsByName['opdet'].Text.Replace('MnrAccDB001', mnrDB), [token, j.GetValue<string>('ID','')]);
  if q.Fields[0].FieldName='e' then Response.Content:=buildJson.row(q).json else
  Response.Content:='{"e":"ok", "data":'+q.Fields[0].AsWideString+'}';
  q.Destroy;
  j.Destroy;
  Handled:=True;
end;

procedure TServer.actionsoplogAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
token,s:string;
j:TJSONObject;
v1, v2:Variant;
q:TUniQuery;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  token:=getToken(Request);
  j:=TJSONObject.ParseJSONValue(Request.Content) as TJsonObject;
  s:=j.GetValue('d1', '');
  if s='' then v1:=null else v1:=DateOf(StrToDateTime(s, jfs));
  s:=j.GetValue('d2', '');
  if s='' then v2:=null else v2:=DateOf(StrToDateTime(s, jfs));
  q:=db.SQLToDataSet(strs.StringsByName['oplog'].Text.Replace('MnrAccDB001', mnrDB), [token, v1, v2]);
  if q.Fields[0].FieldName='e' then Response.Content:=buildJson.row(q).json else
  Response.Content:=buildJson
  .start
    .prop('e', 'ok')
    .dataset('data', q)
  .finish
  .json;
  q.Destroy;
  Handled:=True;
end;


procedure TServer.actionspaytypelistAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
token:string;
q:TUniQuery;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  token:=getToken(Request);
  q:=db.SQLToDataSet(strs.StringsByName['paytypelist'].Text.Replace('MnrAccDB001', mnrDB), [token]);
  if q.Fields[0].FieldName='e' then Response.Content:=buildJson.row(q).json else
  Response.Content:=buildJson
  .start
    .prop('e', 'ok')
    .dataset('data', q)
  .finish
  .json;
  q.Destroy;
  Handled:=True;
end;


procedure TServer.actionssettingsAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
token:string;
q:TUniQuery;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  token:=getToken(Request);
  q:=db.SQLToDataSet(strs.StringsByName['settings'].Text.Replace('MnrAccDB001', mnrDB), [token]);
  Response.Content:=buildJson.start.prop('e', 'ok').row('data', q).finish.json;
  q.Destroy;
  Handled:=True;
end;


procedure TServer.actionsteacherAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
token,s:string;
j:TJSONObject;
d1, d2:string;
cust:string;
q:TUniQuery;
begin
  if CertValidTo<Now then
  begin
    Response.Content:='{"e":"exp"}';
    Exit;
  end;
  token:=getToken(Request);
  j:=TJSONObject.ParseJSONValue(Request.Content) as TJsonObject;
  d1:=j.GetValue('d1', '');
  d2:=j.GetValue('d2', '');
  cust:=j.GetValue('cust', '');
  q:=db.SQLToDataSet(strs.StringsByName['teacher'].Text.Replace('MnrAccDB001', mnrDB), [token, Currency, cust, d1, d2]);
  if q.Fields[0].FieldName='e' then Response.Content:=buildJson.row(q).json else
  begin
    Teacher.Clear;
    q.First;
    var sum:double:=0;
    while not q.Eof do
    begin
      var enum:=q.FieldByName('ENumber').AsWideString;
      var isFirst:=enum='0';
      var daen:=q.FieldByName('Credit').AsFloat;
      var madeen:=q.FieldByName('Debit').AsFloat;
      if isFirst then sum:=q.FieldByName('PrevBalance').AsFloat else sum:=sum+madeen-daen;
      Teacher.Append;
      if isFirst then TeacherDate.Value:='' else TeacherDate.Value:=FormatDateTime('dd / MM / yyyy', q.FieldByName('EDate').AsDateTime);
      if isFirst then TeacherNotes.Value:=q.FieldByName('AccCode').AsWideString+' - '+q.FieldByName('AccName').AsWideString else q.FieldByName('INotes').AsWideString;
      if madeen>0 then TeacherMadeen.Value:=FormatFloat(',#.##', Madeen) else TeacherMadeen.Value:='';
      if daen>0 then TeacherDaen.Value:=FormatFloat(',#.##', daen) else TeacherDaen.Value:='';
      if isFirst then TeacherBalance.Value:=FormatFloat(',#.##', sum+madeen-daen) else TeacherBalance.Value:=FormatFloat(',#.##', sum);
      if isFirst then TeacherNum.Value:='' else TeacherNum.Value:=q.FieldByName('ENumber').AsWideString;
      Teacher.Post;

      if isFirst and (sum<>0) then
      begin
        Teacher.Append;
        TeacherDate.Value:='';
        TeacherNotes.Value:='«·—’Ìœ «·”«»ﬁ';
        if sum>0 then TeacherMadeen.Value:=FormatFloat(',#.##', sum) else TeacherMadeen.Value:='';
        if sum<0 then TeacherDaen.Value:=FormatFloat(',#.##', -sum) else TeacherDaen.Value:='';
        TeacherNum.Value:='';
        TeacherBalance.Value:='';
        Teacher.Post;
      end;

      q.Next;
    end;

    Response.Content:=buildJson
    .start
      .prop('e', 'ok')
      .dataset('data', Teacher)
    .finish
    .json;
  end;
  q.Destroy;
  Handled:=True;
end;


procedure TServer.DataModuleCreate(Sender: TObject);
begin

end;

{ TAuthHandler }
procedure TAuthHandler.onException(AContext: TIdContext; AException: Exception);
begin
end;
procedure TAuthHandler.onAuth(AContext: TIdContext; const AAuthType,
  AAuthData: String; var VUsername, VPassword: String; var VHandled: Boolean);
begin
  VHandled:=True;
end;

initialization
GetLocaleFormatSettings(0,jfs);
jfs.ShortDateFormat:='yyyy-MM-dd';
jfs.DateSeparator:='-';
jfs.ShortTimeFormat:='hh:mm:ss';
end.
