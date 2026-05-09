unit log;

interface
uses sysutils, classes, windows, SyncObjs;

procedure LogStr(s:string);
implementation
var
ct:TCriticalSection;
lgfs:TFileStream;

procedure LogStr(s:string);
begin
  s:=FormatDateTime('dd / MM / yyyy hh:mm:ss', Now)+': '+s.Replace(#13#10, '\n').Replace(#13, '\n').Replace(#10, '\n')+#13#10;
  ct.Acquire;
  try lgfs.Write(s[1], Sizeof(char)*Length(s)); except end;
  ct.Release;
end;

initialization
  ct:=TCriticalSection.Create;
  var fm:=fmOpenReadWrite or fmShareDenyNone;
  if not FileExists(IncludeTrailingBackslash(ExtractFileDir(GetModuleName(hInstance)))+'log.txt') then fm:=fm or fmCreate;
  lgfs:=TFileStream.Create(IncludeTrailingBackslash(ExtractFileDir(GetModuleName(hInstance)))+'log.txt', fm);
  lgfs.Seek(0, soEnd);
finalization
  lgfs.Destroy;
  ct.Destroy;
end.
