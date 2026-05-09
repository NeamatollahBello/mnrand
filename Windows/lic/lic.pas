unit lic;


interface
uses sysutils, dialogs, uWin32_DiskDrive;

function GenLic(DeviceID, CompInfo:string):string;
function DecodeLic(DeviceID, Lic:string):string;
function GetDeviceID:string;

implementation

uses Hash, Prism.Crypto.AES;

function BytesToHexString(b:TBytes):string;
var
i:integer;
begin
  Result:='';
  for i:=0 to Length(b)-1 do
  begin
    Result:=Result+IntToHex(b[i],2).ToLower;
  end;
end;

function HexStringToBytes(s:string):TBytes;
var
i:integer;
begin
  SetLength(Result, Length(s) div 2);
  for i:=0 to Length(Result)-1 do
    Result[i]:=StrToInt('$'+s[i*2+1]+s[i*2+2]);
end;


function GetDeviceID:string;
var
sha256:THashSHA2;
b:TBytes;
begin
  with TWin32_DiskDrive.Create() do
  begin
    var ii:=10000000;
    for var i:=0 to GetCollectionCount-1 do
    begin
      SetCollectionIndex(i);
      var ix:=GetPropertyValue('Index');
      if ix<ii then
      begin
        Result:=SerialNumber;
        ii:=ix;
      end;
    end;
    Destroy;
  end;
  sha256:=THashSHA2.Create;
  b:=TEncoding.UTF8.GetBytes(Result+'info'+Result);
  sha256.Update(b, Length(b));
  Result:=BytesToHexString(sha256.HashAsBytes);
end;

function DecodeLic(DeviceID, Lic:string):string;
var
sha256:THashSHA2;
id2, check:string;
key, b:TBytes;
l, i:integer;
begin
try
  sha256:=THashSHA2.Create;
  b:=TEncoding.UTF8.GetBytes(DeviceID);
  sha256.Update(b, Length(b));
  id2:=BytesToHexString(sha256.HashAsBytes);

  sha256.Reset;
  SetLength(b,0);
  b:=TEncoding.UTF8.GetBytes(id2+DeviceID+id2+id2);
  sha256.Update(b, Length(b));
  check:=#13#10+BytesToHexString(sha256.HashAsBytes);

  sha256.Reset;
  b:=TEncoding.UTF8.GetBytes(id2+DeviceID+DeviceID);
  sha256.Update(b, Length(b));
  key:=sha256.HashAsBytes;
  Result:=TEncoding.UTF8.GetString(TAES.Decrypt(HexStringToBytes(lic), key, 256, copy(key,Length(key) div 2,Length(key) div 2), cmCBC, pmzeropadding));
  i:=Pos(Check, Result);
  if i>0 then Result:=Copy(Result, 1, i-1)
  else Result:='';
except
  Result:='';
end;
end;

function GenLic(DeviceID, CompInfo:string):string;
var
sha256:THashSHA2;
id2:string;
key, b:TBytes;
l, i:integer;
begin
  sha256:=THashSHA2.Create;
  b:=TEncoding.UTF8.GetBytes(DeviceID);
  sha256.Update(b, Length(b));
  id2:=BytesToHexString(sha256.HashAsBytes);

  sha256.Reset;
  SetLength(b,0);
  b:=TEncoding.UTF8.GetBytes(id2+DeviceID+id2+id2);
  sha256.Update(b, Length(b));
  CompInfo:=CompInfo+#13#10+BytesToHexString(sha256.HashAsBytes) ;
  sha256.Reset;
  SetLength(b,0);

  b:=TEncoding.UTF8.GetBytes(id2+DeviceID+DeviceID);
  sha256.Update(b, Length(b));
  key:=sha256.HashAsBytes;
  sha256.Reset;
  SetLength(b,0);

  b:=TEncoding.UTF8.GetBytes(CompInfo);
  l:=Length(b);
  if (l mod 16)<>0 then
    SetLength(b, l+16-(l mod 16));
  for i:=l to Length(b)-1 do b[i]:=0;

  Result:=BytesToHexString(TAES.Encrypt(b, key, 256, copy(key,Length(key) div 2,Length(key) div 2), cmCBC, pmzeropadding));
end;


end.