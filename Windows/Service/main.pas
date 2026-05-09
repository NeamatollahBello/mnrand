unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.SvcMgr, Vcl.Dialogs, ServerU, comobj;

type
  TMnrAndService = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  MnrAndService: TMnrAndService;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  MnrAndService.Controller(CtrlCode);
end;

function TMnrAndService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TMnrAndService.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
  Continued:=False;
end;

procedure TMnrAndService.ServiceExecute(Sender: TService);
begin
while not Terminated do
begin
  ServiceThread.ProcessRequests(True);
end;
end;

procedure TMnrAndService.ServicePause(Sender: TService; var Paused: Boolean);
begin
  Paused:=False;
end;

procedure TMnrAndService.ServiceStart(Sender: TService; var Started: Boolean);
begin
CoInitializeEx(nil, 2);
Started:=True;
try StartServer; except ExitProcess(0); end;
end;

procedure TMnrAndService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
StopServer;
end;

end.
