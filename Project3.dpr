program Project3;

{$R *.dres}

uses
  Vcl.Forms,
  uMethodsData in 'uMethodsData.pas',
  uDesigner in 'uDesigner.pas' {frmDesigner},
  uGame in 'uGame.pas' {frmGame},
  uMainMenu in 'uMainMenu.pas' {frmMain},
  uScores in 'uScores.pas' {frmScores},
  uUserInfo in 'uUserInfo.pas' {frmUserInfo},
  uButtonMessage in 'uButtonMessage.pas' {frmButtonMessage},
  Vcl.Themes,
  Vcl.Styles,
  uHelp in 'uHelp.pas' {frmHelp};

{$R *.res}

begin
  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmGame, frmGame);
  Application.CreateForm(TfrmDesigner, frmDesigner);
  Application.CreateForm(TfrmScores, frmScores);
  Application.CreateForm(TfrmUserInfo, frmUserInfo);
  Application.CreateForm(TfrmButtonMessage, frmButtonMessage);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.Run;
end.
