program MnrAndSvc;

uses   fastmm5,
  Vcl.SvcMgr,
  main in 'main.pas' {MnrAndService: TService},
  ServerU in 'ServerU.pas' {Server: TDataModule},
  lic in '..\lic\lic.pas',
  log in 'log.pas';

{$R *.RES}

begin
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TMnrAndService, MnrAndService);
  Application.Run;
end.
