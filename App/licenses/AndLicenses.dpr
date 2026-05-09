program AndLicenses;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  AddLic in 'AddLic.pas' {AddLicForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAddLicForm, AddLicForm);
  Application.Run;
end.
