program WinLicenses;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  AddLic in 'AddLic.pas' {AddLicForm},
  lic in '..\lic\lic.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAddLicForm, AddLicForm);
  Application.Run;
end.
