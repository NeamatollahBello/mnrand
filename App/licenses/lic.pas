unit lic;


interface
uses sysutils;

function GenLic(DeviceID, CompInfo:string):string;


implementation

uses Hash, Prism.Crypto.AES;

function BytesToHexString(b:TBytes):string; overload;
var
i:integer;
begin
  Result:='';
  for i:=0 to Length(b)-1 do
  begin
    Result:=Result+IntToHex(b[i],2).ToLower;
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

  b:=TEncoding.UTF8.GetBytes(id2+DeviceID+id2);
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