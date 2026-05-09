program mnrAnd;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  DataU in 'DataU.pas' {EData: TDataModule},
  SelectServer in 'SelectServer.pas' {SelectServerForm},
  lic in '..\lic\lic.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TEData, EData);
  Application.Run;
end.
